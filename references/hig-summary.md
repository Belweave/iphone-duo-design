---
description: "Condensed official Apple Human Interface Guidelines and preparation notes for iPhone Duo."
connections: [patterns]
---

# iPhone Duo HIG Summary

## Anatomy
- Outer display (closed): shorter/wider than classic iPhone. Controls on right side.
- Inner display (open): large immersive canvas. Controls on side in landscape for continuity; horizontal bars OK in portrait.
- Hinge / fold creates reserved region when partially open.
- Outer camera always visible (corner); inner camera appears only when active.

## Best Practices (from HIG)
- Build to resize. Use size classes, layout margins, safe area insets.
- Consistent experience across displays: same functionality and hierarchy; optional extra hierarchy level on inner.
- Same controls regardless of pose.
- Follow system vertical layout for bars (automatic with standard components).
- Games: playable in every pose; prefer aspect-ratio change over letterboxing.

## Reserved Regions
- Outer camera + Dynamic Island
- Inner camera (conditional)
- Folding region (conditional on partial open)

System components adapt automatically. Custom views use Reserved Region API.

## Arrangement Views
- Split: primary + secondary side-by-side (horizontal when wide, vertical when tall).
- Overlay: primary over secondary when flat; side-by-side when folded.
- Keep navigation outside.

## Vertical Controls Details
- Exception: inner portrait keeps horizontal bars.
- Split View: controls on each app’s outer edge.
- Account for asymmetry via safe areas.
- Keep relative control order consistent across poses.
- Top of vertical axis for primary nav + prominent actions.
- Visibility priorities control overflow order.
- Do not override default bar placement in general.
- Full-display width OK for immersive non-scrolling UIs if interactive elements stay clear.

## Sheets
- Outer: controls to side by default; can disable for single-button sheets.
- Inner: horizontal bars.
- Partial fold: slide aside to avoid curve.

Always cross-check latest Apple Developer Documentation and test in Xcode Device Hub.