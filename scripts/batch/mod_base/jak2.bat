@echo off
task set-game-jak2
task extract
out\build\Release\bin\goalc --user-auto --game jak2 --auto-mi-exit true
out\build\Release\bin\gk -v --game jak2 -- -boot -fakeiso -debug
pause
