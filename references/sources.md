---
description: "Every Apple source this skill relies on, plus a ledger of which claims are verified, corrected, or unverified."
connections: [api-index, hig-summary]
---

# Sources and claim ledger

Ground truth for this skill is Apple's own pages and the Apple API docs they link to. Nothing else counts as a source for iPhone Duo facts. Checked on 2026-10-25. The v0.1 ledger below was re-checked on 2026-10-17 and is kept. The v0.3.0 ledger follows it.

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
| Three steps (prepare for iPhone Duo) | https://developer.apple.com/iphone-duo/prepare/ |
| Prepare and submit your apps for iPhone Duo (news, Oct 5, 2026) | https://developer.apple.com/news/?id=kkphp5qo |
| App Store Connect release notes | https://developer.apple.com/help/app-store-connect/release-notes/ |
| What's New on the App Store | https://developer.apple.com/app-store/whats-new/ |
| Submitting | https://developer.apple.com/app-store/submitting/ |
| Nominate your app for featuring | https://developer.apple.com/help/app-store-connect/manage-featuring-nominations/nominate-your-app-for-featuring/ |
| App Review Guidelines (Last Updated: October 16, 2026) | https://developer.apple.com/app-store/review/guidelines/ |
| Updated App Review Guidelines news (Oct 16, 2026) | https://developer.apple.com/news/?id=92th7e5i |
| Tech Talk 111465, Build a great camera experience for iPhone Duo | https://developer.apple.com/videos/play/tech-talks/111465/ |
| WWDC26 session 278, Modernize your UIKit app | https://developer.apple.com/videos/play/wwdc2026/278/ |
| Adopting Liquid Glass | https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass |
| Live Activities HIG (change log: October 13, 2026) | https://developer.apple.com/design/human-interface-guidelines/live-activities |
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
- **Naming.** Tech Talk 111461 says "UIViewReservedRegion". The API page title is `UIView.ReservedRegion` (Swift), and this repo uses the API page name.
- **`supportsMultipleScenes` by pose.** Tech Talk 111464 says new windows can't be created on the outer display and that `UIWindowSceneActivationAction` hides itself when they aren't available. It doesn't name `UIApplication.supportsMultipleScenes`. A Developer Forums thread claims that property stays true when the device is closed. This skill doesn't repeat that.
- **Virtual front camera frame rate.** Tech Talk 111465 says the virtual front camera exposes only features common to both physical cameras, "a max 1080p resolution," and that depth works only on the individual cameras. It states 1080p/60fps for the inner camera and 4K/120fps for the outer camera. The "60fps" figure is not clearly attached to the virtual camera in the transcript, so this skill doesn't add it.
- **What "build for iOS 27" means on `UIDesignRequiresCompatibility`.** The key's page says the system ignores it "when you build for iOS 27 or later." It doesn't say whether that is the base SDK or the deployment target. A Developer Forums reply says it means linking against the iOS 27 SDK. This skill quotes the documentation page and doesn't treat the forum reply as the definition.

## Claims added in v0.3.0 (checked 2026-10-25)

