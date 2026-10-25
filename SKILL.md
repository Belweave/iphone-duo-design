---
name: iphone-duo-design
description: "Design, build, lint and review iOS apps for iPhone Duo, Apple's foldable iPhone. Use when adapting SwiftUI or UIKit layouts for the outer and inner displays, size classes, vertical (side) bars, the fold and reserved regions, split views, ArrangementView, sheets, Split View multitasking, games, the hinge, camera direction, multiple windows, Live Activities, Liquid Glass on iOS 27, App Store screenshots and the optimized-for-iPhone-Duo badge, or when reviewing or testing an app on iPhone Duo."
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
| Ship the App Store product page (badge, screenshots, featuring, guidelines) | `references/app-store.md` |
| Camera direction, the hinge, the outer display during capture, or extra windows | `references/hig-summary.md` (those sections) and `references/api-index.md` |
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

The templates target Xcode 27.1 or later and the iOS 27.1 SDK for the Duo-specific symbols. They haven't been compiled in this repository's CI (there's no iOS SDK on Linux). Each file cites its Apple sources and marks anything Apple doesn't document.

## Apple's App Resizability skill

Xcode 27.1's coding assistant includes an **App Resizability** skill. Tech Talk 111461 says that is the new name of the app modernization skill from WWDC26 session 278 ("Modernize your UIKit app"), and that it now covers SwiftUI and iPhone Duo. On the [prepare page](https://developer.apple.com/iphone-duo/prepare/), Step 1 is to ask Xcode's coding assistant to "get my app ready for iPhone Duo." The skill scans for the patterns in Step 2 of that page.

To use Apple's skills in another agent, export them from Terminal:

```sh
xcrun agent skills export
```

That writes Markdown files you import into your own workflow ([prepare page](https://developer.apple.com/iphone-duo/prepare/); [WWDC26 session 278](https://developer.apple.com/videos/play/wwdc2026/278/): "this will create markdown files that you can then import in your workflows").

Apple says the exported skill finds most issues, but not all of them. This skill is the rest of the pass: side bars, the fold, arrangements, sheets, games, camera direction, the hinge, scene accessories, multiple windows, Live Activities, Liquid Glass, the test plan, and the App Store product page. Run both. Where they disagree, follow the Apple page cited in `references/sources.md`.

## SDK tiers

What people see depends on the SDK you linked, not on a deployment target. From [Three steps to make your app shine on iPhone Duo](https://developer.apple.com/iphone-duo/prepare/):

| Linked SDK | On iPhone Duo |
|---|---|
| iOS 26 SDK or earlier | Open: the app sits in the center, with empty space around the window. Closed: content sits to the left of the status bar and camera. |
| iOS 27 SDK | The app fills most of the inner display and still avoids the status bar on the right edge. |
| iOS 27.1 SDK or later | The app uses the full display. Toolbars and tab bars lay out vertically under the status bar. This is the optimized layout. |

Build that last row with **Xcode 27.1 or later**. Apple's prepare page names the iPhone Duo simulator as part of Xcode 27.1, and says "iOS 27.1 SDK or later" for the full layout. Tech Talk 111461 says "download Xcode 27.1" for the full-screen experience. Later Xcode releases include that SDK, so this skill states the floor as Xcode 27.1 or later.

[Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo) still summarizes a build with Xcode 26 or earlier as one that doesn't extend under the status bar and camera. It doesn't spell out the centered window or the iOS 27 versus 27.1 split. Use the prepare page's three rows for that.

From April 2027, a new App Store upload has to be built with the **iOS 27 SDK** or later ([Submitting](https://developer.apple.com/app-store/submitting/)). That floor is not the 27.1 SDK. Side bars still need 27.1. Screenshot rules are separate and are quoted, including a disagreement between Apple pages, in `references/app-store.md`.

## Core principles

1. **Design for two size classes, not every pose.** Compact width is the outer display and regular width is the inner display (Tech Talk 111466). Outer portrait is compact/regular, outer landscape compact/compact, and inner regular/regular (Tech Talk 111461). Don't build a custom layout per pose.
2. **Build freely resizable layouts.** Use layout margins, safe-area insets and size classes. Size relative to the container. Don't use fixed widths, `UIScreen.main`, `userInterfaceIdiom` or interface orientation for layout. The inner display doesn't honor supported orientations.
3. **Keep one consistent experience.** The same functionality, controls and hierarchy appear on both displays. The inner display may add one hierarchy level. Never tie a feature to a pose.
4. **Let the system put bars on the side.** Toolbars, tab bars and navigation controls go vertical everywhere except the inner display in portrait. Use navigation containers, give each item a title and a symbol, group items, set priorities, and use the system overflow menu.
5. **Respect reserved regions.** These are the outer camera (always), the inner camera (while active) and the fold (when partially open). System components avoid them automatically. For custom interactive views, query `reservedRegions(kind: .division / .occlusion)` and make small moves. Scrolling content may cross the fold. Prefer even grid column counts.
6. **Use the right container.** Use a split view for list and detail. Use `ArrangementView` / `UIArrangementViewController` (split for HStack or VStack layouts, overlay for ZStack layouts) for two-pane content, with navigation outside.

## Quick checklist
- [ ] Layout is driven by size classes and container bounds, with no orientation, idiom, main-screen, or hardcoded phone-size checks, and the size is read again when the window changes (`duo-lint` DUO001–004, DUO014, DUO016, DUO017)
- [ ] No fixed widths; safe areas are handled per side (DUO002, DUO007)
- [ ] Hero images and video choose fill or fit from the size class or aspect ratio, instead of an unconditional aspect fill (DUO015)
- [ ] Bars come from navigation containers, each item has a title and a symbol, items are grouped and prioritized, and the system overflow menu is used (DUO005, DUO010–012)
- [ ] Interactive custom views stay off active fold and camera regions, and grids are even (DUO008, DUO009)
- [ ] `ignoresSafeArea` is used only on backgrounds (DUO006). Arrangements aren't nested in a List, ScrollView or NavigationSplitView (DUO013)
- [ ] Sheets keep the default vertical bar unless it's a deliberate single-button opt-out
- [ ] Built with Xcode 27.1 or later and the iOS 27.1 SDK. `UIDesignRequiresCompatibility` is absent, because the system ignores that key when you build for iOS 27 or later and the app can't opt out of Liquid Glass (DUO018)
- [ ] Tested in **Device Hub** with the iPhone Duo simulator (Closed, Partially Open, Open, rotated, Split View on both sides, pinned PiP) and by resizing **iPhone Mirroring** on macOS 27
- [ ] App Store Connect has iPhone Duo screenshots, so the product page can show the optimized-for-iPhone-Duo badge (`references/app-store.md`)

## Not published by Apple (never hard-code or guess)
Apple doesn't publish point dimensions, scale factor, safe-area or margin values, the side-control width, the folded fold width (it's zero when flat), or the camera region size. Read live values at runtime instead. Apple also never states the fold's axis in words; see `references/sources.md`.

## Liquid Glass on iOS 27

Standard SwiftUI, UIKit, and AppKit components pick up Liquid Glass when you build with the latest SDK ([Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)). On iPhone Duo that includes the bars that move to the side. Custom backgrounds on tab bars, toolbars, split views, and controls can cover the material; remove them and let the system draw the bar.

`UIDesignRequiresCompatibility` in Info.plist is a temporary compatibility mode. Its page says the system **ignores this key when you build for iOS 27 or later** ([UIDesignRequiresCompatibility](https://developer.apple.com/documentation/bundleresources/information-property-list/uidesignrequirescompatibility)). A build for iOS 27 or later can't opt out of Liquid Glass. `duo-lint` flags the key as DUO018, including in a property list.

For a first-launch intro or welcome screen in Liquid Glass, [FoyerKit](https://github.com/Belweave/FoyerKit) is an easy Swift package to use. It's a Liquid Glass intro kit from belweave, separate from this skill.

```swift
.package(url: "https://github.com/Belweave/FoyerKit.git", from: "0.1.0")
```

## Sources
- HIG, Designing for iPhone Duo: https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo
- Preparing your app for iPhone Duo: https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo
- Tech Talk, Design for iPhone Duo: https://developer.apple.com/videos/play/tech-talks/111466/
- Three steps to make your app shine on iPhone Duo: https://developer.apple.com/iphone-duo/prepare/
- Tech Talks 111461 to 111465, Device Hub, App Store, and the API pages: `references/sources.md` and `references/api-index.md`
