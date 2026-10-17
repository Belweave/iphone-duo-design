// SheetVerticalBarOptOut.swift — UIKit template: single-button sheet that keeps a horizontal bar (iOS 27.1+).
//
// Preparing your app: on the outer display, sheets get vertical bars by default; use
// UIViewController.preferredVerticalBarBehavior to disable vertical presentation. For sheets on the inner
// display, UISheetPresentationController.preferredPlacement indicates where the sheet sits.
// API doc: return .disabled only for UIs better served by horizontal bars; treat it as a stable choice.
// Design Tech Talk: this "works well for sheets with only a single toolbar button".
// Sources:
//   https://developer.apple.com/documentation/uikit/uiviewcontroller/preferredverticalbarbehavior
//   https://developer.apple.com/documentation/uikit/uiverticalbarbehavior
//   https://developer.apple.com/documentation/uikit/uisheetpresentationcontroller/preferredplacement
//   https://developer.apple.com/videos/play/tech-talks/111466/
//
// Not specified by Apple's pages: whether a presented UINavigationController or its top view controller is
// consulted. The override below sits on the content view controller (as in Apple's Tech Talk sample);
// confirm in the simulator, and if needed forward the property from a UINavigationController subclass.

import UIKit

final class TipViewController: UIViewController {
    override var preferredVerticalBarBehavior: UIVerticalBarBehavior { .disabled }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tip"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done", image: UIImage(systemName: "checkmark"),
            primaryAction: UIAction { [weak self] _ in self?.dismiss(animated: true) }, menu: nil)
    }
}

extension UIViewController {
    func presentSingleButtonTip() {
        let nav = UINavigationController(rootViewController: TipViewController())
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true)
    }
}
