// VerticalBars.swift — UIKit template: organize bar items for vertical presentation (iOS 27.1+).
//
// Sources (all Apple):
//   https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo
//   https://developer.apple.com/videos/play/tech-talks/111462/  (Raise the bar with iPhone Duo)
//   https://developer.apple.com/documentation/uikit/uinavigationitem/pinnedtrailinggroup
//   https://developer.apple.com/documentation/uikit/uibarbuttonitem/axisbehavior-swift.property
//   https://developer.apple.com/documentation/uikit/uibarbuttonitem/visibilitypriority
//   https://developer.apple.com/documentation/uikit/uinavigationitem/additionaloverflowitems
//   https://developer.apple.com/documentation/uikit/uinavigationitem/verticalbarcompressionbehavior
//   https://developer.apple.com/documentation/uikit/uitraitcollection/verticalbaredge
//   https://developer.apple.com/documentation/uikit/uibackgroundextensionview
//
// Put items on a view controller inside a UINavigationController — custom UIToolbar/UINavigationBar/UITabBar
// instances aren't considered for vertical presentation.

import UIKit

final class ComposeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Custom Close at the top of the vertical axis.
        let close = UIBarButtonItem(title: "Close", image: UIImage(systemName: "xmark"), primaryAction: nil, menu: nil)
        navigationItem.leftItemsSupplementBackButton = false
        navigationItem.leadingItemGroups = [UIBarButtonItemGroup(barButtonItems: [close], representativeItem: nil)]

        // Prominent action next.
        let send = UIBarButtonItem(title: "Send", image: UIImage(systemName: "paperplane"), primaryAction: nil, menu: nil)
        send.visibilityPriority = .high
        navigationItem.pinnedTrailingGroup = UIBarButtonItemGroup(barButtonItems: [send], representativeItem: nil)

        // A text value that should stay horizontal.
        let draft = UIBarButtonItem(title: "Draft", style: .plain, target: nil, action: nil)
        draft.axisBehavior = .horizontalOnly
        navigationItem.rightBarButtonItems = [draft]

        // Grouped bottom items; no fixed spacers.
        toolbarItems = [
            UIBarButtonItem(title: "Attach", image: UIImage(systemName: "paperclip"), primaryAction: nil, menu: nil),
            UIBarButtonItem(title: "Photo", image: UIImage(systemName: "photo.on.rectangle"), primaryAction: nil, menu: nil),
        ]

        // Extra actions go into the system overflow menu.
        navigationItem.additionalOverflowItems = UIDeferredMenuElement { provider in
            provider([
                UIAction(title: "Save as Template", image: UIImage(systemName: "doc.badge.plus")) { _ in },
                UIAction(title: "Schedule", image: UIImage(systemName: "clock")) { _ in },
            ])
        }

        // Task-oriented screen: keep toolbar items over the tab bar when space is tight.
        navigationItem.verticalBarCompressionBehavior = .prefersBarItems
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // .unspecified when no vertical bar is used in this context.
        switch traitCollection.verticalBarEdge {
        case .leading, .trailing: break   // e.g. align a floating palette away from the bar
        default: break
        }
    }
}
