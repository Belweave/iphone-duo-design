// SizeClassRootViewController.swift — UIKit template: adapt from size classes with automatic trait tracking.
//
// Preparing your app: "Use automatic trait tracking to observe horizontalSizeClass and verticalSizeClass
// changes ... Don't use userInterfaceIdiom or UIInterfaceOrientation for layout decisions." "Make layout
// calculations based on your scene or containing view's bounds rather than screen dimensions."
// Tech Talk 111461: avoid UIScreen.main ("ambiguous and will be deprecated"); for scale use
// traitCollection.displayScale; if you need the screen, use view.window?.windowScene?.screen.
// Safe areas are often asymmetric — handle each side independently.
// Sources:
//   https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo
//   https://developer.apple.com/documentation/uikit/automatic-trait-tracking
//   https://developer.apple.com/documentation/uikit/uitraitcollection/horizontalsizeclass
//   https://developer.apple.com/videos/play/tech-talks/111461/

import UIKit

final class SizeClassRootViewController: UIViewController {
    private let compactChild: UIViewController
    private let regularChild: UIViewController
    private var current: UIViewController?

    init(compact: UIViewController, regular: UIViewController) {
        self.compactChild = compact
        self.regularChild = regular
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    // viewWillLayoutSubviews supports automatic trait tracking: reading traitCollection here registers
    // for changes, so this re-runs when the device opens/closes or enters Split View.
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let wanted = traitCollection.horizontalSizeClass == .regular ? regularChild : compactChild
        guard wanted !== current else { return }
        swap(to: wanted)
    }

    private func swap(to child: UIViewController) {
        if let old = current {
            old.willMove(toParent: nil)
            old.view.removeFromSuperview()
            old.removeFromParent()
        }
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(child.view)
        // Pin to the view's edges; the child respects safe areas itself (bars sit outside the safe area).
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        child.didMove(toParent: self)
        current = child
    }
}

/// Example content: foreground constrained to the safe area layout guide; background fills bounds.
final class SafeAreaContentViewController: UIViewController {
    private let background = UIImageView()
    private let card = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        background.clipsToBounds = true
        view.addSubview(background)

        card.text = "Foreground content"
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            card.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            card.trailingAnchor.constraint(lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
            card.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        background.frame = view.bounds                       // background may extend past the safe area
        // Prepare page: an unconditional aspect fill crops a hero on a wider display.
        // Choose fill or fit from the current size class.
        // https://developer.apple.com/iphone-duo/prepare/
        let wide = traitCollection.horizontalSizeClass == .regular
        background.contentMode = wide ? .scaleAspectFit : .scaleAspectFill
        let usable = view.bounds.inset(by: view.safeAreaInsets) // each side handled independently
        _ = usable
    }
}
