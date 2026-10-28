# Changelog

## 0.4.0 — 2026-10-28
belweave's fold-aware layout practice, a small fold-preview page, and two lint checks that can see it in code.

### Added
- `references/fold-aware-layout.md`: two layouts that flex, the path from general to specific, fixed pane pairs, journeys across the fold, full screen on one button, navigation while open, judging motion, reach, a short toolbar, what may sit under the bar, gutters judged by eye, and panel states. This is belweave's practice. It is not an Apple source, and `references/sources.md` says so.
- A working method in `SKILL.md`: compare several versions, preview the fold, watch a recording at full speed and at quarter speed, keep the rules in the skill or in `AGENTS.md`, and test on a real iPhone Duo.
- `tools/fold-preview.html`: a dependency-free drawing of a Duo outline, a fold-angle slider, and two mockup slots.
- Lint rule DUO019: a destructive toolbar action, including Delete, outside the overflow menu.
- Checklist section 7, rubric evidence, test-plan rows B5, B6, D8, D9, and E9, and a review-prompt pass that uses them.
- An eval and a trigger for the fold-aware layout pass.

### Changed
- DUO006 now flags text that ignores the safe area, and its message names the toolbar. The background may run under the bar. Text and controls may not.
- Principle 1 now says the narrow and wide layouts flex through closed, open, portrait, landscape, and Split View.
- The test plan, the designer checklist, and `install/AGENTS.md` treat a simulator pass as the daily loop and a real iPhone Duo as the pass before ship.

## 0.3.0 — 2026-10-25
iPhone Duo on the App Store, and the iOS 27 / 27.1 APIs that shipped with it. Every new claim was checked against Apple's pages on this date. Where two Apple pages disagree, both sentences are quoted.

### Added
- `references/app-store.md`: the optimized-for-iPhone-Duo badge, screenshot sizes, featuring nominations that name every pose, and App Review Guidelines 2.3.14 and 2.5.19 (guidelines updated October 16, 2026).
- SDK tiers in `SKILL.md`: iOS 26 or earlier (centered, empty space when open), iOS 27 (fills most of the inner display), iOS 27.1 or later (full display and vertical bars). From April 2027, new uploads need the iOS 27 SDK. Side bars still need the iOS 27.1 SDK.
- How this skill sits next to Apple's App Resizability skill, including `xcrun agent skills export`.
- Camera direction (virtual front camera, `AVCaptureDeviceDirectionCoordinator`), `UIHingeInteraction` and SwiftUI `onHingeChange(isEnabled:_:)`, `UISceneAccessory` / `CameraCaptureAccessory` for the outer display, and multiple windows (new windows on the inner display only).
- Live Activities at limited width (`isDynamicIslandLimitedInWidth`, 28pt circle) and Liquid Glass notes for a build targeting iOS 27, including that `UIDesignRequiresCompatibility` is ignored.
- Resizable iPhone Mirroring on macOS 27 in the test plan.
- Lint rules DUO014–DUO018, with fixture and unit tests: hardcoded phone screen sizes, cropped hero images, a size read only at launch, treating regular width as iPad, and `UIDesignRequiresCompatibility` in Swift or a property list.
- Evals and trigger cases for the App Store page, Apple's exported skill, the hinge, and Liquid Glass.

### Flagged
- April 2027 Duo screenshots. Screenshot specifications say they are required "for any app using the iOS 27.1 SDK or later." The October 5 news post, the App Store Connect release notes, and What's New say "any apps or games submitted." Both are quoted. This skill does not pick one.
- "Xcode 27.1 or later" is this skill's floor. Apple's pages name Xcode 27.1 as the release to download and say "iOS 27.1 SDK or later" for the SDK. They don't write "or later" next to the Xcode version.
- `onHingeChange` is real. v0.2 listed it as unverified because the guessed URL was wrong. The symbol is `onHingeChange(isEnabled:_:)`, iOS 27.1.

### Changed
- Requirement lines now say **Xcode 27.1 or later** and the iOS 27.1 SDK.
- Hero templates choose fill or fit from the size class, matching the prepare page, so they stay clean under DUO015.

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
- `SKILL.md` and the README now point to the related [FoyerKit](https://github.com/Belweave/FoyerKit) package (0.1.0) for Liquid Glass intro screens.
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
