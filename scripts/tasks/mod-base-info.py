#!/usr/bin/env python3
import subprocess
import sys
import os
import time
from pathlib import Path
from datetime import datetime

HARDCODED_URL = "https://github.com/OpenGOAL-Mods/OG-Mod-Base.git"
REMOTE_NAME = "og-upstream"
BRANCH = "main"

def run_git_streaming(*args):
    """Run git command and stream output live to console"""
    cmd = ["git"] + list(args)
    print(f"Running: {' '.join(cmd)}", file=sys.stderr)
    
    process = subprocess.Popen(
        cmd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
        universal_newlines=True,
        cwd=Path.cwd()
    )
    
    while True:
        line = process.stdout.readline()
        if not line and process.poll() is not None:
            break
        if line:
            print(line, end="", flush=True)
    
    return_code = process.wait()
    if return_code != 0:
        print(f"\nGit command failed (code {return_code})", file=sys.stderr)
        sys.exit(1)

def run_git_capture(*args, timeout=300):
    """Fallback: run git and capture output with timeout"""
    cmd = ["git"] + list(args)
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            check=True,
            timeout=timeout,
            cwd=Path.cwd()
        )
        return result.stdout.strip()
    except subprocess.TimeoutExpired:
        print(f"\nCommand timed out after {timeout}s", file=sys.stderr)
        sys.exit(1)
    except subprocess.CalledProcessError as e:
        print("Git error:", e.stderr.strip() or "(no details)", file=sys.stderr)
        sys.exit(1)

def remote_exists(name):
    try:
        subprocess.run(["git", "remote", "get-url", name], capture_output=True, check=True, timeout=10)
        return True
    except:
        return False

def days_ago(date_str):
    """Calculate approximate days since the given git %ci date string"""
    if not date_str:
        return "???"
    try:
        dt = datetime.strptime(date_str, "%Y-%m-%d %H:%M:%S %z")
        now = datetime.now(dt.tzinfo)
        delta = now - dt
        return delta.days
    except ValueError:
        try:
            naive_str = date_str.rsplit(" ", 1)[0]
            dt_naive = datetime.strptime(naive_str, "%Y-%m-%d %H:%M:%S")
            now_naive = datetime.now()
            delta = now_naive - dt_naive
            return delta.days
        except Exception:
            return "???"

def main():
    current_branch = subprocess.getoutput("git rev-parse --abbrev-ref HEAD") or "(unknown)"
    print(f"Current branch: {current_branch}\n")

    url = HARDCODED_URL
    remote = REMOTE_NAME

    if remote_exists(remote):
        print(f"Remote '{remote}' exists → updating URL")
        subprocess.run(["git", "remote", "set-url", remote, url], check=True)
    else:
        print(f"Adding remote '{remote}' → {url}")
        subprocess.run(["git", "remote", "add", remote, url], check=True)

    subprocess.run(["git", "remote", "set-url", "--push", remote, "no_push"], check=False)

    print(f"\nFetching '{BRANCH}' branch from upstream...")
    print("(May take 30s–5min — watch network in Task Manager if silent)\n")

    start = time.time()
    try:
        run_git_streaming("fetch", remote, BRANCH, "--progress")
    except Exception as e:
        print(f"Streaming fetch failed: {e}", file=sys.stderr)
        print("Falling back to captured fetch...\n")
        run_git_capture("fetch", remote, BRANCH, "--progress")

    elapsed = time.time() - start
    print(f"\nFetch completed in {elapsed:.1f} seconds\n")

    remote_ref = f"{remote}/{BRANCH}"

    merge_base = run_git_capture("merge-base", "HEAD", remote_ref)
    if not merge_base:
        print("No common commits found between your branch and upstream main.", file=sys.stderr)
        sys.exit(1)

    subject = run_git_capture("log", "-1", "--format=%s", merge_base)
    date_str = run_git_capture("log", "-1", "--format=%ci", merge_base)
    author  = run_git_capture("log", "-1", "--format=%an <%ae>", merge_base)

    print("Most recent shared commit:")
    print(f"  {merge_base}")
    print(f"  {date_str}")
    print(f"  {author}")
    print(f"  {subject}\n")

    # print("\nCleaning up and removing temporary remote...")
    # try:
    #     subprocess.run(["git", "remote", "prune", REMOTE_NAME], check=False, capture_output=True)
    #     subprocess.run(["git", "remote", "remove", REMOTE_NAME], check=True)
    #     print("Optimizing local storage (garbage collection)...")
    #     subprocess.run(["git", "gc", "--prune=now", "--quiet"], check=False)
        
    #     print("Temporary remote 'og-upstream' and associated data removed.\n")
    # except Exception as e:
    #     print(f"Cleanup note: {e}\n")
        
    print("\nDone. (Temporary remote kept for faster future runs)\n")

    commit_short = merge_base[:12] if merge_base else "unknown"
    github_link = f"https://github.com/OpenGOAL-Mods/OG-Mod-Base/commit/{merge_base}"
    days_since = days_ago(date_str)

    print(r"""
        ..:::::..        OpenGOAL mod base info
     .:-----------:.     [Version]: 1.0
         .-----.         Last synced with Mod-base {days_since} days ago!
          .---.          Last updated date: 12-31-2012
  .        ---        .  Last shared commit: {commit_short}
  -       :===:       -  Author: {author}
  --.   .--: :--.   .--  Message: {subject}
  .=======.    =======.  Link:
   .-=====-. .-=====-    {github_link}
     .-===========-.     Source File Search Dirs: []
         .-===-.         (lt) to connect to the game
            .            (mi) to recompile the active project.
                        
                        
               Press E to exit
""".format(
        commit_short=commit_short,
        github_link=github_link,
        days_since=days_since,
        author=author,
        subject=subject,
        date_str=date_str
    ))

    # Wait for user to press 'e' or 'E' before closing
    print("Waiting for input...", end="", flush=True)
    while True:
        key = sys.stdin.read(1).lower()
        if key == 'e':
            print("\nExiting...")
            break

if __name__ == "__main__":
    main()