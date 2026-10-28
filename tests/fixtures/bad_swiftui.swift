// Fixture: SwiftUI code with iPhone Duo problems. Each "expect:" marks a finding the test requires.
import SwiftUI

struct BadFeedView: View {
    @State private var items: [String] = []
    let columns = Array(repeating: GridItem(.flexible()), count: 3) // expect: DUO008

    var body: some View {
        NavigationStack {
            VStack {
                Text("Feed")
                    .frame(width: 390) // expect: DUO002
                LazyVGrid(columns: columns) {
                    ForEach(items, id: \.self) { Text($0) }
                }
                LazyVGrid(columns: [GridItem(), GridItem(), GridItem(), GridItem(), GridItem()]) { // expect: DUO008
                    Text("five")
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { } // expect: DUO011
                }
                ToolbarItem {
                    Button("Delete", role: .destructive) { } // expect: DUO019
                }
                ToolbarItem {
                    Menu {
                        Button("Share", systemImage: "square.and.arrow.up") { }
                    } label: {
                        Image(systemName: "ellipsis.circle") // expect: DUO010
                    }
                }
            }
        }
    }
}

struct BadControlsOverlay: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button("Play") { }
                Button("Next") { }
            }
        }
        .ignoresSafeArea() // expect: DUO006
    }
}

struct BadCenteredButton: View {
    var body: some View {
        GeometryReader { proxy in
            Button("Shutter") { }
                .position(x: proxy.size.width / 2, y: proxy.size.height - 80) // expect: DUO009
        }
    }
}

struct BadOrientation: View {
    var body: some View {
        if UIDevice.current.orientation.isLandscape { // expect: DUO003
            Text("wide")
        } else {
            Text("tall")
        }
    }
}

struct BadScreenMath: View {
    var body: some View {
        Text("Hello")
            .frame(minWidth: UIScreen.main.bounds.width) // expect: DUO001
    }
}

struct BadArrangementPlacement: View {
    var body: some View {
        ScrollView {
            ArrangementView { // expect: DUO013
                Text("Primary")
            } secondary: {
                Text("Secondary")
            }
        }
    }
}

struct BadHardcodedPhoneSize: View {
    let knownPhoneHeights = [812, 844, 896] // expect: DUO014

    var body: some View {
        GeometryReader { proxy in
            if proxy.size.height == 852 { // expect: DUO014
                Text("old phone")
            }
            Image("hero")
                .resizable()
                .scaledToFill() // expect: DUO015
        }
    }
}

struct BadIdiomSizeClass: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var body: some View {
        let isIPad = horizontalSizeClass == .regular // expect: DUO017
        Text(isIPad ? "wide" : "narrow")
    }
}

enum BadCompatibility {
    static let key = "UIDesignRequiresCompatibility" // expect: DUO018
}

struct BadTitleUnderBar: View {
    var body: some View {
        Text("Title")
            .ignoresSafeArea() // expect: DUO006
    }
}
