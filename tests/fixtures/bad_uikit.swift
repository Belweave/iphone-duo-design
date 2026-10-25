// Fixture: UIKit code with iPhone Duo problems.
import UIKit

final class BadViewController: UIViewController {
    let playButton = UIButton(type: .system)
    let bottomBar = UIToolbar() // expect: DUO005

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = UIScreen.main.bounds.width // expect: DUO001, DUO016
        playButton.widthAnchor.constraint(equalToConstant: 320).isActive = true // expect: DUO002
        if UIDevice.current.userInterfaceIdiom == .phone { // expect: DUO004
            print(width)
        }
        let spacer = UIBarButtonItem.fixedSpace(16) // expect: DUO012
        toolbarItems = [spacer]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let contentWidth = view.bounds.width - view.safeAreaInsets.left * 2 // expect: DUO007
        playButton.frame = CGRect(x: (view.bounds.width - 120) / 2, y: 40, width: 120, height: 44) // expect: DUO009
        if view.window?.windowScene?.interfaceOrientation == .landscapeLeft { // expect: DUO003
            print(contentWidth)
        }
        let banner = UIView(frame: CGRect(x: 0, y: 0, width: 414, height: 60)) // expect: DUO002
        heroImageView.contentMode = .scaleAspectFill // expect: DUO015
        if view.bounds.height == 844 { // expect: DUO014
            print(banner)
        }
        view.addSubview(banner)
    }

    func makeLayout() -> NSCollectionLayoutGroup {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)))
        return NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(80)), repeatingSubitem: item, count: 3) // expect: DUO008
    }
}

final class BadRegularAsPad: UIViewController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if traitCollection.userInterfaceIdiom == .pad && traitCollection.horizontalSizeClass == .regular { // expect: DUO004, DUO017
            print("ipad layout")
        }
    }
}
