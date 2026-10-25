# iPhone Duo design review checklist

Use this checklist to review any screen, sheet, or flow before you ship it on iPhone Duo. It's based on the `iphone-duo-design` skill and Apple's public pages, listed under Sources at the end.

> Independent checklist, not made or endorsed by Apple. Always confirm against Apple's latest documentation.

To score a review, use [`review-rubric.md`](review-rubric.md). It maps each section below to an area, the evidence it needs, and blocking failures. For the step-by-step device run, use [`test-plan.md`](test-plan.md).

## 1. Size classes and resizing
- [ ] The layout targets **compact width on the outer display** and **regular width on the inner display**, and doesn't have a custom layout for each pose.
- [ ] It's built with layout margins and safe area insets. There are no fixed widths, breakpoints, or metrics tied to one screen.
- [ ] Layout math uses the scene or container bounds, not the screen dimensions, and the size is read again when the window changes. Decisions don't depend on the device idiom, interface orientation, or a list of known phone point sizes. Regular width is not treated as iPad.
- [ ] Every view, sheet, and popover resizes cleanly when the device is closed, open, partially folded, and rotated in each pose.
- [ ] The same functionality and hierarchy appear on both displays. The inner display may add one more level, such as list plus detail.
- [ ] If there's an optional tabletop layout, it keeps every control and the same hierarchy. No feature is tied to one pose.

## 2. Vertical controls
- [ ] It uses system navigation bars, toolbars, and tab bars from navigation containers, with no custom bars, so they move to the side automatically.
- [ ] Bars are on the side on the outer display and in inner landscape, and horizontal in inner portrait.
- [ ] The top of the vertical bar has Back or Close first, then prominent actions such as Done. The original groupings are kept.
- [ ] Every toolbar item that isn't text-only has both a **title and a symbol**. Text-only items, and anything that is a meaningful text value such as a price, stay horizontal on purpose.
- [ ] Items are grouped with system groups, not manual spacers.
- [ ] Visibility priorities are set so frequent actions and badged items stay visible longest. Custom overflow actions are moved into the system overflow menu, and the ellipsis is used only for overflow.
- [ ] Toolbar versus tab bar compression fits the view: navigation-focused views compress the toolbar first, and task-oriented views compress the tab bar first.
- [ ] Content stays clear of the controls through safe areas, including controls on the opposite edge in Split View.
- [ ] Any full-width, non-scrolling layout keeps every interactive element clear of the side controls, the Dynamic Island, and the status bar.
- [ ] A hero image or video chooses fill or fit from the size class or the aspect ratio, or it has a focal point, so a wider display doesn't crop the subject.

## 3. Fold and reserved regions
- [ ] When the device is partially folded, no tappable element sits in the fold. Scrollable content may cross it.
- [ ] Custom views query reserved regions (division for the fold, occlusion for the camera) and move only what they need to.
- [ ] Elements that work together move together, and nothing jumps far from where it started. Small adjustments are better than rearranging.
- [ ] Grids prefer an even number of columns so they divide cleanly at the fold.
- [ ] In the folded portrait pose, interactive controls favor the bottom region and glanceable content favors the top. (Apple describes the top and bottom regions. The fold's axis itself isn't stated in words; see `sources.md`.)
- [ ] Nothing important sits under the outer camera corner, which is always present, or under the inner camera area while the camera is active.

## 4. Containers and arrangements
- [ ] List and detail layouts use a system split view, which collapses on the outer display and expands on the inner one.
- [ ] HStack or VStack layouts that should adapt to the fold use a **split** arrangement. ZStack layouts with a foreground and background use an **overlay** arrangement.
- [ ] Arrangement views are never placed inside navigation split views, lists, or scroll views. Navigation wraps the arrangement view, not the other way around.

## 5. Sheets, Split View, and media
- [ ] Sheets on the outer display get vertical bars by default. A sheet with one control can opt out on purpose.
- [ ] Sheets on the inner display use horizontal bars when centered or leading and a vertical bar when trailing, and they slide aside from the fold.
- [ ] The app works in a 50/50 Split View, with controls on its outer edge and content clear of them.
- [ ] Games fill the screen in every pose, prefer changing the aspect ratio to letterboxing, and keep text and control sizes consistent.

