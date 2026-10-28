---
description: "belweave's layout practice for iPhone Duo: two layouts, the path, panes, the toolbar, reach, and gutters. Not an Apple source."
connections: [hig-summary, patterns, design-review-checklist, review-rubric]
---

# Fold-aware layout

This is belweave's layout practice for iPhone Duo. Apple's pages remain the source for device facts, size classes, and APIs (`hig-summary.md`, `sources.md`). This file adds no dimension, inset, or API name.

Where a rule here is the same idea as an Apple rule, the Apple page wins. This file is how we apply it.

## Two layouts

Use one narrow layout and one wide layout, and let them flex as the window changes. Closed, open, portrait, landscape, and Split View all use that pair. Compact width is the narrow layout and regular width is the wide layout. The size-class table is in `hig-summary.md`. This is principle 1 in `SKILL.md`.

## The path

Treat the app as one ordered path, from the general screen to the specific one. Shut, the last screen on that path fills the display. Open, that screen and the one before it are both up. Folding leaves the order alone.

## Side by side

Two panes sit side by side only as a fixed pair: sidebar with content, or content with detail. The detail pane carries a Close of its own, so leaving it doesn't depend on the other pane. List and detail still use a system split view (`patterns.md`).

## System components

Prefer the system component. Bars, sheets, and split views already move when the phone folds, unfolds, or rotates. Build a custom view only when none of those will do the job, and keep that view off the fold the way `hig-summary.md` describes.

## Across the fold

Design the closed and open states as one journey. If a detail is open while the phone is closed, unfolding places that detail beside its parent and the work continues there. The person stays on that detail. The two screens keep the order they had.

## Full screen

Offer the side-by-side layout and a full-screen layout. One button enters full screen. The same button leaves it.

## Navigation on the open phone

Opening a list puts the list on the left. Whatever is already on screen stays on the right until a row is picked. If a file or detail is open and the sidebar comes in, the detail leaves. It comes back when the sidebar closes. Where the current screen will sit should be obvious before the list or the sidebar opens.

## Motion

Watch the fold before you trust a screenshot. A layout can look best as a still and feel wrong while the phone is opening. A sidebar that fills the closed portrait screen can hold together through the unfold better than a drawer that looked tidier in the still.

## Reach

The thumb rests at the bottom of the toolbar on the closed phone, so that is where the primary action goes. Once the phone is open, a hand covers the bottom-right corner, and anything the person has to see or tap stays out of it.

Back or Close still leads a vertical bar, then the prominent action (`hig-summary.md`). Reach picks which of the other actions sits nearest the thumb.

## A short toolbar

Show only the buttons that screen needs. A quiet landscape screen can get by with a pair of buttons. Delete, and any other destructive action, lives only in the overflow menu. `duo-lint` reports a destructive toolbar button outside that menu as DUO019.

Frequent actions and badged items still follow Apple's visibility priority, and the overflow control is still the system's (`hig-summary.md`).

## Under the toolbar

The content background can keep going under the toolbar, so the bar and the panel share one color. Text and controls stay in the open part of the panel.

A hero that runs under a vertical bar uses the system background extension (`hig-summary.md`). The extension carries the image. Labels and buttons stay in the safe area. `duo-lint` DUO006 flags text or controls that ignore the safe area.

## Gutters

Insets on this device are uneven, and Apple doesn't publish the numbers (`sources.md`). When an even gutter looks cramped, widen it by eye. The gap between sidebar and content in landscape is the usual place. Keep using the live insets when you do.

## Panels

Every panel state has a clear way to leave it. The person can change the layout. From the state on screen, the next one should be easy to guess.