| Claim | Status | What Apple says |
|---|---|---|
| Uploading iPhone Duo screenshots shows an "optimized for iPhone Duo" badge | **Verified** | Same sentence on [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications), the [Oct 5 news post](https://developer.apple.com/news/?id=kkphp5qo), and the [prepare page](https://developer.apple.com/iphone-duo/prepare/): "When you submit iPhone Duo screenshots in App Store Connect, your App Store product page will display a badge to let people know your app is optimized for iPhone Duo." |
| Duo screenshots are required in April 2027 | **Flagged (two wordings)** | Screenshot specifications: "Starting in April 2027, screenshots will be required for any app using the iOS 27.1 SDK or later." The news post, the [App Store Connect release notes](https://developer.apple.com/help/app-store-connect/release-notes/) (Oct 5 and Oct 15, 2026), and [What's New](https://developer.apple.com/app-store/whats-new/) say "any apps or games submitted." Quoted side by side in `references/app-store.md`. |
| Featuring nominations should say the app supports every pose | **Verified** | Prepare page: in Helpful Details, "specify that your app is optimized for iPhone Duo, including support for all device poses." The [nomination help](https://developer.apple.com/help/app-store-connect/manage-featuring-nominations/nominate-your-app-for-featuring/) describes Helpful Details more generally and doesn't repeat the pose sentence. |
| Guidelines 2.3.14 and 2.5.19, updated Oct 16, 2026 | **Verified** | [Guidelines](https://developer.apple.com/app-store/review/guidelines/) say "Last Updated: October 16, 2026." [News](https://developer.apple.com/news/?id=92th7e5i) the same day: 2.3.14 is new and covers creative assets; 2.5.19 moves the hidden-feature policy out of 2.3.1. Neither paragraph names iPhone Duo. Summarized in `references/app-store.md`. |
| `xcrun agent skills export` | **Verified** | Prepare page, Step 1, prints the command for agents other than Xcode. WWDC26 session 278 says it "will create markdown files that you can then import in your workflows." |
| App Resizability skill | **Verified** | Tech Talk 111461 names it as the renamed app modernization skill in Xcode 27.1, with SwiftUI and iPhone Duo support. The prepare page's Step 1 is that skill: ask Xcode to "get my app ready for iPhone Duo." |
| April 2027 uploads need the iOS 27 SDK | **Verified** | [Submitting](https://developer.apple.com/app-store/submitting/): "Starting April 2027," iOS and iPadOS apps "must be built with the iOS & iPadOS 27 SDK or later, and target iOS 15 or later." The page says to build and test with Xcode 27. |
| Full Duo layout needs the iOS 27.1 SDK | **Verified** | Prepare page: "iOS 27.1 SDK or later" extends to the full display with toolbars and tab bars vertically below the status bar. Tech Talk 111461: download Xcode 27.1 for that full-screen layout. This skill says "Xcode 27.1 or later" as the floor, because later Xcodes include that SDK. Apple's pages name Xcode 27.1 specifically and don't write "or later" next to the Xcode version. |
| iOS 26 SDK or earlier is centered with empty space | **Verified** | Prepare page: open, "in the center of the display, with empty space surrounding the window"; closed, content "to the left of the status bar and camera." "Preparing your app" still says a build with Xcode 26 or earlier doesn't extend under the status bar and camera, and doesn't use the centered-window sentence or the three-tier split. |
| iOS 27 SDK fills most of the inner display | **Verified** | Prepare page: fills most of the inner display, "still avoid the status bar on the right edge." |
| Virtual front camera and `AVCaptureDeviceDirectionCoordinator` | **Verified** | [Choosing a camera by the direction it faces](https://developer.apple.com/documentation/avkit/choosing-a-camera-by-the-direction-it-faces). The coordinator class is in AVKit, iOS 27.1: [AVCaptureDeviceDirectionCoordinator](https://developer.apple.com/documentation/avkit/avcapturedevicedirectioncoordinator). Tech Talk 111465 is the same material on video. |
| `UIHingeInteraction` and `onHingeChange` | **Verified (was unverified)** | SwiftUI [`onHingeChange(isEnabled:_:)`](https://developer.apple.com/documentation/swiftui/view/onhingechange(isenabled:_:)) and [`DeviceHinge`](https://developer.apple.com/documentation/swiftui/devicehinge) exist, iOS 27.1. Status values are `closed`, `partiallyOpen`, `fullyOpen`. UIKit [`UIHingeInteraction`](https://developer.apple.com/documentation/uikit/uihingeinteraction) is the counterpart. v0.2 guessed a URL and missed the real one. Tech Talk 111464 says hinge updates drive effects, and layout still uses arrangement and reserved-region APIs. |
| `UISceneAccessory` for the outer display | **Verified, scoped** | [`UISceneAccessory`](https://developer.apple.com/documentation/uikit/uisceneaccessory) is the general type (iOS 27). The outer-display case during capture is `cameraCapture` / SwiftUI [`CameraCaptureAccessory`](https://developer.apple.com/documentation/swiftui/cameracaptureaccessory) (iOS 27.1), documented in [Registering a camera capture accessory on iPhone Duo](https://developer.apple.com/documentation/avfoundation/registering-a-camera-capture-accessory-on-iphone-duo). The system decides when it appears. It isn't a general second window. |
| New windows only on the inner display | **Verified** | Tech Talk 111464: "On the outer display of iPhone Duo, new windows cannot be created. That behavior is reserved for the inner display." Handle errors. Use `UIWindowSceneActivationAction` (Swift: [`UIWindowScene.ActivationAction`](https://developer.apple.com/documentation/uikit/uiwindowscene/activationaction)), which "automatically hides when new windows aren't available." |
| Resizable iPhone Mirroring | **Verified** | Prepare page, Step 3: test with "iPhone Mirroring on macOS 27. Resize the window to extreme sizes in both directions." Same page: with iPhone Duo and resizable iPhone Mirroring, a phone app can have any combination of size classes. |
| Live Activities at limited width | **Verified** | [`isDynamicIslandLimitedInWidth`](https://developer.apple.com/documentation/swiftui/environmentvalues/isdynamicislandlimitedinwidth) (iOS 27): true "for example, on iPhone in landscape orientation or on iPhone Duo." [Live Activities HIG](https://developer.apple.com/design/human-interface-guidelines/live-activities), change log October 13, 2026: fit compact and minimal presentations in a 28pt-diameter circle. |
| iOS 27 ignores `UIDesignRequiresCompatibility` | **Verified** | The key's page: "The system ignores this key when you build for iOS 27 or later, iPadOS 27 or later, Mac Catalyst 27 or later, macOS 27 or later, or tvOS 27 or later." [Adopting Liquid Glass](https://developer.apple.com/documentation/technologyoverviews/adopting-liquid-glass) still documents the key as the way to keep the previous look while you update. That only lasts until you build for iOS 27 or later. |
