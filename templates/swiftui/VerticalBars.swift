// VerticalBars.swift — SwiftUI template: organize toolbar items for vertical presentation (iOS 27.1+).
//
// Sources (all Apple):
//   https://developer.apple.com/documentation/technologyoverviews/preparing-your-app-for-iphone-duo
//   https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo
//   https://developer.apple.com/videos/play/tech-talks/111462/  (Raise the bar with iPhone Duo)
//   https://developer.apple.com/documentation/swiftui/toolbaritemplacement/topbarpinnedtrailing
//   https://developer.apple.com/documentation/swiftui/toolbarcontent/axisbehavior(_:)
//   https://developer.apple.com/documentation/swiftui/toolbaritemvisibilitypriority
//   https://developer.apple.com/documentation/swiftui/toolbaroverflowmenu
//   https://developer.apple.com/documentation/swiftui/view/toolbarverticalcompressionbehavior(_:)
//   https://developer.apple.com/documentation/swiftui/environmentvalues/toolbarverticaledge
//   https://developer.apple.com/documentation/swiftui/view/backgroundextensioneffect()
//
// Rules this encodes:
//   • Bars come from navigation containers (.toolbar inside NavigationStack/NavigationSplitView).
//   • Top of the vertical axis: Back/Close (cancellationAction), then prominent actions (topBarPinnedTrailing).
//   • Every non-text item has a title AND a symbol; title-only or custom-view items aren't presented vertically.
//   • Group with ToolbarItemGroup; no manual spacing.
//   • Visibility priority keeps frequent and badged items visible longest; overflow goes into the system menu.
//   • Task-oriented screens may prefer toolbar items over the tab bar when space runs out.

import SwiftUI

struct ComposeScreen: View {
    @Environment(\.toolbarVerticalEdge) private var verticalEdge   // nil when no vertical bar is used
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        NavigationStack {
            ScrollView {
                Image(systemName: "photo")              // replace with your hero image
                    // Prepare page: choose fill or fit from the size class so a wider display doesn't crop the subject.
                    // https://developer.apple.com/iphone-duo/prepare/
                    .resizable()
                    .aspectRatio(contentMode: horizontalSizeClass == .regular ? .fit : .fill)
                    .frame(maxWidth: .infinity, minHeight: 220)
                    .backgroundExtensionEffect()        // extends under a vertical bar
                Text("Body").padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") { }
                }
                ToolbarItem(placement: .topBarPinnedTrailing) {
                    Button("Send", systemImage: "paperplane") { }
                }
                .visibilityPriority(.high)

                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Attach", systemImage: "paperclip") { }
                    Button("Photo", systemImage: "photo.on.rectangle") { }
                }

                // A meaningful text value that should stay in the horizontal bar.
                ToolbarItem {
                    Text("Draft").font(.caption)
                }
                .axisBehavior(.horizontalOnly)

                ToolbarOverflowMenu {
                    Button("Save as Template", systemImage: "doc.badge.plus") { }
                    Button("Schedule", systemImage: "clock") { }
                }
            }
            .toolbarVerticalCompressionBehavior(.prefersToolbarItems)
        }
    }
}

#Preview("Vertical bars") { ComposeScreen() }
