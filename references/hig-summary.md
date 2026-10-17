---
description: "Condensed notes from Apple's HIG, Preparing your app for iPhone Duo, and the iPhone Duo Tech Talks, with source tags."
connections: [patterns, sources, api-index]
---

# iPhone Duo guidance summary

Source tags:
- **[HIG]** [Designing for iPhone Duo](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo)
- **[PREP]** [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo)
- **[TT466]** [Design for iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111466/)
- **[TT461]** [Prepare your app](https://developer.apple.com/videos/play/tech-talks/111461/)
- **[TT462]** [Raise the bar](https://developer.apple.com/videos/play/tech-talks/111462/)
- **[TT463]** [Strike a pose](https://developer.apple.com/videos/play/tech-talks/111463/)

## Anatomy
- **Outer display (closed).** Compact, and wider and shorter than other iPhone displays. Toolbars and tab bars sit on the side; the talk shows the **right** side. The outer camera is in the corner, always visible, and vertically aligned with the side controls. [HIG] [TT466]
- **Inner display (open).** The largest display on an iPhone. The inner camera sits behind the display and is hidden until active. [HIG] [PREP]
- **Hinge.** Supports book, laptop-style and standing poses. When partially open, the fold divides the inner display into usable regions. [HIG] [TT466]

## Size classes [TT461] [TT466]
| Configuration | Horizontal | Vertical |
|---|---|---|
| Outer, portrait | compact | regular |
| Outer, landscape | compact | compact |
| Inner (open) | regular | regular |

Apple doesn't list size classes for a Split View half or for pinned PiP on these pages. The inner display doesn't honor supported interface orientations, so use size classes, not orientation. [TT461]

## Best practices [HIG] [PREP]
- Build to resize with size classes, layout margins and safe-area insets. Avoid fixed widths and display-specific dependencies.
- Keep the experience consistent across displays. The inner display may show one extra level of hierarchy, as Mail shows list plus message.
- Keep the same functionality in every pose.
- Follow the system's vertical bar layout.
- Games must be playable in every pose. Fill the screen, prefer changing the aspect ratio to bars, and fill any bars with artwork.
- Base layout math on scene or view bounds, not the screen. Don't use `userInterfaceIdiom` or `UIInterfaceOrientation` for layout. Avoid `UIScreen.main`. [PREP] [TT461]
- Safe areas and layout margins are asymmetric. Handle each side independently. [TT461]

## Reserved regions [HIG] [PREP] [TT463]
- **Outer front camera.** Always present. Expands into the Dynamic Island for Live Activities.
- **Inner front camera.** Present only while the camera is active.
- **Folding region.** Present only when partially open. It's active when folded and inactive (zero width) when flat.
- Kinds: **division** (the fold) and **occlusion** (cameras, the Dynamic Island, window controls).
- APIs: SwiftUI `GeometryProxy.reservedRegions(kind:options:layoutDirectionBehavior:)` → `[ReservedRegion]`; UIKit `UIView.reservedRegions(kind:options:)` → `[UIView.ReservedRegion]`. Each has `frame`, `isActive`, `kind` and `margins`. The option is `.includeInactive`.
- System components already adapt: alerts, context menus, sheets, popovers, toolbar buttons and split views (which even out to 50/50).
- Prefer an even number of grid columns. Move only what's necessary, move related elements together, and keep moves small. Scrolling content doesn't need to avoid the fold.

## Arrangement views [HIG] [PREP] [TT463]
- **Split:** side by side when wider than tall, stacked when taller than wide. It adapts to the fold. Use it where you'd write an HStack or VStack. If it can't split on an allowed axis, it shows one view.
- **Overlay:** primary on top of secondary when closed or fully open. When partially open, the primary takes the trailing or bottom part and the secondary the leading or top part. Use it where you'd write a ZStack. Read `overlayArrangementZIndex` (SwiftUI) or `state(for:).zIndex` (UIKit) to switch to a collapsed version.
- Limit axes with `axes(_:)`.
- Keep navigation outside. Don't nest it inside a NavigationSplitView, List or ScrollView.
- APIs: `ArrangementView` with `.arrangementViewStyle(.split / .overlay)`; `UIArrangementViewController` with `updateArrangement(.split / .overlay)`.

## Vertical controls [HIG] [PREP] [TT462] [TT466]
- Toolbars, tab bars and navigation controls move to the side. The **exception is the inner display in portrait**, which keeps horizontal bars.
- In Split View, each app's controls sit on its outer edge. Controls stay on the same hardware side in right-to-left languages.
- Order: Back or Close at the top, then prominent actions such as Done, then the remaining groups as they were. The tab bar stays bottom-aligned.
- Overflow runs bottom to top by default. Set visibility priority to keep frequent and badged items visible. Use the system overflow menu and reserve the ellipsis for it.
- Give items a title and a symbol. Title-only and custom-view items aren't presented vertically (`axisBehavior` can change that).
- Group items with `ToolbarItemGroup` / `UIBarButtonItemGroup`, not manual spacing.
- Compression: navigation-focused screens keep the tab bar (the default). Task-oriented screens keep toolbar items via `toolbarVerticalCompressionBehavior` / `verticalBarCompressionBehavior`.
- Bars must come from navigation containers. Custom `UIToolbar`, `UINavigationBar` and `UITabBar` instances aren't considered. [PREP]
- Inspectors are horizontal. In split views, sidebar and content columns are horizontal and the detail column vertical. [PREP]
- `toolbarVerticalEdge` / `verticalBarEdge` tells custom UI where the vertical bar is. Hero images can extend under it with `backgroundExtensionEffect()` / `UIBackgroundExtensionView`. [PREP]
- Full-width layouts are fine for immersive, non-scrolling UIs, as long as nothing conflicts with the Dynamic Island or status bar. [HIG]

## Sheets [PREP] [TT466]
- On the outer display, sheets get vertical bars by default. Disable with `toolbarVerticalBehavior(.disabled)` / `preferredVerticalBarBehavior`, which works well for single-button sheets. The sheet then stops short of the camera.
- On the inner display, the toolbar is horizontal for centered and leading placements and vertical for trailing ones. Choose with `presentationPlacement(_:)` / `preferredPlacement`.
- Partially folded, sheets slide aside from the fold.

## Multitasking and media [TT466]
- The new 50/50 Split View is built on the home gesture.
- PiP can pin to the top, and the app resizes vertically. When partially folded, the video fills half the screen.

## Tools [TT461]
- Build with Xcode 27.1 and the iOS 27.1 SDK for the full-screen experience and vertical bars.
- Test in **Device Hub** with the iPhone Duo simulator: Closed, Partially Open and Open buttons, plus Option-drag for any angle.
