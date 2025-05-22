// interface ChangelogEntry {
//     summary: string,
//     timestamp: string,
//     authors?: string[],
//     description?: string,
// }

/**
 * Semantic Version
 * @pattern ^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$
 */
type Semver = string;

type SupportedGame = "jak1" | "jak2" | "jak3" | "jakx";

export interface ModMetadata {
  schemaVersion: Semver;
  version: Semver;
  publishedDate: string;
  supportedGames: SupportedGame[];
}
