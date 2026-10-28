---
description: "Condensed notes from Apple's HIG, Preparing your app for iPhone Duo, and the iPhone Duo Tech Talks, with source tags."
connections: [patterns, sources, api-index]
---

# iPhone Duo guidance summary

belweave's layout practice (path, panes, toolbar length, reach, and gutters) is in [`fold-aware-layout.md`](fold-aware-layout.md). That file is not an Apple source. The notes below stay limited to Apple's pages.

Source tags:
- **[HIG]** [Designing for iPhone Duo](https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo)
- **[PREP]** [Preparing your app for iPhone Duo](https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo)
- **[TT466]** [Design for iPhone Duo](https://developer.apple.com/videos/play/tech-talks/111466/)
- **[TT461]** [Prepare your app](https://developer.apple.com/videos/play/tech-talks/111461/)
- **[TT462]** [Raise the bar](https://developer.apple.com/videos/play/tech-talks/111462/)
- **[TT463]** [Strike a pose](https://developer.apple.com/videos/play/tech-talks/111463/)
- **[TT464]** [Leverage multiple displays and scenes](https://developer.apple.com/videos/play/tech-talks/111464/)
- **[TT465]** [Build a great camera experience](https://developer.apple.com/videos/play/tech-talks/111465/)
- **[PREPARE-PAGE]** [Three steps to make your app shine on iPhone Duo](https://developer.apple.com/iphone-duo/prepare/)

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

## SDK tiers [PREPARE-PAGE] [TT461]
- **iOS 26 SDK or earlier.** Open: centered, with empty space around the window. Closed: content to the left of the status bar and camera.
- **iOS 27 SDK.** Fills most of the inner display and still avoids the status bar on the right edge.
- **iOS 27.1 SDK or later, in Xcode 27.1 or later.** Full display. Toolbars and tab bars lay out vertically under the status bar. Check content before you ship that build.
- From April 2027, new uploads need the iOS 27 SDK ([Submitting](https://developer.apple.com/app-store/submitting/)). Side bars still need 27.1. Screenshot wording is in `app-store.md`.

## Resizing patterns the prepare page names [PREPARE-PAGE]
- Read size from the view or window (`view.bounds`, `window.bounds`, `GeometryReader`, `onGeometryChange`), again whenever it changes. `viewDidLoad` and `viewIsAppearing` are too early. Use `layoutSubviews`, `viewDidLayoutSubviews`, and `viewWillTransition(to:with:)`.
- Scale comes from `traitCollection.displayScale` or `@Environment(\.displayScale)`. Create windows with `UIWindow(windowScene:)`.
- Orientation doesn't describe the window. Compare the container's width and height, or use size classes.
- A phone app can have any size-class combination, because of iPhone Duo and resizable iPhone Mirroring. Regular width is not iPad. Compact width is not "this is a phone."
- `bounds.height == 844`, and any list of known phone sizes, misses iPhone Duo.
- Hero images and video on `.scaleAspectFill` or `.aspectRatio(contentMode: .fill)` can crop. Choose fill or fit from the size class or the aspect ratio, or set a focal point.

## Hinge [TT464]
- SwiftUI `onHingeChange(isEnabled:_:)`. UIKit `UIHingeInteraction`. Both give status (`.closed`, `.partiallyOpen`, `.fullyOpen` on `DeviceHinge.Status`) and a continuous angle. A nil hinge means there isn't one.
- Use it for effects (the talk's pitch-bend example). Layout still goes through arrangement views and reserved regions.

## Camera [TT465] [PREP]
- Discovering `.front` with the wide or ultra-wide type returns the **virtual front camera** on iPhone Duo. It switches between the outer and inner cameras as the device opens and closes. You get the capabilities both cameras share. Tech Talk 111465: that is a max 1080p resolution, and depth is only on the individual cameras.
- The physical cameras are `.builtInOuterUltraWideCamera` and `.builtInInnerUltraWideCamera`. The inner camera is up to 1080p/60fps. The outer camera is up to 4K/120fps. When you use them yourself, follow direction with `AVCaptureDeviceDirectionCoordinator` (AVKit). `AVCaptureDevice.position` stays a fixed hardware fact and does not tell you which way the camera faces.
- One coordinator per preview view, on the main actor. Include rear cameras: a rear camera can face the person. Switch the session's single video input from the change handler by passing the descriptor off the main actor.
- To show something to the person in front of the lens, register a camera capture scene accessory. The system may present it on the outer display while the capture UI stays on the inner display. It can disappear at any time. Essential controls stay in the capture UI. [Registering a camera capture accessory on iPhone Duo](https://developer.apple.com/documentation/avfoundation/registering-a-camera-capture-accessory-on-iphone-duo).

## Multiple windows [TT464]
- iPhone Duo is the first iPhone with multiple instances of an app's UI. If the app does this on iPad, it does it here too.
- New windows can be created on the **inner display only**. On the outer display they cannot. Handle the error. Put the request in `UIWindowScene.ActivationAction` (`UIWindowSceneActivationAction` in the talk), which hides itself when a new window isn't available.

## Live Activities [HIG Live Activities](https://developer.apple.com/design/human-interface-guidelines/live-activities)
- The HIG change log for October 13, 2026 adds limited-width layouts. Compact and minimal presentations need to fit in a **28pt-diameter circle** when the Dynamic Island is narrow, which includes a phone in landscape. Use a short abbreviation or a graphic. If the trailing compact view has no limited-width form, leave it empty and the system hides it.
- `isDynamicIslandLimitedInWidth` (iOS 27) is the environment value. Its page names iPhone landscape and iPhone Duo as examples. The outer camera's reserved region also expands into the Dynamic Island for a Live Activity [HIG].

## Liquid Glass [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)
- Standard components adopt it when you build with the latest SDK. Bars, sheets, and controls are in that set, including the vertical bars on iPhone Duo.
- Remove custom backgrounds on tab bars, toolbars, and split views so they don't cover the material. Test reduced transparency and reduced motion.
- `UIDesignRequiresCompatibility` keeps the previous look only until you build for iOS 27 or later. The key's page says the system ignores it then. There is no opt-out on an iOS 27 build.

## Tools [TT461] [PREPARE-PAGE]
- Build with Xcode 27.1 or later and the iOS 27.1 SDK for the full-screen experience and vertical bars.
- Test in **Device Hub** with the iPhone Duo simulator: Closed, Partially Open and Open buttons, plus Option-drag for any angle. The prepare page calls this simulator the best way to test the full native experience, and also lists the resizable iOS simulator and iPhone Mirroring on macOS 27.
- Xcode's App Resizability skill (export with `xcrun agent skills export`) covers the prepare page's Step 2. This skill covers the rest. See `SKILL.md`.
