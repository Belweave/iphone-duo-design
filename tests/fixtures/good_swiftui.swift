// Fixture: SwiftUI code that follows Apple's iPhone Duo guidance. duo-lint must report nothing here.
// Mentions inside comments are ignored: UIScreen.main.bounds, .frame(width: 390), UIToolbar().
import SwiftUI

struct GoodRootView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    let note = "UIScreen.main is only text inside a string"

    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark") { }
                    }
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("Compose", systemImage: "square.and.pencil") { }
                        Button("Filter", systemImage: "line.3.horizontal.decrease") { }
                    }
                    ToolbarOverflowMenu {
                        Button("Export", systemImage: "square.and.arrow.up") { }
                    }
                }
        }
    }

    @ViewBuilder private var content: some View {
        if horizontalSizeClass == .regular {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4)) { Text("Grid") }
        } else {
            LazyVGrid(columns: [GridItem(), GridItem()]) { Text("Grid") }
        }
    }
}

struct GoodBackground: View {
    var body: some View {
        VStack {
            Button("Play", systemImage: "play.fill") { }
                .frame(width: 44, height: 44)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("hero").resizable().scaledToFill().ignoresSafeArea()
        }
    }
}

struct GoodFoldAwareButton: View {
    var body: some View {
        GeometryReader { proxy in
            let folds = proxy.reservedRegions(kind: .division).filter(\.isActive)
            Button("Shutter", systemImage: "camera") { }
                .position(x: folds.isEmpty ? proxy.size.width / 2 : proxy.size.width * 0.75,
                          y: proxy.size.height - 80)
        }
    }
}

struct GoodArrangement: View {
    var body: some View {
        NavigationStack {
            ArrangementView {
                Text("Player")
            } secondary: {
                Text("Up Next")
            }
            .arrangementViewStyle(.split.axes(.horizontal))
        }
    }
}

struct Suppressed: View {
    var body: some View {
        Text("Intentional").frame(width: 600) // duo-lint:disable=DUO002
    }
}
