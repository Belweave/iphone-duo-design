// FoldAwareControlView.swift — UIKit template: a custom control row that steps off the fold (iOS 27.1+).
//
// UIView.reservedRegions(kind:options:) returns [UIView.ReservedRegion]. Kinds: .division (fold) and
// .occlusion (camera etc.). Each region has frame (view coordinates, including margins for interactive
// content), isActive, kind, margins. QueryOptions.includeInactive includes inactive regions (the fold is
// inactive — zero width — when the device is flat).
// Sources:
//   https://developer.apple.com/documentation/uikit/uiview/reservedregion
//   https://developer.apple.com/documentation/uikit/uiview/reservedregions(kind:options:)
//   https://developer.apple.com/documentation/uikit/uiview/reservedregion/queryoptions
//   https://developer.apple.com/videos/play/tech-talks/111463/
//
// Not documented on Apple's pages: a notification for "reserved regions changed". This view re-queries in
// layoutSubviews(), which runs when its bounds change. Verify on the iPhone Duo simulator (Device Hub,
// Partially Open) that layout runs when you fold; if it doesn't for your hierarchy, call setNeedsLayout()
// from your size-change handling. The talk calls the type "UIViewReservedRegion"; the API page title is
// UIView.ReservedRegion (Swift).

import UIKit

final class FoldAwareControlRow: UIView {
    private let buttons: [UIButton]
    var spacing: CGFloat = 12

    init(symbols: [(title: String, systemImage: String)]) {
        buttons = symbols.map { item in
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: item.systemImage)
            let button = UIButton(configuration: config)
            button.accessibilityLabel = item.title
            return button
        }
        super.init(frame: .zero)
        buttons.forEach(addSubview)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) is not supported") }

    override func layoutSubviews() {
        super.layoutSubviews()
        let folds = reservedRegions(kind: .division).filter(\.isActive).map(\.frame)
        let sizes = buttons.map { $0.intrinsicContentSize }
        let total = sizes.map(\.width).reduce(0, +) + spacing * CGFloat(max(0, sizes.count - 1))
        var x = bounds.midX - total / 2
        for (button, size) in zip(buttons, sizes) {
            var rect = CGRect(x: x, y: bounds.midY - size.height / 2, width: size.width, height: size.height)
            for fold in folds where fold.intersects(rect) {
                // Small displacement to the nearer side; don't rearrange the whole row.
                rect.origin.x = rect.midX < fold.midX ? fold.minX - rect.width : fold.maxX
            }
            button.frame = rect
            x += size.width + spacing
        }
    }
}

/// Even column count whenever the view intersects a division region, active or not.
func foldFriendlyColumnCount(for view: UIView, base: Int) -> Int {
    let hasFold = !view.reservedRegions(kind: .division, options: .includeInactive).isEmpty
    return (hasFold && base % 2 == 1) ? base + 1 : base
}
