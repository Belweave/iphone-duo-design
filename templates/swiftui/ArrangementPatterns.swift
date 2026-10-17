// ArrangementPatterns.swift — SwiftUI template: split and overlay arrangements (iOS 27.1+).
//
// ArrangementView holds a primary and a secondary view and arranges them from the size, size class
// and hardware features (such as the fold).
//   • Split: side by side when wider than tall, stacked when taller than wide; adapts to the fold.
//     Use where you'd otherwise write an HStack/VStack.
//   • Overlay: primary on top of secondary (z-order) when flat or closed; when partially open the
//     primary goes to the trailing/bottom region and the secondary to the leading/top region.
//     Use where you'd otherwise write a ZStack.
// Keep navigation OUTSIDE (wrap in NavigationStack / TabView). Don't put an ArrangementView inside a
// NavigationSplitView, List or ScrollView.
// Sources:
//   https://developer.apple.com/documentation/swiftui/arrangementview
//   https://developer.apple.com/documentation/swiftui/view/arrangementviewstyle(_:)
//   https://developer.apple.com/documentation/swiftui/splitarrangementviewstyle
//   https://developer.apple.com/documentation/swiftui/overlayarrangementviewstyle
//   https://developer.apple.com/documentation/swiftui/environmentvalues/overlayarrangementzindex
//   https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo
//   https://developer.apple.com/videos/play/tech-talks/111463/  (Strike a pose with adaptive layouts)
//
// NOTE: The HIG says you can "collapse the secondary view in an overlay arrangement". The API pages
// checked for this repo (ArrangementView, OverlayArrangementViewStyle) list only init() and axes(_:),
// so no collapse property is used here. Apple's Tech Talk instead shows reading
// overlayArrangementZIndex and swapping in a collapsed version of the view; that is what we do below.

import SwiftUI

// MARK: Split — a player with its lyrics/up-next list (Apple's own example shape).
struct PlayerWithUpNext: View {
    var body: some View {
        NavigationStack {
            ArrangementView {
                NowPlaying()
            } secondary: {
                UpNextList(minimized: false)
            }
            // Only split side by side; when the container is taller than wide and can't split on this
            // axis, the arrangement shows a single view (Tech Talk 111463).
            .arrangementViewStyle(.split.axes(.horizontal))
            .navigationTitle("Now Playing")
        }
    }
}

// MARK: Overlay — controls/list over a media surface.
struct PlayerWithOverlay: View {
    var body: some View {
        NavigationStack {
            ArrangementView {
                OverlayAwareUpNext()      // primary: on top when flat; trailing/bottom region when folded
            } secondary: {
                NowPlaying()              // secondary: underneath when flat; leading/top region when folded
            }
            .arrangementViewStyle(.overlay)
        }
    }
}

/// Reads the overlay z-index to switch between a collapsed (layered) and expanded (side-by-side) form,
/// following the Tech Talk sample (`zIndex > 0 ? .collapsed : .expanded`).
struct OverlayAwareUpNext: View {
    @Environment(\.overlayArrangementZIndex) private var zIndex: Int

    var body: some View {
        UpNextList(minimized: zIndex > 0)
    }
}

struct NowPlaying: View {
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 16).fill(.tint.opacity(0.3)).aspectRatio(1, contentMode: .fit)
            HStack(spacing: 24) {
                Button("Back", systemImage: "backward.fill") { }
                Button("Play", systemImage: "play.fill") { }
                Button("Forward", systemImage: "forward.fill") { }
            }
            .labelStyle(.iconOnly)
            .font(.title)
        }
        .padding()
    }
}

struct UpNextList: View {
    let minimized: Bool
    var body: some View {
        if minimized {
            Label("Up Next: 12 items", systemImage: "list.bullet")
                .padding()
                .background(.regularMaterial, in: .capsule)
        } else {
            List((1...12).map { "Track \($0)" }, id: \.self) { Text($0) }
        }
    }
}

#Preview("Split arrangement") { PlayerWithUpNext() }
#Preview("Overlay arrangement") { PlayerWithOverlay() }
