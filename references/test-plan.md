---
description: "Pose-by-pose manual test plan for iPhone Duo, run in Xcode's Device Hub simulator or on a device."
connections: [review-rubric, design-review-checklist]
---

# iPhone Duo pose-by-pose test plan

**Setup.**
- Build with **Xcode 27.1 or later** and the **iOS 27.1 SDK**. That is the SDK that extends to the screen edge and lays bars out vertically (Tech Talk 111461, [prepare page](https://developer.apple.com/iphone-duo/prepare/)). An iOS 27 SDK build still avoids the status bar on the right edge. An iOS 26 SDK (or earlier) build sits centered, with empty space around it, when the device is open.
- Run on the **iPhone Duo simulator in Device Hub**:
  - Use the **Closed**, **Partially Open** and **Open** buttons below the bezel.
  - Option-drag the slider to fold to any angle.
  - Rotate with the rotate buttons.

  See [Interacting with your app in Device Hub](https://developer.apple.com/documentation/xcode/interacting-with-your-app-in-device-hub). Iterate there. Before you ship, run the same poses on a real iPhone Duo ([Running your app](https://developer.apple.com/documentation/xcode/running-your-app-on-simulated-or-physical-devices)). The simulator pass is not the last one.

**Before you start.**
- Run `scripts/duo-lint <your project>` and fix or justify every finding.
- Open `tools/duo-preview.html` with a screenshot of each key screen to check side-control, safe-area and fold overlays at a glance.
- Open `tools/fold-preview.html` with the closed and open mockups and scrub the fold slider.
- If you record the session, watch it at full speed and then at quarter speed.

**How to record results.** Give each case Pass, Fail or N/A, with a screenshot. Run the whole plan on every **screen, sheet, popover and alert** that matters, not just the root (Preparing your app: "Navigate through your app, checking each view, sheet, and popover").

## A. Poses and displays

| # | Configuration | Expect (Apple source) |
|---|---|---|
| A1 | **Closed, outer display, portrait** | The compact-width layout. Bars and tab bar are on the **right side** and the tab bar stays bottom-aligned. Content is inset from the side controls and the always-present outer camera ([TT 111466](https://developer.apple.com/videos/play/tech-talks/111466/), HIG) |
| A2 | **Closed, outer display, landscape** | Compact width and compact height. Nothing is cropped and every control is reachable. If you lock orientation, the layout still fills the screen (HIG, TT 111461) |
| A3 | **Open, inner display, portrait** | Regular width and regular height. **Horizontal bars** are used here, the one pose that keeps them (HIG) |
| A4 | **Open, inner display, landscape** | Regular width. Bars **stay on the side** for continuity (HIG) |
| A5 | **Partially Open, landscape (book)** | No tappable element sits in the center fold. Text and images move off the curve. Split views even out to 50/50. Sheets, alerts and menus slide aside (TT 111466, TT 111463) |
| A6 | **Partially Open, portrait (tabletop)** | Interactive elements favor the bottom region and glanceable content the top. An optional tabletop layout must keep every control and the same hierarchy (TT 111466, TT 111463) |
| A7 | **Any fold angle** (Option-drag the slider) | The layout settles without jumps or flicker. Controls move only a little (HIG: "favor small adjustments over rearrangement"). Watch a recording at full speed, then at quarter speed (`fold-aware-layout.md`) |
| A8 | **Inner camera active** (if your app uses the camera) | No important control sits under the inner camera's occlusion region while it's active (HIG, Preparing your app) |

## B. Transitions (state continuity)

| # | Action | Expect |
|---|---|---|
| B1 | Open the device mid-task (closed → open) | Same screen, same selection, same scroll position and same draft text. The inner display may add one hierarchy level, such as list plus detail (HIG). A detail that was open sits beside its parent, and the path order is unchanged (`fold-aware-layout.md`) |
| B2 | Close the device mid-task (open → closed) | The split view collapses to the selected item and nothing is lost (TT 111461) |
| B3 | Fold and unfold repeatedly on a busy screen | No layout loops, no controls disappearing, and the same controls available (HIG) |
| B4 | Rotate in each pose | The layout follows size classes and bounds, never orientation. On the inner display the app scales even if it doesn't support that orientation (TT 111461) |
| B5 | On the open phone, open a list while content is showing | The list is on the left. The current content stays on the right until a row is picked (`fold-aware-layout.md`) |
| B6 | Open the sidebar while a file or detail is open, then close the sidebar | The detail hides while the sidebar is open and returns when the sidebar closes (`fold-aware-layout.md`) |

## C. Multitasking and media

| # | Action | Expect |
|---|---|---|
| C1 | **Split View 50/50, your app on the left** (drag from the home indicator) | Controls sit on the **left** (outer) edge and content is inset from them (TT 111466, TT 111461) |
| C2 | **Split View, your app on the right** | Controls on the right. Nothing assumes left and right insets are equal (TT 111461) |
| C3 | **Picture in Picture pinned to the top** | Your app resizes vertically to the remaining space (TT 111466) |
| C4 | PiP pinned and **partially folded** | The video fills half the screen and your app adapts vertically in real time (TT 111466) |
| C5 | **iPhone Mirroring on macOS 27**, window dragged to extreme widths and heights in both directions | The layout reflows across the whole range. Nothing assumes a phone is always compact, or that regular width means iPad ([prepare page](https://developer.apple.com/iphone-duo/prepare/), Step 3) |
| C6 | **New window** while open, then while closed | A new window is created on the inner display. On the outer display the request fails cleanly, and a `UIWindowScene.ActivationAction` menu item is hidden (Tech Talk 111464). Mark N/A if the app has a single scene |

## D. Bars and controls

| # | Check | Expect |
|---|---|---|
| D1 | Vertical bar order | Back or Close first at the top, then prominent actions such as Done, with the remaining groups kept intact (HIG, Preparing your app) |
| D2 | Overflow under pressure (a long Live Activity on the outer display) | Items overflow from bottom to top. Frequent and badged items stay visible longest. Everything is reachable in the system overflow menu (HIG, TT 111466) |
| D3 | Items with title and symbol | Symbol shown vertically and both shown in the overflow menu. Title-only items stay horizontal **on purpose** (Preparing your app) |
| D4 | Toolbar vs. tab bar compression | Navigation-focused screens keep the tab bar. Task-oriented screens keep toolbar items if you set `prefersToolbarItems` / `prefersBarItems` (HIG) |
| D5 | Sheets on the outer display | Vertical bar by default. A single-button sheet may opt out, in which case it stops short of the camera (TT 111466) |
| D6 | Sheets on the inner display | Centered and leading sheets have a horizontal toolbar, trailing sheets a vertical one. Sheets slide aside from the fold (Preparing your app, TT 111466) |
| D7 | Inspectors and split views | Inspectors are horizontal. Sidebar and content columns are horizontal, the detail column vertical (Preparing your app) |
| D8 | Toolbar contents, closed and open | Only the actions this screen needs are visible. Delete, and any other destructive action, is only in the overflow menu (DUO019). On the closed phone the primary action is at the bottom of the toolbar. On the open phone, nothing important sits in the bottom-right (`fold-aware-layout.md`) |
| D9 | Panel states | Each state has a clear way to leave it, and the layout can be changed. Full screen is entered and left with the same button (`fold-aware-layout.md`) |

## E. Content-specific

| # | Check | Expect |
|---|---|---|
| E1 | Grids | Even column count when folded, so cells don't straddle the fold (HIG) |
| E2 | Scrolling content | May cross the fold and doesn't need to move (TT 111466, TT 111463) |
| E3 | Full-bleed or immersive screens | The background may run under the bars so the bar and the panel share one color. Text and controls stay in the safe area (DUO006). Nothing conflicts with the Dynamic Island or status bar (HIG, TT 111461, `fold-aware-layout.md`) |
| E4 | Games | Fill the screen in every pose. Prefer changing the aspect ratio over bars, and fill any bars with artwork. Text and control sizes stay steady (HIG) |
| E5 | Camera apps | The virtual front camera follows the open and closed device. If you use the physical cameras, `AVCaptureDeviceDirectionCoordinator` switches to a forward-facing camera as the device opens, closes, and rotates. See [Choosing a camera by the direction it faces](https://developer.apple.com/documentation/avkit/choosing-a-camera-by-the-direction-it-faces) |
| E6 | Right-to-left languages | Vertical controls stay on the same hardware side. Custom fold avoidance still works because SwiftUI mirrors region frames by default (HIG, `ReservedRegion` doc) |
| E7 | Live Activity, compact and minimal, on iPhone Duo and with the phone in landscape | When `isDynamicIslandLimitedInWidth` is true, the content fits in a 28pt circle: a short label or a graphic, not a truncated sentence ([Live Activities HIG](https://developer.apple.com/design/human-interface-guidelines/live-activities), [environment value](https://developer.apple.com/documentation/swiftui/environmentvalues/isdynamicislandlimitedinwidth)) |
| E8 | Hero image or video on the inner display | The subject is still visible. Fill versus fit follows the size class or the aspect ratio, or the image has a focal point (prepare page) |
| E9 | Sidebar and content in landscape | If the even gutter looks cramped, it was widened by eye. The number still comes from the live insets (`fold-aware-layout.md`) |

## F. Release assets

- App Store screenshots are **1398 × 2034** or **2034 × 1398 px** for the outer display, and **2007 × 2853** or **2853 × 2007 px** for the inner display ([Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications)). Uploading them is what puts the **optimized for iPhone Duo** badge on the product page.
- April 2027 is when Duo screenshots become required, and Apple's pages don't use one sentence for who that covers. The specifications page says "any app using the iOS 27.1 SDK or later." The [Oct 5 news post](https://developer.apple.com/news/?id=kkphp5qo), the App Store Connect release notes, and What's New say "any apps or games submitted." Quote both. The full note is `references/app-store.md`.
- Capture them from Device Hub (see [Capturing screenshots and videos from devices](https://developer.apple.com/documentation/xcode/capturing-screenshots-and-videos-from-devices)).
- Featuring: in Helpful Details, say the app supports every pose (prepare page).
- Metadata and screenshots still follow App Review Guidelines 2.3, 2.3.3, and the October 16, 2026 additions 2.3.14 (creative assets) and 2.5.19 (no hidden features).
