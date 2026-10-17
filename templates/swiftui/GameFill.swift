// GameFill.swift — SwiftUI template: a game surface that fills every pose.
//
// HIG: "Make your game playable in every device pose. You can choose to lock to either portrait or landscape
// orientation, but be sure to fill the screen as the device pose changes. When resizing, keep text and
// control sizes as consistent as possible. Prefer changing the aspect ratio over letterboxing or
// pillarboxing in games; if you can't avoid letterboxing or pillarboxing, add artwork to the padding area."
// Tech Talk 111461: background content may extend past the safe area (ignoresSafeArea); interactive
// foreground content stays inside it. The inner display doesn't honor supported interface orientations
// (your app scales there), so read the live size instead of assuming one.
// Sources:
//   https://developer.apple.com/design/human-interface-guidelines/designing-for-iphone-duo
//   https://developer.apple.com/videos/play/tech-talks/111461/
//
// Apple documents no Duo-specific game API on these pages. This template is plain SwiftUI; hook
// `viewportDidChange` into your engine (SpriteKit, Metal, RealityKit, …) to resize its camera/viewport.

import SwiftUI

struct GameFillView: View {
    /// The world-space height your game is designed around; width follows the live aspect ratio,
    /// so wider poses show more world instead of adding bars.
    var designHeight: CGFloat = 1000
    var viewportDidChange: (CGSize, CGFloat) -> Void = { _, _ in }

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let aspect = size.height > 0 ? size.width / size.height : 1
            ZStack {
                // 1) Game surface fills the whole display, under bars and status bar.
                GameSurface(visibleWorld: CGSize(width: designHeight * aspect, height: designHeight))
                    .ignoresSafeArea()

                // 2) HUD and controls stay in the safe area, at constant point sizes across poses.
                VStack {
                    HStack {
                        Text("Score 1200").font(.headline.monospacedDigit())
                        Spacer()
                        Button("Pause", systemImage: "pause.fill") { }
                            .labelStyle(.iconOnly)
                            .font(.title2)
                    }
                    Spacer()
                }
                .padding()
            }
            .onAppear { viewportDidChange(size, aspect) }
            .onChange(of: size) { _, newSize in
                viewportDidChange(newSize, newSize.height > 0 ? newSize.width / newSize.height : 1)
            }
        }
    }
}

/// Placeholder for your renderer. It receives the visible world size, not device pixels.
struct GameSurface: View {
    let visibleWorld: CGSize
    var body: some View {
        Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.indigo))
            let ground = CGRect(x: 0, y: size.height * 0.8, width: size.width, height: size.height * 0.2)
            context.fill(Path(ground), with: .color(.green))
        }
    }
}

#Preview("Game fill") { GameFillView() }
