// SizeClassRoot.swift — SwiftUI template: drive layout from size classes, not poses.
//
// Apple: "focus on two size classes: compact width on the outer display and regular width on
// the inner display." Outer display: compact width / regular height in portrait, compact / compact
// in landscape. Inner display: regular / regular. The inner display doesn't honor your supported
// interface orientations, so never branch on orientation.
// Sources:
//   https://developer.apple.com/videos/play/tech-talks/111466/  (Design for iPhone Duo)
//   https://developer.apple.com/videos/play/tech-talks/111461/  (Prepare your app for iPhone Duo)
//   https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo
//
// Requires: none of the iOS 27.1 symbols. Works on any iOS version that has these environment values.

import SwiftUI

struct SizeClassRoot<Compact: View, Regular: View>: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    /// Outer display (and any compact-width container, e.g. a narrow Split View half).
    @ViewBuilder var compact: () -> Compact
    /// Inner display (regular width). Show at most one extra level of hierarchy; keep the same
    /// functionality and controls as the compact layout (HIG: "Create a consistent experience across displays").
    @ViewBuilder var regular: () -> Regular

    var body: some View {
        // Branch only on the horizontal size class for structure. Use verticalSizeClass for
        // small density tweaks (e.g. compact height on the outer display in landscape), never to
        // remove features.
        if horizontalSizeClass == .regular {
            regular()
        } else {
            compact()
        }
    }
}

// Example: the same feed reflows from one column (outer) into two columns (inner),
// like the Music example in the Design Tech Talk. Content is sized to the container.
struct FeedScreen: View {
    let items = (1...24).map { "Item \($0)" }

    var body: some View {
        NavigationStack {
            SizeClassRoot {
                List(items, id: \.self) { Text($0) }
            } regular: {
                ScrollView {
                    // Two columns: an even count divides cleanly at the fold (HIG).
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(items, id: \.self) { item in
                            Text(item)
                                .frame(maxWidth: .infinity, minHeight: 80)
                                .background(.quaternary, in: .rect(cornerRadius: 12))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Feed")
            .toolbar {
                // Title + symbol so the system can present it vertically, horizontally or in overflow.
                ToolbarItem(placement: .primaryAction) {
                    Button("New", systemImage: "plus") { }
                }
            }
        }
    }
}

#Preview("Feed") { FeedScreen() }
