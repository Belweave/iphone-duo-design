// ArrangementPatterns.swift — UIKit template: UIArrangementViewController split and overlay (iOS 27.1+).
//
// UIArrangementViewController computes a layout from the available size, size class and hardware features.
// Default style: UISplitArrangement. Other built-in style: UIOverlayArrangement. Both take axes(_:).
// Tech Talk 111463: use it as the root view controller of your UINavigationController (navigation outside).
// Read placement state with state(for:) — ViewState has isHidden, splitAxis and zIndex.
// Sources:
//   https://developer.apple.com/documentation/uikit/uiarrangementviewcontroller
//   https://developer.apple.com/documentation/uikit/uisplitarrangement-swift.struct
//   https://developer.apple.com/documentation/uikit/uioverlayarrangement-swift.struct
//   https://developer.apple.com/documentation/uikit/uiarrangementviewcontroller/viewstate
//   https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo
//   https://developer.apple.com/videos/play/tech-talks/111463/
//
// NOTE: Apple's pages don't name a callback for "the arrangement changed". This template re-reads
// state(for:) in viewDidLayoutSubviews, which runs when the container's size changes. Verify on the
// iPhone Duo simulator that it fires on fold/unfold for your hierarchy.

import UIKit

enum ArrangementFactory {
    /// Player beside its up-next list; split only along the horizontal axis.
    static func splitPlayer() -> UINavigationController {
        let arrangementVC = UIArrangementViewController()
        arrangementVC.setViewController(PlayerViewController(), for: .primary)
        arrangementVC.setViewController(UpNextViewController(), for: .secondary)
        arrangementVC.updateArrangement(.split.axes(.horizontal))
        return UINavigationController(rootViewController: arrangementVC)
    }

    /// Up-next layered over the player when flat; side by side when the device folds.
    static func overlayPlayer() -> UINavigationController {
        let arrangementVC = UIArrangementViewController()
        arrangementVC.setViewController(UpNextViewController(), for: .primary)
        arrangementVC.setViewController(PlayerViewController(), for: .secondary)
        arrangementVC.updateArrangement(.overlay)
        return UINavigationController(rootViewController: arrangementVC)
    }
}

final class PlayerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
    }
}

final class UpNextViewController: UIViewController {
    private(set) var isMinimized = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Tech Talk sample: collapsed while layered (zIndex > 0), expanded when side by side.
        // Reads the state from the parent arrangement instead of subclassing it.
        guard let arrangement = parent as? UIArrangementViewController,
              let placement = arrangement.placement(for: self) else { return }
        let minimized = (arrangement.state(for: placement)?.zIndex ?? 0) > 0
        if minimized != isMinimized {
            isMinimized = minimized
            // Swap your collapsed / expanded content here.
        }
    }
}
