// GameFillViewController.swift — UIKit template: a game view that fills every pose.
//
// HIG: fill the screen as the pose changes; prefer changing the aspect ratio over letterboxing/pillarboxing;
// keep text and control sizes consistent. You may lock to portrait or landscape, but Tech Talk 111461
// notes the inner display doesn't honor supported interface orientations (your app scales there), so
// always read the live bounds.
// Sources:
//   https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo
//   https://developer.apple.com/videos/play/tech-talks/111461/
//   https://developer.apple.com/documentation/uikit/uiviewcontroller/supportedinterfaceorientations
//
// Apple documents no Duo-specific game API on these pages; connect `resizeViewport` to your engine.

import UIKit

final class GameFillViewController: UIViewController {
    /// World units visible vertically; horizontal extent follows the live aspect ratio.
    var designHeight: CGFloat = 1000
    var resizeViewport: (_ pixelSize: CGSize, _ visibleWorld: CGSize) -> Void = { _, _ in }

    private let renderView = UIView()     // replace with MTKView, SKView, ARView, …
    private let pauseButton = UIButton(configuration: .filled())

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .landscape } // allowed; still fill

    override func viewDidLoad() {
        super.viewDidLoad()
        renderView.backgroundColor = .systemIndigo
        view.addSubview(renderView)

        pauseButton.configuration?.image = UIImage(systemName: "pause.fill")
        pauseButton.accessibilityLabel = "Pause"
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pauseButton)
        NSLayoutConstraint.activate([
            pauseButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            pauseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        renderView.frame = view.bounds   // the game surface fills the display, past the safe area
        let size = view.bounds.size
        let aspect = size.height > 0 ? size.width / size.height : 1
        let scale = traitCollection.displayScale
        resizeViewport(CGSize(width: size.width * scale, height: size.height * scale),
                       CGSize(width: designHeight * aspect, height: designHeight))
    }
}
