// Fixture: UIKit code that follows Apple's iPhone Duo guidance. duo-lint must report nothing here.
import UIKit

final class GoodViewController: UIViewController {
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .all }

    override func viewDidLoad() {
        super.viewDidLoad()
        let scale = traitCollection.displayScale
        let screen = view.window?.windowScene?.screen
        _ = (scale, screen)
        navigationItem.pinnedTrailingGroup = UIBarButtonItemGroup(barButtonItems: [], representativeItem: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let usable = view.bounds.inset(by: view.safeAreaInsets)
        let isRegular = traitCollection.horizontalSizeClass == .regular
        _ = (usable, isRegular)
    }
}
