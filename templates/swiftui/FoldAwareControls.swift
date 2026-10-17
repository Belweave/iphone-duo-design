// FoldAwareControls.swift — SwiftUI template: keep custom interactive views off the fold (iOS 27.1+).
//
// System components (sheets, alerts, menus, toolbar buttons, split views) already move away from the fold.
// Use this only for CUSTOM controls the system doesn't move. Scrollable content doesn't need to avoid
// the fold. Move only what's necessary, keep related elements together, and avoid big jumps.
//
// API facts used (all from Apple docs):
//   • GeometryProxy.reservedRegions(kind:options:layoutDirectionBehavior:) -> [ReservedRegion]
//   • ReservedRegion.Kind: .division (fold) and .occlusion (camera, Dynamic Island, window controls)
//   • ReservedRegion.frame (in the view's coordinate space, INCLUDING margins for interactive content),
//     .isActive, .margins, .kind, .id
//   • ReservedRegion.QueryOptions.includeInactive — the fold's division region is inactive (zero width)
//     when the device is flat; inactive regions are useful for high-level decisions such as even grid columns.
//   • Frames are mirrored for right-to-left by default; pass layoutDirectionBehavior: .fixed to opt out.
// Sources:
//   https://developer.apple.com/documentation/swiftui/reservedregion
//   https://developer.apple.com/documentation/swiftui/geometryproxy/reservedregions(kind:options:layoutdirectionbehavior:)
//   https://developer.apple.com/documentation/swiftui/reservedregion/queryoptions
//   https://developer.apple.com/documentation/swiftui/layout
//   https://developer.apple.com/videos/play/tech-talks/111463/
//
// Doc discrepancy to be aware of: the ReservedRegion page says the query "returns all of the reserved
// regions that currently intersect your view regardless of whether they are currently active", while the
// Tech Talk and the includeInactive option say only active regions are returned by default. This code
// filters on isActive explicitly so it is correct either way.
//
// Apple's sample names a `RegionAvoidingLayout` but doesn't publish its implementation. The
// `FoldAvoidingRow` below is this repo's own implementation of that idea, built only on the public
// Layout protocol.

import SwiftUI

/// Lays out subviews in a row. If a subview would overlap an avoided rect (e.g. an active fold),
/// it is nudged to the nearer side of that rect — a small displacement, not a rearrangement.
struct FoldAvoidingRow: Layout {
    /// Rects to avoid, in the coordinate space of the GeometryReader that produced them.
    var avoid: [CGRect]
    var spacing: CGFloat = 12

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let width = sizes.map(\.width).reduce(0, +) + spacing * CGFloat(max(0, sizes.count - 1))
        let height = sizes.map(\.height).max() ?? 0
        return CGSize(width: proposal.width ?? width, height: proposal.height ?? height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let total = sizes.map(\.width).reduce(0, +) + spacing * CGFloat(max(0, sizes.count - 1))
        var x = bounds.midX - total / 2
        for (index, subview) in subviews.enumerated() {
            let size = sizes[index]
            // Work in local coordinates (relative to bounds.origin) to compare with the region frames.
            var local = CGRect(x: x - bounds.minX, y: (bounds.height - size.height) / 2,
                               width: size.width, height: size.height)
            for region in avoid where region.intersects(local) {
                let moveLeft = local.midX < region.midX
                local.origin.x = moveLeft ? region.minX - local.width : region.maxX
            }
            subview.place(at: CGPoint(x: bounds.minX + local.minX, y: bounds.minY + local.minY),
                          anchor: .topLeading, proposal: ProposedViewSize(size))
            x += size.width + spacing
        }
    }
}

/// A custom transport bar whose buttons step aside from an active fold.
struct FoldAwareTransportBar: View {
    var body: some View {
        GeometryReader { proxy in
            let folds = proxy.reservedRegions(kind: .division).filter(\.isActive).map(\.frame)
            FoldAvoidingRow(avoid: folds) {
                Button("Back", systemImage: "backward.fill") { }
                Button("Play", systemImage: "play.fill") { }
                Button("Forward", systemImage: "forward.fill") { }
            }
            .labelStyle(.iconOnly)
            .font(.title2)
        }
        .frame(height: 64)
    }
}

/// Keeps a floating control clear of an active occlusion region (e.g. the inner camera when it is active).
struct CameraAwareBadge: View {
    var body: some View {
        GeometryReader { proxy in
            let occluded = proxy.reservedRegions(kind: .occlusion).filter(\.isActive).map(\.frame)
            let topTrailing = CGRect(x: proxy.size.width - 140, y: 8, width: 132, height: 36)
            let blocked = occluded.contains { $0.intersects(topTrailing) }
            Button("Live", systemImage: "dot.radiowaves.left.and.right") { }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, maxHeight: .infinity,
                       alignment: blocked ? .topLeading : .topTrailing)
                .padding(8)
        }
    }
}

/// Grid that prefers an even column count whenever the view intersects a division region — active or not —
/// so content divides cleanly when the device folds (HIG + Tech Talk 111463).
struct FoldFriendlyGrid<Item: Identifiable, Cell: View>: View {
    let items: [Item]
    @ViewBuilder var cell: (Item) -> Cell
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        GeometryReader { proxy in
            let hasFold = !proxy.reservedRegions(kind: .division, options: .includeInactive).isEmpty
            let base = horizontalSizeClass == .regular ? 3 : 2
            let count = (hasFold && base % 2 == 1) ? base + 1 : base
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: count)) {
                    ForEach(items) { cell($0) }
                }
                .padding()
            }
        }
    }
}

#Preview("Transport bar") { FoldAwareTransportBar() }
