---
description: "Every API this skill names, with its Apple documentation URL. If it isn't here, don't use it."
connections: [sources]
---

# API index (iPhone Duo)

Every API named in `SKILL.md`, `templates/` and the references appears on an Apple page listed here. The Duo-specific layout symbols have iOS 27.1 availability on their API pages. Build with Xcode 27.1 or later and the iOS 27.1 SDK (Tech Talk 111461, [prepare page](https://developer.apple.com/iphone-duo/prepare/)). A symbol whose page says iOS 27.0 is called out below.

Base: `https://developer.apple.com/documentation/`

## Reserved regions (fold and cameras)
| SwiftUI | UIKit | Notes |
|---|---|---|
| [`ReservedRegion`](https://developer.apple.com/documentation/swiftui/reservedregion) | [`UIView.ReservedRegion`](https://developer.apple.com/documentation/uikit/uiview/reservedregion) | Has `frame` (includes margins), `isActive`, `kind`, `margins` and `id` (SwiftUI) |
| [`GeometryProxy.reservedRegions(kind:options:layoutDirectionBehavior:)`](https://developer.apple.com/documentation/swiftui/geometryproxy/reservedregions(kind:options:layoutdirectionbehavior:)) | [`UIView.reservedRegions(kind:options:)`](https://developer.apple.com/documentation/uikit/uiview/reservedregions(kind:options:)) | SwiftUI mirrors frames for right-to-left by default. Pass `.fixed` to opt out |
| [`ReservedRegion.Kind`](https://developer.apple.com/documentation/swiftui/reservedregion/kind-swift.struct) `.division`, `.occlusion` | [`UIView.ReservedRegion.Kind`](https://developer.apple.com/documentation/uikit/uiview/reservedregion/kind-swift.struct) | `.division` is the fold. `.occlusion` covers cameras, the Dynamic Island and window controls |
| [`ReservedRegion.QueryOptions.includeInactive`](https://developer.apple.com/documentation/swiftui/reservedregion/queryoptions) | [`UIView.ReservedRegion.QueryOptions.includeInactive`](https://developer.apple.com/documentation/uikit/uiview/reservedregion/queryoptions) | The fold is inactive, with zero width, when the device is flat |

## Arrangement views
| SwiftUI | UIKit |
|---|---|
| [`ArrangementView`](https://developer.apple.com/documentation/swiftui/arrangementview) `init(primary:secondary:)` | [`UIArrangementViewController`](https://developer.apple.com/documentation/uikit/uiarrangementviewcontroller), `setViewController(_:for:animated:)` |
| [`arrangementViewStyle(_:)`](https://developer.apple.com/documentation/swiftui/view/arrangementviewstyle(_:)) | [`updateArrangement(_:animated:)`](https://developer.apple.com/documentation/uikit/uiarrangementviewcontroller) |
| [`SplitArrangementViewStyle`](https://developer.apple.com/documentation/swiftui/splitarrangementviewstyle) `.split`, `axes(_:)` | [`UISplitArrangement`](https://developer.apple.com/documentation/uikit/uisplitarrangement-swift.struct) `.split`, `axes(_:)` |
| [`OverlayArrangementViewStyle`](https://developer.apple.com/documentation/swiftui/overlayarrangementviewstyle) `.overlay`, `axes(_:)` | [`UIOverlayArrangement`](https://developer.apple.com/documentation/uikit/uioverlayarrangement-swift.struct) `.overlay`, `axes(_:)` |
| [`EnvironmentValues.overlayArrangementZIndex`](https://developer.apple.com/documentation/swiftui/environmentvalues/overlayarrangementzindex) | [`state(for:)`](https://developer.apple.com/documentation/uikit/uiarrangementviewcontroller) → [`ViewState`](https://developer.apple.com/documentation/uikit/uiarrangementviewcontroller/viewstate) (`isHidden`, `splitAxis`, `zIndex`) |

## Vertical bars
| SwiftUI | UIKit |
|---|---|
| [`toolbarVerticalBehavior(_:)`](https://developer.apple.com/documentation/swiftui/view/toolbarverticalbehavior(_:)), [`ToolbarVerticalBehavior`](https://developer.apple.com/documentation/swiftui/toolbarverticalbehavior) `.automatic`, `.disabled` | [`preferredVerticalBarBehavior`](https://developer.apple.com/documentation/uikit/uiviewcontroller/preferredverticalbarbehavior), [`UIVerticalBarBehavior`](https://developer.apple.com/documentation/uikit/uiverticalbarbehavior) `.automatic`, `.disabled` |
| [`EnvironmentValues.toolbarVerticalEdge`](https://developer.apple.com/documentation/swiftui/environmentvalues/toolbarverticaledge) (`HorizontalEdge?`) | [`UITraitCollection.verticalBarEdge`](https://developer.apple.com/documentation/uikit/uitraitcollection/verticalbaredge), [`UIVerticalBarEdge`](https://developer.apple.com/documentation/uikit/uiverticalbaredge) |
| [`toolbarVerticalCompressionBehavior(_:)`](https://developer.apple.com/documentation/swiftui/view/toolbarverticalcompressionbehavior(_:)), [`ToolbarVerticalCompressionBehavior`](https://developer.apple.com/documentation/swiftui/toolbarverticalcompressionbehavior) `.automatic`, `.prefersTabBar`, `.prefersToolbarItems` | [`UINavigationItem.verticalBarCompressionBehavior`](https://developer.apple.com/documentation/uikit/uinavigationitem/verticalbarcompressionbehavior), [`UIVerticalBarCompressionBehavior`](https://developer.apple.com/documentation/uikit/uiverticalbarcompressionbehavior) `.automatic`, `.prefersBarItems`, `.prefersTabBar` |
| [`ToolbarContent.axisBehavior(_:)`](https://developer.apple.com/documentation/swiftui/toolbarcontent/axisbehavior(_:)) (values in Tech Talk 111462: `.verticalPreferred`, `.horizontalOnly`) | [`UIBarButtonItem.axisBehavior`](https://developer.apple.com/documentation/uikit/uibarbuttonitem/axisbehavior-swift.property) |
| [`ToolbarContent.visibilityPriority(_:)`](https://developer.apple.com/documentation/swiftui/toolbaritemvisibilitypriority) | [`UIBarButtonItem.visibilityPriority`](https://developer.apple.com/documentation/uikit/uibarbuttonitem/visibilitypriority) |
| [`ToolbarOverflowMenu`](https://developer.apple.com/documentation/swiftui/toolbaroverflowmenu) | [`UINavigationItem.additionalOverflowItems`](https://developer.apple.com/documentation/uikit/uinavigationitem/additionaloverflowitems) |
| [`ToolbarItemPlacement.topBarPinnedTrailing`](https://developer.apple.com/documentation/swiftui/toolbaritemplacement/topbarpinnedtrailing), [`.cancellationAction`](https://developer.apple.com/documentation/swiftui/toolbaritemplacement/cancellationaction) | [`UINavigationItem.pinnedTrailingGroup`](https://developer.apple.com/documentation/uikit/uinavigationitem/pinnedtrailinggroup), `leadingItemGroups` |
| [`ToolbarItemGroup`](https://developer.apple.com/documentation/swiftui/toolbaritemgroup) | [`UIBarButtonItemGroup`](https://developer.apple.com/documentation/uikit/uibarbuttonitemgroup) |
| [`backgroundExtensionEffect()`](https://developer.apple.com/documentation/swiftui/view/backgroundextensioneffect()) | [`UIBackgroundExtensionView`](https://developer.apple.com/documentation/uikit/uibackgroundextensionview) |

## Sheets
| SwiftUI | UIKit |
|---|---|
| [`presentationPlacement(_:)`](https://developer.apple.com/documentation/swiftui/view/presentationplacement(_:)), [`PresentationPlacement`](https://developer.apple.com/documentation/swiftui/presentationplacement) `.automatic`, `.center`, `.leading`, `.trailing` | [`UISheetPresentationController.preferredPlacement`](https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/preferredplacement) |

## Size, layout, and things to avoid (not new in 27.1)
- Size classes:
  - SwiftUI: `@Environment(\.horizontalSizeClass)` ([doc](https://developer.apple.com/documentation/swiftui/environmentvalues/horizontalsizeclass)).
  - UIKit: [`UITraitCollection.horizontalSizeClass`](https://developer.apple.com/documentation/uikit/uitraitcollection/horizontalsizeclass) and `verticalSizeClass`.
  - UIKit change tracking: [automatic trait tracking](https://developer.apple.com/documentation/uikit/automatic-trait-tracking), for example in `viewWillLayoutSubviews()`.
- Split views: [`NavigationSplitView`](https://developer.apple.com/documentation/swiftui/navigationsplitview), including [`init(columnVisibility:preferredCompactColumn:sidebar:detail:)`](https://developer.apple.com/documentation/swiftui/navigationsplitview/init(columnvisibility:preferredcompactcolumn:sidebar:detail:)). In UIKit, [`UISplitViewController`](https://developer.apple.com/documentation/uikit/uisplitviewcontroller) with [`init(style:)`](https://developer.apple.com/documentation/uikit/uisplitviewcontroller/init(style:)) and the [collapse delegate](https://developer.apple.com/documentation/uikit/uisplitviewcontrollerdelegate/splitviewcontroller(_:topcolumnforcollapsingtoproposedtopcolumn:)).
- Tab sidebar on the inner display: [`defaultTabBarPlacement(_:)`](https://developer.apple.com/documentation/swiftui/view/defaulttabbarplacement(_:)). The UIKit form is `sidebar.preferredPlacement` (Tech Talk 111461).
- Safe areas:
  - SwiftUI: [`GeometryProxy.safeAreaInsets`](https://developer.apple.com/documentation/swiftui/geometryproxy/safeareainsets), and [`ignoresSafeArea(_:edges:)`](https://developer.apple.com/documentation/swiftui/view/ignoressafearea(_:edges:)) for backgrounds only.
  - UIKit: [`UIView.safeAreaInsets`](https://developer.apple.com/documentation/uikit/uiview/safeareainsets) and [`safeAreaLayoutGuide`](https://developer.apple.com/documentation/uikit/uiview/safearealayoutguide).
- Screen corners: [`ConcentricRectangle`](https://developer.apple.com/documentation/swiftui/concentricrectangle). The UIKit name is `UICornerConfiguration` (Tech Talk 111461).
- Avoid:
  - [`UIScreen.main`](https://developer.apple.com/documentation/uikit/uiscreen/main). Apple discourages it; use [`UIWindowScene.screen`](https://developer.apple.com/documentation/uikit/uiwindowscene/screen) or [`UITraitCollection.displayScale`](https://developer.apple.com/documentation/uikit/uitraitcollection/displayscale) instead.
  - [`userInterfaceIdiom`](https://developer.apple.com/documentation/uikit/uiuserinterfaceidiom) and [`UIInterfaceOrientation`](https://developer.apple.com/documentation/uikit/uiinterfaceorientation) for layout. Regular width is not a stand-in for iPad ([prepare page](https://developer.apple.com/iphone-duo/prepare/)).
  - A screen size read once in `viewDidLoad`, `viewIsAppearing`, or `application(_:didFinishLaunchingWithOptions:)`. Re-read in `layoutSubviews` / `viewDidLayoutSubviews`, or use `viewWillTransition(to:with:)`. In SwiftUI, `GeometryReader` or `onGeometryChange`.
  - Hardcoded phone point sizes (`bounds.height == 844`, or a list of known phone sizes).
  - Custom `UIToolbar`, `UINavigationBar` or `UITabBar` instances.
  - [`UIDesignRequiresCompatibility`](https://developer.apple.com/documentation/bundleresources/information-property-list/uidesignrequirescompatibility). The system ignores it when you build for iOS 27 or later.

## Hinge (effects, not layout)
| SwiftUI | UIKit | Notes |
|---|---|---|
| [`onHingeChange(isEnabled:_:)`](https://developer.apple.com/documentation/swiftui/view/onhingechange(isenabled:_:)) | [`UIHingeInteraction`](https://developer.apple.com/documentation/uikit/uihingeinteraction) | iOS 27.1. Both report angle and status. A nil hinge means this device, or this view hierarchy, has none |
| [`DeviceHinge`](https://developer.apple.com/documentation/swiftui/devicehinge) `.angle`, `.status` | [`UIHingeInteraction.Update.hinge`](https://developer.apple.com/documentation/uikit/uihingeinteraction/update/hinge) → `UIHinge?` | [`DeviceHinge.Status`](https://developer.apple.com/documentation/swiftui/devicehinge/status-swift.struct): `.closed`, `.partiallyOpen`, `.fullyOpen` |

Tech Talk 111464: use the hinge for interaction and effects. Keep layout on arrangement views and reserved regions.

## Camera direction and the outer display
| API | Notes |
|---|---|
| Virtual front camera | [Choosing a camera by the direction it faces](https://developer.apple.com/documentation/avkit/choosing-a-camera-by-the-direction-it-faces). A discovery session with `.builtInWideAngleCamera` or `.builtInUltraWideCamera` and `position: .front` returns it on iPhone Duo. It follows the app between displays. Its capabilities are the ones both physical cameras share |
| [`AVCaptureDevice.DeviceType.builtInOuterUltraWideCamera`](https://developer.apple.com/documentation/avfoundation/avcapturedevice/devicetype-swift.struct/builtInouterultrawidecamera), [`.builtInInnerUltraWideCamera`](https://developer.apple.com/documentation/avfoundation/avcapturedevice/devicetype-swift.struct/builtininnerultrawidecamera) | The two physical front cameras, when the app needs each camera's own capabilities. Tech Talk 111465: inner up to 1080p/60fps, outer up to 4K/120fps |
| [`AVCaptureDeviceDirectionCoordinator`](https://developer.apple.com/documentation/avkit/avcapturedevicedirectioncoordinator) (AVKit, iOS 27.1) | Pass the preview view, the device types, and a change handler. Import AVKit. One coordinator per preview. Read direction from the coordinator, not from `AVCaptureDevice.position` |
| [`sceneAccessory(content:)`](https://developer.apple.com/documentation/swiftui/view/sceneaccessory(content:)) + [`CameraCaptureAccessory`](https://developer.apple.com/documentation/swiftui/cameracaptureaccessory) / [`UISceneAccessory.cameraCapture`](https://developer.apple.com/documentation/uikit/uisceneaccessory/cameracapture(sceneconfiguration:)) | iOS 27.1. Supplementary UI while capturing. On iPhone Duo the system can put it on the outer display. [Registering a camera capture accessory](https://developer.apple.com/documentation/avfoundation/registering-a-camera-capture-accessory-on-iphone-duo). The app must still work when the accessory isn't presented |
| [`UISceneAccessory`](https://developer.apple.com/documentation/uikit/uisceneaccessory) | iOS 27. The general type. `cameraCapture` is the Duo outer-display case; `externalNonInteractive` is a connected display |

## Multiple windows
| API | Notes |
|---|---|
| [`UIWindowScene.ActivationAction`](https://developer.apple.com/documentation/uikit/uiwindowscene/activationaction) | Tech Talk 111464 calls it `UIWindowSceneActivationAction`. It hides when a new window can't be created. On iPhone Duo, new windows can be created on the inner display only. Handle the error if a request fails |

## Live Activities
| API | Notes |
|---|---|
| [`EnvironmentValues.isDynamicIslandLimitedInWidth`](https://developer.apple.com/documentation/swiftui/environmentvalues/isdynamicislandlimitedinwidth) | iOS 27. True when compact and minimal presentations are narrowed, "for example, on iPhone in landscape orientation or on iPhone Duo." [HIG](https://developer.apple.com/design/human-interface-guidelines/live-activities): fit those presentations in a 28pt-diameter circle |
