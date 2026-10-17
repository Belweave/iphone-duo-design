# Changelog

## 0.2.0 — 2026-10-17
Expanded the skill into a full iPhone Duo toolkit for coding agents.

### Added
- `scripts/duo-lint`: a stdlib-only Python scanner for Swift with 13 rules (DUO001–DUO013). It supports text and JSON output, `--min-width`, `--strict`, `--disable`, and inline suppressions. Each rule cites its Apple source.
- `tests/`: a `unittest` suite with good and bad SwiftUI and UIKit fixtures; every rule is exercised.
- `templates/swiftui/` and `templates/uikit/`:
  - size-class root
  - split-view collapse
  - split and overlay arrangements (`ArrangementView`, `UIArrangementViewController`)
  - fold-aware controls and even-column grid (`reservedRegions`)
  - single-button sheet vertical-bar opt-out
  - game fill
  - vertical bar organization
- `templates/swiftui/DuoPreviewMatrix.swift`: previews across Apple's documented size-class configurations. It doesn't invent display sizes.
- `tools/duo-preview.html` (design helper, merged from the design team): an offline visual previewer with fold, side-control, Split View and arrangement overlays. The fold axis is labeled unverified, and the Apple-unpublished values stay as empty "set from Apple docs" inputs.
- `references/`:
  - `api-index.md`: every API linked to its Apple doc page
  - `sources.md`: sources and claim ledger
  - `test-plan.md`: pose by pose
  - `review-rubric.md`: scored, linked to the checklist
  - `migration-guide.md`
  - `design-review-checklist.md`: design helper, now linked to the rubric
- `prompts/review-screen.md`: an agent prompt for reviewing a screen with the linter, rubric and test plan.
- Install paths, each checked against official docs:
  - a Claude Code plugin and marketplace (`.claude-plugin/`, passes `claude plugin validate .`)
  - Cursor skills folders plus an optional `.mdc` rule and `AGENTS.md` snippet
  - Codex `.agents/skills` plus `AGENTS.md`
  - `npx skills add`
- A "What's inside" table in the README, plus screenshots of the preview tool.
- New evals for the linter, templates, preview tools, review prompt, migration and install, plus trigger cases.

### Corrected
- Size-class table: the inner display is regular/regular in both orientations. v0.1 listed inner landscape as regular/compact. Split View halves are now marked as not stated by Apple.
- Reserved-region API names are now exact: `GeometryProxy.reservedRegions(kind:options:layoutDirectionBehavior:)` and `UIView.reservedRegions(kind:options:)`, with kinds `.division` and `.occlusion` and the option `.includeInactive`.
- Re-verified against Apple and kept, now with citations: "Xcode Device Hub", "iOS 27.1 SDK" (with Xcode 27.1), and `ArrangementView`.
- Claims that are still unverified, such as the fold axis wording, a "collapse secondary" API, and change notifications, are listed in `references/sources.md` and in the files that touch them.

### Changed
- `SKILL.md` frontmatter is now `name`, `description` and `license` only. The non-standard `type` and `lifecycle` keys were removed.

## 0.1.0 — 2026-10-17
- Initial skill, created from Apple's Design for iPhone Duo video and the HIG.
