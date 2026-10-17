---
description: "Concrete layout patterns and mapping guidance for iPhone Duo."
connections: [hig-summary]
---

# iPhone Duo Layout Patterns

## Mapping Existing Controls
| Classic iPhone          | iPhone Duo (side controls)     |
|-------------------------|--------------------------------|
| Top nav buttons         | Top of vertical control area   |
| Bottom toolbar buttons  | Bottom of vertical control area|
| Tab bar                 | Bottom-aligned on side         |
| Wide items (segmented, text buttons) | Stay in place (do not move) |

## Outer Display Content Strategies
1. **Inset content** (default) — Align to horizontal safe area so nothing hides under side controls.
2. **Full-bleed immersive** — Center on full display for non-scrolling visual UIs; ensure tappable elements stay clear of right-side controls.
3. **Hybrid** — Full-width background/header + inset scrollable content containing all interactive elements.

## Inner Display Enhancements
- **List + Detail**: NavigationSplitView collapses on outer, expands on inner.
- **Reflow**: VStack of cards → multi-column LazyVGrid or HStack when regular width.
- **Sidebar**: TabView as sidebar for dense apps (Settings, Health-style).
- **ArrangementView**:
  ```swift
  ArrangementView {
      PrimaryView()
  } secondary: {
      SecondaryView()
  }
  .arrangementViewStyle(.split) // or .overlay
  ```

## Fold-Aware Grid
Prefer even number of columns so content divides cleanly around the center reserved region.

## Hands-Free Table Pose (Optional)
Only when it adds value (media top, controls bottom on stable base). Must contain identical controls and hierarchy as other poses. Never the only way to access a feature.

## Testing Poses in Device Hub
- Closed (outer portrait/landscape)
- Fully open (inner portrait/landscape)
- Partially folded (book / table)
- Split View 50/50
- Picture-in-Picture + fold

Verify continuity of control locations and no interactive elements trapped in the fold.