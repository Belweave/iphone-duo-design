---
description: "Every API this skill names, with its Apple documentation URL. If it isn't here, don't use it."
connections: [sources]
---

# API index (iPhone Duo)

Every API named in `SKILL.md`, `templates/` and the references appears on an Apple page listed here. The Duo-specific symbols have iOS 27.1 availability on their API pages. Build with Xcode 27.1 and the iOS 27.1 SDK (Tech Talk 111461).

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
  - [`userInterfaceIdiom`](https://developer.apple.com/documentation/uikit/uiuserinterfaceidiom) and [`UIInterfaceOrientation`](https://developer.apple.com/documentation/uikit/uiinterfaceorientation) for layout.
  - Custom `UIToolbar`, `UINavigationBar` or `UITabBar` instances.
