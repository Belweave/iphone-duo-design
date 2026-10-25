---
description: "Step-by-step migration of an existing phone app to iPhone Duo, ordered by impact."
connections: [api-index, test-plan, review-rubric]
---

# Migrating an existing app to iPhone Duo

Apple's framing: an app that already resizes well, whether on iPad, Mac or in iPhone Mirroring, is "well on your way". The order below runs from biggest impact to smallest. Each step lists what to change, the API to use (see `api-index.md`), and how to check it.

Your app already runs on iPhone Duo without changes. What it looks like depends on the SDK you linked ([prepare page](https://developer.apple.com/iphone-duo/prepare/), Tech Talk 111461):
- **iOS 26 SDK or earlier.** Open: centered, with empty space around the window. Closed: content to the left of the status bar and camera.
- **iOS 27 SDK.** Fills most of the inner display and still avoids the status bar on the right edge.
- **iOS 27.1 SDK or later.** Reaches the screen edge, and standard bars lay out vertically.

From April 2027, a new App Store upload has to be built with the iOS 27 SDK or later ([Submitting](https://developer.apple.com/app-store/submitting/)). Side bars still need 27.1. "Preparing your app" still describes an Xcode 26-or-earlier build as one that doesn't extend under the status bar and camera, without the three rows above.

## 0. Baseline (½ day)
1. Install **Xcode 27.1 or later** and build with the iOS 27.1 SDK.
2. Run in **Device Hub → iPhone Duo simulator**. Walk every screen in Closed, Open and Partially Open, rotated each way. Also resize **iPhone Mirroring** on macOS 27 to extreme widths and heights (prepare page, Step 3).
3. Run `scripts/duo-lint path/to/YourApp --format json > duo-lint.json` and triage the findings. The scanner reads Swift and property lists.
4. Run Apple's **App Resizability** skill. In Xcode, ask the coding assistant to "get my app ready for iPhone Duo." From another agent, export it with `xcrun agent skills export` and import the Markdown (prepare page; WWDC26 session 278). It finds most of the Step 2 patterns and not all of them. This skill's linter, templates, and test plan cover the rest.

## 1. Remove screen, idiom and orientation assumptions (lint DUO001–DUO004, DUO014, DUO016, DUO017)
- `UIScreen.main` gets replaced:
  - Use the view's or scene's bounds for sizes.
  - Use `traitCollection.displayScale` for scale.
  - Use `view.window?.windowScene?.screen` only when you really need a screen.
- Layout that branches on `userInterfaceIdiom`, `UIDevice.current.orientation` or `interfaceOrientation` should branch on size classes or the container size instead. The inner display **doesn't honor** your supported interface orientations.
- Regular width is not an iPad check, and compact width is not "this is a phone" (DUO017). A phone app can have any size-class combination on iPhone Duo and in resizable iPhone Mirroring.
- Delete comparisons and lists of known phone point sizes, such as `bounds.height == 844` (DUO014).
- A size captured in `viewDidLoad`, `viewIsAppearing`, or at launch is stale after a fold (DUO016). Read it again in `viewDidLayoutSubviews` / `layoutSubviews`.
- `UIRequiresFullScreen` is still honored, but your app still resizes when the device opens and closes (TT 111461).

## 2. Make every layout resizable (DUO002, DUO007)
- Fixed widths become flexible frames, layout margins, Auto Layout against guides, or `Layout` / `Grid`.
- Size relative to the **container**, not to fixed phone dimensions.
- Handle each safe-area side separately. Insets are asymmetric on iPhone Duo.
- Template: `templates/*/SizeClassRoot*`.

## 3. Adopt standard navigation and bars (DUO005, DUO010–DUO012)
- Move custom `UIToolbar`, `UINavigationBar` and `UITabBar` instances to navigation-controller-owned items. In SwiftUI, put `.toolbar { }` inside `NavigationStack` or `NavigationSplitView`.
- List and detail become `NavigationSplitView` / `UISplitViewController`. They collapse when closed and adapt to the fold (`templates/*/SplitViewCollapse.swift`).
- For dense apps, consider the tab sidebar on the inner display: `defaultTabBarPlacement(.sidebar)`.
- Organize bar items for the vertical axis (`templates/*/VerticalBars.swift`):
  - Order: Close or Back, then the prominent action.
  - Every item gets a title and a symbol, and related items go in groups.
  - Set visibility priorities and use the system overflow menu.
  - Pick a compression behavior for task-oriented screens.
- Read `toolbarVerticalEdge` / `verticalBarEdge` if a custom view has to sit relative to the vertical bar.
- Let hero images extend under the vertical bar with `backgroundExtensionEffect()` / `UIBackgroundExtensionView`.

## 4. Sheets
- Sheets get vertical bars on the outer display by default. Opt out only for single-button sheets or UIs better served by horizontal bars: `toolbarVerticalBehavior(.disabled)` / `preferredVerticalBarBehavior`. Keep it a stable choice (`templates/*/SheetVerticalBarOptOut.swift`).
- On the inner display, choose the sheet placement with `presentationPlacement(_:)` / `preferredPlacement`.

## 5. Handle the fold (DUO006, DUO008, DUO009, DUO013)
1. Prefer system components first. Sheets, alerts, menus, popovers, toolbar buttons and split views already move away from the fold.
2. Two-pane custom layouts: an HStack or VStack becomes a **split** `ArrangementView`, and a ZStack becomes an **overlay** one. Keep navigation outside, and never nest it inside a List, ScrollView or NavigationSplitView (`templates/*/ArrangementPatterns.swift`).
3. Remaining high-priority custom controls: query `reservedRegions(kind: .division)` and nudge them off active regions. Use `.occlusion` for the inner camera. Move related elements together, keep moves small, and leave scrolling content alone (`templates/*/FoldAware*.swift`).
4. Grids: use an even column count when a division region exists. `includeInactive` lets you decide even while the device is flat.

## 6. Games and immersive screens
- Fill every pose, prefer changing the aspect ratio over bars, and keep HUD sizes constant (`templates/*/GameFill*.swift`).

## 7. Camera, hinge, and extra windows (if applicable)
- Prefer the virtual front camera (discover `.front` with the wide or ultra-wide type). It follows the app between displays. Use `AVCaptureDeviceDirectionCoordinator` when you capture from the physical outer and inner cameras yourself. [Choosing a camera by the direction it faces](https://developer.apple.com/documentation/avkit/choosing-a-camera-by-the-direction-it-faces).
- Content for the person in front of the lens is a camera capture scene accessory, which the system may show on the outer display: [Registering a camera capture accessory on iPhone Duo](https://developer.apple.com/documentation/avfoundation/registering-a-camera-capture-accessory-on-iphone-duo).
- Hinge angle (`onHingeChange`, `UIHingeInteraction`) is for effects. Keep using reserved regions and arrangements for layout (Tech Talk 111464).
- New windows open on the inner display only. Request them with `UIWindowScene.ActivationAction` and handle the error (Tech Talk 111464).

## 8. Liquid Glass
- Remove `UIDesignRequiresCompatibility`. The system ignores it when you build for iOS 27 or later, so it will not keep the old look on this SDK ([key page](https://developer.apple.com/documentation/bundleresources/information-property-list/uidesignrequirescompatibility)). `duo-lint` reports it as DUO018.
- Let system bars and controls adopt Liquid Glass. Remove custom backgrounds that would cover it ([Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass)).

## 9. Verify and ship
- Run the full `test-plan.md`, including resizable iPhone Mirroring and limited-width Live Activities. Score with `review-rubric.md`.
- Capture iPhone Duo screenshots at Apple's sizes and upload them so the product page can show the optimized-for-iPhone-Duo badge. Read `references/app-store.md` for the April 2027 wording, which two Apple pages don't agree on, and for guidelines 2.3.14 and 2.5.19.
- In a featuring nomination's Helpful Details, say the app supports every pose.
- Sanity-check screenshots in `tools/duo-preview.html`.

## Don'ts
- Don't design a custom layout for each pose. Two size classes cover them all.
- Don't tie functionality to a pose.
- Don't hard-code iPhone Duo dimensions, inset values, fold widths, camera sizes, or a list of older phone point sizes. Apple doesn't publish Duo dimensions; read live values instead.
- Don't leave an unconditional aspect fill on a hero image or video (DUO015).
