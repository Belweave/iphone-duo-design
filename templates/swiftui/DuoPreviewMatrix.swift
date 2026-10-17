// DuoPreviewMatrix.swift — SwiftUI previews across the size-class configurations Apple names for iPhone Duo.
//
// What Apple documents (Tech Talk 111461 and the Design Tech Talk 111466):
//   • Outer display, portrait:  horizontal compact, vertical regular
//   • Outer display, landscape: horizontal compact, vertical compact
//   • Inner display (open):     horizontal regular, vertical regular
//   • Split View multitasking on the inner display (50/50) and Picture in Picture pinned to the top also
//     resize your app; Apple doesn't state their size classes on these pages, so they are not faked here.
//
// What previews CANNOT show: the fold (division reserved region), the camera occlusion regions, vertical
// bar placement, sheets sliding aside, and Split View. Apple doesn't publish point sizes for the displays
// either, so this helper does not invent frame sizes. For all of that, run the iPhone Duo simulator in
// Xcode's Device Hub (Closed / Partially Open / Open buttons; Option-drag the slider for any fold angle):
//   https://developer.apple.com/documentation/xcode/interacting-with-your-app-in-device-hub
// For a visual mock-up of a screenshot with fold, side-control and Split View overlays, use
// tools/duo-preview.html in this repo.
//
// Use: wrap any view.
//   #Preview("Duo matrix") { DuoPreviewMatrix { MyScreen() } }
// Or pick one configuration:
//   #Preview("Outer portrait") { MyScreen().duoSizeClasses(.outerPortrait) }

import SwiftUI

enum DuoSizeClassConfiguration: String, CaseIterable, Identifiable {
    case outerPortrait = "Outer display · portrait (compact w / regular h)"
    case outerLandscape = "Outer display · landscape (compact w / compact h)"
    case inner = "Inner display (regular w / regular h)"

    var id: String { rawValue }

    var horizontal: UserInterfaceSizeClass {
        switch self {
        case .outerPortrait, .outerLandscape: return .compact
        case .inner: return .regular
        }
    }

    var vertical: UserInterfaceSizeClass {
        switch self {
        case .outerPortrait, .inner: return .regular
        case .outerLandscape: return .compact
        }
    }
}

extension View {
    /// Overrides the size-class environment to match one documented iPhone Duo configuration.
    func duoSizeClasses(_ configuration: DuoSizeClassConfiguration) -> some View {
        environment(\.horizontalSizeClass, configuration.horizontal)
            .environment(\.verticalSizeClass, configuration.vertical)
    }
}

/// Renders the content once per documented configuration, stacked and labeled, so a single preview
/// shows every size-class branch. It checks branching logic only — not real geometry.
struct DuoPreviewMatrix<Content: View>: View {
    var configurations: [DuoSizeClassConfiguration] = DuoSizeClassConfiguration.allCases
    @ViewBuilder var content: () -> Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(configurations) { configuration in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(configuration.rawValue).font(.caption.bold())
                        content()
                            .duoSizeClasses(configuration)
                            .frame(maxWidth: .infinity, minHeight: 240)
                            .border(.secondary)
                    }
                }
            }
            .padding()
        }
    }
}

#Preview("Duo size-class matrix") {
    DuoPreviewMatrix {
        SizeClassProbe()
    }
}

/// Shows which size classes the content sees — handy for checking your own branches.
struct SizeClassProbe: View {
    @Environment(\.horizontalSizeClass) private var h
    @Environment(\.verticalSizeClass) private var v
    var body: some View {
        Text("horizontal: \(h == .regular ? "regular" : "compact") · vertical: \(v == .regular ? "regular" : "compact")")
            .font(.footnote.monospaced())
            .padding()
    }
}
