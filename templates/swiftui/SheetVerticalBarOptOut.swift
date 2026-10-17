// SheetVerticalBarOptOut.swift — SwiftUI template: single-button sheet that keeps a horizontal bar (iOS 27.1+).
//
// Design Tech Talk: on the outer display sheet controls move to the side by default, "But you can keep
// them from moving ... by disabling the vertical bar in the sheet. This works well for sheets with only a
// single toolbar button. If you use this option, sheets stop just short of the front-facing camera and the
// status bar repositions itself."
// Preparing your app: "Use toolbarVerticalBehavior(_:) in SwiftUI ... to disable vertical presentation for
// your bars." On the inner display the toolbar is horizontal for centered or leading sheets and vertical for
// trailing ones; presentationPlacement(_:) chooses the placement (sheets only).
// API doc: "Treat it as a stable choice: avoid changing it frequently ... don't toggle it for a single view
// as a function of that view's state." A NavigationStack resolves the behavior from its top-most view.
// Sources:
//   https://developer.apple.com/videos/play/tech-talks/111466/
//   https://developer.apple.com/documentation/swiftui/view/toolbarverticalbehavior(_:)
//   https://developer.apple.com/documentation/swiftui/toolbarverticalbehavior
//   https://developer.apple.com/documentation/swiftui/view/presentationplacement(_:)
//   https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo

import SwiftUI

struct NoteListView: View {
    @State private var showingTip = false

    var body: some View {
        NavigationStack {
            List { Text("Notes") }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Tips", systemImage: "lightbulb") { showingTip = true }
                    }
                }
                .sheet(isPresented: $showingTip) {
                    SingleButtonSheet()
                        .presentationDetents([.medium, .large])
                        // Optional: on the inner display, choose where the sheet sits.
                        .presentationPlacement(.center)
                }
        }
    }
}

struct SingleButtonSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Text("Swipe left on a note to pin it.")
                .padding()
                .navigationTitle("Tip")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done", systemImage: "checkmark") { dismiss() }
                    }
                }
                // The one opt-out. Applied to the stack's top-most view, set once, never toggled by state.
                .toolbarVerticalBehavior(.disabled)
        }
    }
}

#Preview("Single-button sheet") { NoteListView() }
