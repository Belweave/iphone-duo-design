---
description: "Every Apple source this skill relies on, plus a ledger of which claims are verified, corrected, or unverified."
connections: [api-index, hig-summary]
---

# Sources and claim ledger

Ground truth for this skill is Apple's own pages and the Apple API docs they link to. Nothing else counts as a source for iPhone Duo facts. Checked on 2026-10-17.

## Primary pages

| Short name | URL |
|---|---|
| HIG | https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo (Markdown: https://developer.apple.com/tutorials/data/design/human-interface-guidelines/designing-for-iphone-duo.md) |
| Preparing your app | https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo |
| Tech Talk 111466, Design for iPhone Duo | https://developer.apple.com/videos/play/tech-talks/111466/ |

## Apple pages those link to (also used)

| Short name | URL |
|---|---|
| Tech Talk 111461, Prepare your app for iPhone Duo | https://developer.apple.com/videos/play/tech-talks/111461/ |
| Tech Talk 111462, Raise the bar with iPhone Duo | https://developer.apple.com/videos/play/tech-talks/111462/ |
| Tech Talk 111463, Strike a pose with adaptive layouts on iPhone Duo | https://developer.apple.com/videos/play/tech-talks/111463/ |
| Tech Talk 111464, Leverage multiple displays and scenes on iPhone Duo | https://developer.apple.com/videos/play/tech-talks/111464/ |
| Device Hub | https://developer.apple.com/documentation/xcode/device-hub |
| Interacting with your app in Device Hub (iPhone Duo pose buttons) | https://developer.apple.com/documentation/xcode/interacting-with-your-app-in-device-hub |
| Screenshot specifications | https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications |
| Automatic trait tracking | https://developer.apple.com/documentation/uikit/automatic-trait-tracking |
| API symbol pages | see `references/api-index.md` |

## Claims from the first release, re-checked

| Claim in v0.1 | Status | What Apple says |
|---|---|---|
| "Xcode Device Hub" for testing poses | **Verified** | The HIG links `Xcode/device-hub`. The Device Hub page and "Interacting with your app in Device Hub" describe the iPhone Duo simulator's Closed, Partially Open and Open buttons, and Option-dragging the slider to fold to any angle. |
| "Build with iOS 27.1+ SDK" | **Verified** | Tech Talk 111461: "When you build your app with the iOS 27.1 SDK, your app extends to the edge of the screen. Standard navigation and toolbar buttons now lay out vertically under the status bar. To get the full-screen experience, download Xcode 27.1." The API pages list availability as iOS 27.1. Preparing your app adds that apps built with Xcode 26 and earlier don't extend under the status bar and camera. |
| `ArrangementView` | **Verified** | SwiftUI `ArrangementView` (iOS 27.1) with `arrangementViewStyle(_:)`. The styles are `.split` and `.overlay`, plus `axes(_:)`. The UIKit counterpart is `UIArrangementViewController`. |
| "SwiftUI `reservedRegions` / UIKit `reservedRegions`" | **Corrected (made precise)** | SwiftUI: `GeometryProxy.reservedRegions(kind:options:layoutDirectionBehavior:)` returns `[ReservedRegion]`. UIKit: `UIView.reservedRegions(kind:options:)` returns `[UIView.ReservedRegion]`. The kinds are `.division` and `.occlusion`, and the option is `.includeInactive`. |
| Size-class table: inner landscape = regular w / **compact** h | **Corrected** | Tech Talk 111461: the inner display "has regular horizontal and vertical size classes." Outer portrait is compact w / regular h, and outer landscape is compact w / compact h. |
| "Split View (each half): varies" | **Flagged** | Apple doesn't state the size classes of a Split View half on these pages. |
| "Wide items (text buttons, segmented controls) stay in place" | **Verified** | Tech Talk 111466: items too wide for the side "should stay put in the nav bar". Preparing your app: title-only and custom-view items aren't presented vertically, and `axisBehavior` controls inclusion. |
| "Disable vertical bar for single-button sheets" | **Verified** | Tech Talk 111466. The API is `toolbarVerticalBehavior(.disabled)` in SwiftUI and `preferredVerticalBarBehavior` → `.disabled` in UIKit. |
| "Controls on right side" (outer, closed) | **Verified** | Tech Talk 111466: controls move "to the right side of the display". |
| "Tab bar: bottom-aligned on side" | **Verified** | Tech Talk 111466: "if you have a tab bar, it stays bottom aligned." |
| "Sidebar tab bar (Health-style)" | **Verified** | Tech Talk 111466. The API from Tech Talk 111461 is `defaultTabBarPlacement(.sidebar)` in SwiftUI and `tabBarController.sidebar.preferredPlacement = .sidebar` in UIKit. |
| "Picture-in-Picture + fold" test case | **Verified** | Tech Talk 111466: PiP can pin to the top. When partially folded, the video fills half the screen and apps resize vertically. |
| README: "Apple's Design for iPhone Duo guidance" | **Verified** | That's the title of Tech Talk 111466. |

## Claims that are still unverified (don't present them as fact)

- **Fold axis per orientation.** Apple never says outright that the fold is vertical in landscape and horizontal in portrait. That reading is inferred from Apple's descriptions:
  - In book pose, content moves to the left and right sides.
  - In portrait when folded, interactive elements move to the bottom half.
  - In tabletop pose, there are top and bottom regions.
  - The overlay arrangement puts views in the "trailing or bottom" and "leading or top" parts relative to the fold.

  `tools/duo-preview.html` draws it that way, labelled "unverified".
- **Size classes in Split View and with pinned PiP.** These aren't stated.
- **Numbers.** Apple doesn't publish point dimensions, scale factor, safe-area or margin values, the side-control width, the folded fold width, or the camera region size. The flat fold has zero width (Tech Talk 111463).
- **A "collapse secondary" API for overlay arrangements.** The HIG says you can "collapse the secondary view in an overlay arrangement", but the `ArrangementView` and `OverlayArrangementViewStyle` pages list only `init()` and `axes(_:)`. Tech Talk 111463 instead reads `overlayArrangementZIndex` (SwiftUI) or `state(for:).zIndex` (UIKit) and swaps in a collapsed version of the view.
- **Default active/inactive filtering.** The `ReservedRegion` page says the query returns regions "regardless of whether they are currently active". Tech Talk 111463 says only active regions come back by default, and `includeInactive` exists. The templates filter on `isActive` explicitly.
- **Change notifications.** No Apple page here names a notification for reserved-region or arrangement changes in UIKit. The templates re-query during layout and say so.
- **Vertical-bar resolution for presented UIKit navigation controllers.** The SwiftUI doc explains how containers resolve it, but the UIKit doc doesn't.
- **`onHingeChange` (Tech Talk 111464).** It appears in the talk's sample code, but its API page wasn't found at the guessed URL, so this repo doesn't use it.
- **Naming.** Tech Talk 111461 says "UIViewReservedRegion". The API page title is `UIView.ReservedRegion` (Swift), and this repo uses the API page name.
- **"App Resizability" Xcode skill.** It's mentioned in Tech Talk 111461 ("With Xcode 27.1, this skill has a new name: App Resizability"). It's referenced but not documented further here.
