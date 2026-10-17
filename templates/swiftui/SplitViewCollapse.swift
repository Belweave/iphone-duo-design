// SplitViewCollapse.swift — SwiftUI template: list/detail that collapses on the outer display.
//
// HIG: "a split view expands on the inner display and collapses to a single pane on the outer display,
// the same way it adapts between regular and compact environments on other iPhone devices. When built
// with standard components, split views adapt to reserved regions automatically."
// Tech Talk 111461: "When iPhone Duo is closed, columns will collapse to single-stack navigation."
// Sources:
//   https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo
//   https://developer.apple.com/documentation/swiftui/navigationsplitview
//   https://developer.apple.com/documentation/swiftui/navigationsplitview/init(columnvisibility:preferredcompactcolumn:sidebar:detail:)
//
// Nothing here is Duo-specific API: the standard NavigationSplitView does the fold and collapse work.
// Keep the selection in state that survives the collapse so opening/closing the device keeps context.

import SwiftUI

struct Message: Identifiable, Hashable {
    let id: Int
    let subject: String
}

struct MailStyleSplitView: View {
    let messages = (1...30).map { Message(id: $0, subject: "Message \($0)") }

    @State private var selection: Message.ID?
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic
    // When collapsed (outer display), show the detail if something is selected, else the list.
    @State private var preferredCompactColumn: NavigationSplitViewColumn = .sidebar

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility,
                            preferredCompactColumn: $preferredCompactColumn) {
            List(messages, selection: $selection) { message in
                Text(message.subject)
            }
            .navigationTitle("Inbox")
            .toolbar {
                // Controls that act on the list stay with the list (HIG: "Locate controls near the content they affect").
                ToolbarItem(placement: .primaryAction) {
                    Button("Filter", systemImage: "line.3.horizontal.decrease") { }
                }
            }
        } detail: {
            if let id = selection, let message = messages.first(where: { $0.id == id }) {
                Text(message.subject)
                    .font(.title)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Button("Reply", systemImage: "arrowshape.turn.up.left") { }
                            Button("Archive", systemImage: "archivebox") { }
                        }
                    }
            } else {
                ContentUnavailableView("No Message Selected", systemImage: "envelope")
            }
        }
        .onChange(of: selection) { _, newValue in
            preferredCompactColumn = (newValue == nil) ? .sidebar : .detail
        }
    }
}

#Preview("Split view") { MailStyleSplitView() }