## 6. Review assets
- [ ] Outer display screenshots are captured at **1398 × 2034 px** (portrait) or **2034 × 1398 px** (landscape).
- [ ] Inner display screenshots are captured at **2007 × 2853 px** (portrait) or **2853 × 2007 px** (landscape).
- [ ] Those screenshots are uploaded in App Store Connect, which is what shows the **optimized for iPhone Duo** badge. April 2027 is the deadline, and Apple states the audience two ways; see `app-store.md`.
- [ ] A featuring nomination's Helpful Details says the app supports every pose.
- [ ] Creative assets follow App Review Guideline 2.3.14, and screenshots show the app in use (2.3, 2.3.3). The binary has no hidden features (2.5.19). Guidelines last updated October 16, 2026.
- [ ] Each screen has been checked in `tools/duo-preview.html` with the fold overlay on and the guides showing.
- [ ] The app has been tested in a simulator or on an iPhone Duo in every pose and orientation, and the window has been resized in iPhone Mirroring on macOS 27.
- [ ] The build uses Xcode 27.1 or later and the iOS 27.1 SDK, and Info.plist does not set `UIDesignRequiresCompatibility`.

## Not published by Apple (don't hard-code)
Apple's pages don't publish point dimensions, scale factor, the fold region's width when partially folded, safe area inset values, layout margin values, the side-control region's width, or the camera region's size. The fold's division region has zero width when the device is flat. Read live values at runtime (safe area insets, reserved region frames) instead of hard-coding them.

## Sources
- Apple HIG, "Designing for iPhone Duo": https://developer.apple.com/tutorials/data/design/human-interface-guidelines/designing-for-iphone-duo.md
  This supports: the compact and regular size class mapping, side controls with the inner portrait exception, reserved regions (outer camera, inner camera, fold), even grid columns, arrangement views, Split View controls on the outer edge, title plus symbol, compression, overflow, and games.
- Apple, "Preparing your app for iPhone Duo": https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo.md
  This supports: bounds instead of screen dimensions, no idiom or orientation in layout, bar presentation in sheets, split views, and inspectors, overlay and split arrangement behavior, active and inactive reserved regions, and testing in a simulator or on a device.
- Tech Talk, "Design for iPhone Duo": https://developer.apple.com/videos/play/tech-talks/111466/
  This supports: two size classes, layout margins and horizontal safe area insets, controls on the right side when closed, the optional tabletop layout, the 50/50 Split View, sheets, and fold avoidance (scrollable content is exempt).
- Tech Talk, "Strike a pose with adaptive layouts on iPhone Duo": https://developer.apple.com/videos/play/tech-talks/111463/
  This supports: displacement patterns, the top and bottom regions in tabletop use, zero fold width when flat, division and occlusion regions, and when not to use an arrangement.
- Tech Talk, "Raise the bar with iPhone Duo": https://developer.apple.com/videos/play/tech-talks/111462/
  This supports: item order, axis behavior, symbol-only items, compression, and visibility priority.
- App Store Connect, "Screenshot specifications": https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications
  This supports: the outer screenshot sizes of 1398 × 2034 and 2034 × 1398 px, and the inner sizes of 2007 × 2853 and 2853 × 2007 px; the optimized-for-iPhone-Duo badge; and the April 2027 wording "any app using the iOS 27.1 SDK or later."
- Apple, "Three steps to make your app shine on iPhone Duo": https://developer.apple.com/iphone-duo/prepare/
  This supports: the three SDK tiers, the badge, featuring nominations that mention every pose, resizable iPhone Mirroring, and the layout patterns behind DUO014–DUO017.
- App Review Guidelines, last updated October 16, 2026: https://developer.apple.com/app-store/review/guidelines/
  This supports: 2.3 and 2.3.3 for screenshots, 2.3.14 for creative assets, and 2.5.19 for hidden features. The same-day news post is https://developer.apple.com/news/?id=92th7e5i.
