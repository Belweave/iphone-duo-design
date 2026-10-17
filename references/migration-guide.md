---
description: "Step-by-step migration of an existing iPhone app to iPhone Duo, ordered by impact."
connections: [api-index, test-plan, review-rubric]
---

# Migrating an existing app to iPhone Duo

Apple's framing: an app that already resizes well, whether on iPad, Mac or in iPhone Mirroring, is "well on your way". The order below runs from biggest impact to smallest. Each step lists what to change, the API to use (see `api-index.md`), and how to check it.

Your app already runs on iPhone Duo without changes:
- With an older SDK, it uses the area to the left of the status bar and camera when closed, and keeps a familiar size when open.
- With the iOS 27 SDK, it extends to the left of the status bar on the inner display.
- With the **iOS 27.1 SDK**, it reaches the screen edge and standard bars lay out vertically.

(Tech Talk 111461.)

## 0. Baseline (½ day)
1. Install **Xcode 27.1** and build with the iOS 27.1 SDK.
2. Run in **Device Hub → iPhone Duo simulator**. Walk every screen in Closed, Open and Partially Open, rotated each way.
3. Run `scripts/duo-lint path/to/YourApp --format json > duo-lint.json` and triage the findings.
4. Optionally run Xcode's **App Resizability** skill. Tech Talk 111461 names it as the renamed app modernization skill in Xcode 27.1, with SwiftUI and iPhone Duo support.

## 1. Remove screen, idiom and orientation assumptions (lint DUO001–DUO004)
- `UIScreen.main` gets replaced:
  - Use the view's or scene's bounds for sizes.
  - Use `traitCollection.displayScale` for scale.
  - Use `view.window?.windowScene?.screen` only when you really need a screen.
- Layout that branches on `userInterfaceIdiom`, `UIDevice.current.orientation` or `interfaceOrientation` should branch on size classes or the container size instead. The inner display **doesn't honor** your supported interface orientations.
- `UIRequiresFullScreen` is still honored, but your app still resizes when the device opens and closes (TT 111461).

## 2. Make every layout resizable (DUO002, DUO007)
- Fixed widths become flexible frames, layout margins, Auto Layout against guides, or `Layout` / `Grid`.
- Size relative to the **container**, not to fixed iPhone dimensions.
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

## 7. Camera apps (if applicable)
- Follow [Choosing a camera by the direction it faces](https://developer.apple.com/documentation/avkit/choosing-a-camera-by-the-direction-it-faces).
- Consider showing content on the outer display while capturing with the rear camera: [Registering a camera capture accessory on iPhone Duo](https://developer.apple.com/documentation/avfoundation/registering-a-camera-capture-accessory-on-iphone-duo).

## 8. Verify and ship
- Run the full `test-plan.md`, score with `review-rubric.md`, and capture screenshots at Apple's sizes.
- Sanity-check those screenshots in `tools/duo-preview.html`.

## Don'ts
- Don't design a custom layout for each pose. Two size classes cover them all.
- Don't tie functionality to a pose.
- Don't hard-code iPhone Duo dimensions, inset values, fold widths or camera sizes. Apple doesn't publish them; read live values instead.
