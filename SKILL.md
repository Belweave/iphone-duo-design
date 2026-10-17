---
name: iphone-duo-design
description: "Design, build, lint and review iOS apps for iPhone Duo, Apple's foldable iPhone. Use when adapting SwiftUI or UIKit layouts for the outer and inner displays, size classes, vertical (side) bars, the fold and reserved regions, split views, ArrangementView, sheets, Split View multitasking, games, or when reviewing or testing an app on iPhone Duo."
license: MIT
---

# iPhone Duo design toolkit

This skill helps you make iOS apps feel native on iPhone Duo, across the compact **outer** display (closed), the large **inner** display (open), every pose, and Split View multitasking. It's grounded only in Apple's pages; see `references/sources.md`. Never invent API names, SDK versions, tools or dimensions. If Apple doesn't document something, say so.

## Route the task

| The user wants to… | Do this |
|---|---|
| Understand the rules | Read the principles below, then `references/hig-summary.md` |
| Find the exact API for something | `references/api-index.md`. Only name APIs listed there |
| Scan a Swift project for problems | Run `scripts/duo-lint <paths>` (Python 3 stdlib). Add `--format json` for machine output and `--list-rules` for the rules. Confirm each finding by reading the code |
| Write new SwiftUI or UIKit code | Start from `templates/` (see the table below) |
| Migrate an existing app | Follow `references/migration-guide.md` step by step |
| Check size-class branches in Xcode previews | `templates/swiftui/DuoPreviewMatrix.swift` |
| Eyeball a screenshot with fold, side-control, Split View and arrangement overlays | Open `tools/duo-preview.html` in a browser (offline, no dependencies) |
| Test on the simulator or a device | `references/test-plan.md` (Device Hub, pose by pose) |
| Review or grade a screen | `prompts/review-screen.md`, which drives `references/review-rubric.md` + `references/test-plan.md`. Designers can use `references/design-review-checklist.md` |
| Check what is verified vs. unverified | `references/sources.md` (claim ledger) |

### Templates (`templates/swiftui/` and `templates/uikit/`)
| Need | SwiftUI | UIKit |
|---|---|---|
| Size-class root (outer compact / inner regular) | `SizeClassRoot.swift` | `SizeClassRootViewController.swift` |
| List and detail that collapses when closed | `SplitViewCollapse.swift` | `SplitViewCollapse.swift` |
| Split and overlay arrangements (iOS 27.1) | `ArrangementPatterns.swift` | `ArrangementPatterns.swift` |
| Fold-aware custom controls, camera-aware badge, even-column grid | `FoldAwareControls.swift` | `FoldAwareControlView.swift` |
| Single-button sheet that opts out of the vertical bar | `SheetVerticalBarOptOut.swift` | `SheetVerticalBarOptOut.swift` |
| Game surface that fills every pose | `GameFill.swift` | `GameFillViewController.swift` |
| Bar items organized for vertical presentation | `VerticalBars.swift` | `VerticalBars.swift` |
| Preview matrix over Apple's size-class configurations | `DuoPreviewMatrix.swift` | — |

The templates target Xcode 27.1 and the iOS 27.1 SDK for the Duo-specific symbols. They haven't been compiled in this repository's CI (there's no iOS SDK on Linux). Each file cites its Apple sources and marks anything Apple doesn't document.

## Core principles

1. **Design for two size classes, not every pose.** Compact width is the outer display and regular width is the inner display (Tech Talk 111466). Outer portrait is compact/regular, outer landscape compact/compact, and inner regular/regular (Tech Talk 111461). Don't build a custom layout per pose.
2. **Build freely resizable layouts.** Use layout margins, safe-area insets and size classes. Size relative to the container. Don't use fixed widths, `UIScreen.main`, `userInterfaceIdiom` or interface orientation for layout. The inner display doesn't honor supported orientations.
3. **Keep one consistent experience.** The same functionality, controls and hierarchy appear on both displays. The inner display may add one hierarchy level. Never tie a feature to a pose.
4. **Let the system put bars on the side.** Toolbars, tab bars and navigation controls go vertical everywhere except the inner display in portrait. Use navigation containers, give each item a title and a symbol, group items, set priorities, and use the system overflow menu.
5. **Respect reserved regions.** These are the outer camera (always), the inner camera (while active) and the fold (when partially open). System components avoid them automatically. For custom interactive views, query `reservedRegions(kind: .division / .occlusion)` and make small moves. Scrolling content may cross the fold. Prefer even grid column counts.
6. **Use the right container.** Use a split view for list and detail. Use `ArrangementView` / `UIArrangementViewController` (split for HStack or VStack layouts, overlay for ZStack layouts) for two-pane content, with navigation outside.

## Quick checklist
- [ ] Layout is driven by size classes and container bounds, with no orientation, idiom or main-screen checks (`duo-lint` DUO001–004)
- [ ] No fixed widths; safe areas are handled per side (DUO002, DUO007)
- [ ] Bars come from navigation containers, each item has a title and a symbol, items are grouped and prioritized, and the system overflow menu is used (DUO005, DUO010–012)
- [ ] Interactive custom views stay off active fold and camera regions, and grids are even (DUO008, DUO009)
- [ ] `ignoresSafeArea` is used only on backgrounds (DUO006). Arrangements aren't nested in a List, ScrollView or NavigationSplitView (DUO013)
- [ ] Sheets keep the default vertical bar unless it's a deliberate single-button opt-out
- [ ] Built with Xcode 27.1 and the iOS 27.1 SDK, and tested in **Device Hub** with the iPhone Duo simulator: Closed, Partially Open and Open, rotated, Split View on both sides, and pinned PiP

## Not published by Apple (never hard-code or guess)
Apple doesn't publish point dimensions, scale factor, safe-area or margin values, the side-control width, the folded fold width (it's zero when flat), or the camera region size. Read live values at runtime instead. Apple also never states the fold's axis in words; see `references/sources.md`.

## Sources
- HIG, Designing for iPhone Duo: https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo
- Preparing your app for iPhone Duo: https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo
- Tech Talk, Design for iPhone Duo: https://developer.apple.com/videos/play/tech-talks/111466/
- Related Tech Talks 111461 to 111463, Device Hub and the API pages: `references/sources.md` and `references/api-index.md`
