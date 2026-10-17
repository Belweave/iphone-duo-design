---
name: iphone-duo-design
description: "Design and adapt iOS apps for iPhone Duo foldable form factor. Use when creating, reviewing, or updating layouts for dual outer/inner displays, size classes, vertical controls, fold avoidance, split views, arrangement views, or resizable iPhone experiences."
type: knowledge
lifecycle: active
---

# iPhone Duo Design — Adaptive Layouts for Foldable iPhone

Guide for designing and adapting iOS apps so they feel native and continuous across iPhone Duo’s outer (closed) and inner (open) displays, all poses, and Split View multitasking. Based on Apple’s Design for iPhone Duo principles.

## Core Principles

1. **Design for two size classes, not every pose.**  
   Compact width = outer display. Regular width = inner display. These two fundamentals cover every pose. Do not invent a custom layout per pose.

2. **Build freely resizable layouts.**  
   Use layout margins, horizontal safe area insets, and size classes. Avoid fixed widths, breakpoints, or metrics tied to a specific screen or device.

3. **Maintain one consistent experience.**  
   Same functionality, hierarchy, and controls across displays and poses. People open and close the device frequently—do not hide features or change core interactions based on pose.

4. **Maximize vertical content space.**  
   On the shorter/wider outer display (and inner landscape), controls move to the side. Prefer system components so this happens automatically.

5. **Respect the fold.**  
   When partially folded, the center curve is a reserved region. Interactive elements avoid it; scrollable content does not need to.

## Quick Checklist

- [ ] Layout driven by compact (outer) vs regular (inner) size class only
- [ ] Uses layout margins + safe area insets (no hard-coded frames)
- [ ] Standard system bars/toolbars/tab bars (get vertical placement free)
- [ ] Interactive elements clear of fold when partially open (system components or Reserved Region API)
- [ ] Split View / Arrangement View used where hierarchy benefits from side-by-side
- [ ] Sheets, alerts, menus use system behaviors for fold avoidance
- [ ] Tested in Device Hub across closed, open, partial fold, portrait/landscape, Split View

## Size Classes & Dynamic Layouts

| Display / Context              | Horizontal Size Class | Vertical Size Class | Notes |
|--------------------------------|-----------------------|---------------------|-------|
| Outer (closed) portrait        | Compact               | Regular             | Controls on right side |
| Outer landscape                | Compact               | Compact             | — |
| Inner (open) portrait          | Regular               | Regular             | Horizontal bars OK |
| Inner landscape                | Regular               | Compact             | Controls remain on side for continuity |
| Split View (each half)         | Varies                | Varies              | Controls on outer edge of each app |

**Do:**
- Target size classes exclusively for layout decisions.
- Let existing layouts expand into available space.
- Use GeometryReader / trait collection / view.bounds for runtime sizes.
- Re-evaluate layout on size changes (fold/unfold mid-session).

**Don’t:**
- Design custom layouts for book pose, table pose, standing pose, etc.
- Use UIScreen.main.bounds, fixed widths, or interface orientation for layout.
- Assume a specific aspect ratio or single display.

## Vertical Controls

System places toolbars, tab bars, and navigation on the side (except inner portrait) to maximize content height and keep controls thumb-reachable.

**Placement rules:**
- Top of vertical axis: primary navigation (Back, Close) + prominent actions (Done).
- Bottom-aligned: tab bar and bottom toolbar items.
- Wide items (text buttons, segmented controls) stay in place—they do not move to the side.
- Live Activities and status bar share the vertical space; overflow collapses into menu.
- In Split View: each app’s controls sit on its outer edge.

**Asymmetry:**
- Content is offset from the control edge via safe area insets.
- Full-bleed / immersive non-scrolling content can center on full display if interactive elements stay clear of controls.
- Mix: full-width background/header + inset scrollable foreground.

**Priority & grouping:**
- Assign visibility priorities so frequently used items stay visible longer.
- Preserve original groupings; system inserts spacing between top and bottom groups.

## Fold & Reserved Regions

Reserved regions content should avoid or adapt to:
- Outer front camera (always present; expands for Dynamic Island / Live Activities)
- Inner front camera (only when active)
- Folding region (center curve when partially open)

**Behaviors:**
- System components (sheets, alerts, menus, toolbars, split views) automatically avoid the fold.
- Prefer these over custom components.
- For custom UI: use Reserved Region API (SwiftUI `reservedRegions` / UIKit `reservedRegions`) to query frames and offset interactive elements.
- Prefer even column counts in grids so content splits cleanly.
- Avoid dramatic rearrangements—small shifts only. Controls that jump are hard to track.

**Partial fold poses:**
- Landscape book: curve becomes natural divider; content shifts left/right.
- Portrait table: interactive elements prefer bottom half for stability and reach.

## Layout Patterns for Inner Display

Do not simply stretch a compact layout. Useful approaches:

1. **Split views** — Show multiple hierarchy levels simultaneously (list + detail). Collapse to single pane on outer display. Standard NavigationSplitView / UISplitViewController handle fold automatically.
2. **Content reflow** — Vertical stack on compact becomes multi-column on regular (e.g., Music-style).
3. **Sidebar tab bar** — For information-dense apps (Health-style). Only when it improves hierarchy; not for every app.
4. **Arrangement views** — Two-view containers (primary + secondary) that adapt:
   - Split: side-by-side when wider, stacked when taller.
   - Overlay: primary over secondary when flat; side-by-side when folded.
   - Keep navigation outside the arrangement view.

Optional hands-free table pose: media at top, controls on stable base. Only if it preserves the same controls and hierarchy as other poses. Never gate functionality on this pose.

## Sheets & Overlays

- Outer display: sheet controls move to side by default. Disable vertical bar behavior for sheets with a single toolbar button (sheet then stops short of camera; status bar repositions).
- Inner display: standard horizontal bars in both orientations.
- Partial fold: sheets (and many other components) slide aside to avoid the curve.

## Games & Immersive Content

- Lock to one orientation if needed, but fill the screen across poses.
- Prefer changing aspect ratio over letter/pillarboxing; if padding is unavoidable, fill it with artwork.
- Keep control and text sizes consistent while resizing.

## Implementation Notes (SwiftUI / UIKit)

- Prefer system containers: NavigationStack, NavigationSplitView, TabView, ArrangementView, standard toolbars.
- Size class environment / traitCollection for adaptations.
- Safe area insets for content offset.
- Reserved Region APIs for fold/camera avoidance on custom views.
- Build with iOS 27.1+ SDK for full-screen extension and vertical bar support.
- Test in Xcode Device Hub across all poses.

See `references/hig-summary.md` for condensed official guidance and `references/patterns.md` for concrete layout examples.

## Common Issues

| Symptom | Cause | Fix |
|---------|-------|-----|
| Content hidden under side controls | Missing safe area insets | Align to horizontal safe area; let system inset |
| Layout breaks on fold | Fixed widths or one-time size read | Use size classes + re-layout on geometry change; Reserved Region |
| Controls jump or disappear between poses | Custom bar placement | Use system toolbars/tab bars; preserve relative order |
| Features missing on outer display | Pose-specific hierarchy | Keep same controls/functionality; use split view collapse |
| Awkward stretch on inner display | Only compact layout | Add regular-width adaptation (split, reflow, or sidebar) |
| Interactive elements in fold | Custom components ignoring reserved regions | Use system components or query Reserved Region API |

## Sources

Derived from Apple Developer session “Design for iPhone Duo” and official Human Interface Guidelines / Preparing your app for iPhone Duo documentation. Always verify against latest Apple docs and Xcode Device Hub.