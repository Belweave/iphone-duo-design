---
description: "Concrete layout patterns for iPhone Duo, each mapped to a template in templates/."
connections: [hig-summary, api-index]
---

# iPhone Duo layout patterns

## Mapping existing controls [Tech Talk 111466]
| Classic iPhone | iPhone Duo with side controls |
|---|---|
| Top toolbar buttons | Top of the vertical control area |
| Bottom toolbar buttons | Bottom of the vertical control area |
| Tab bar | Stays bottom-aligned on the side |
| Items too wide for the side, such as a text button or segmented control | Stay in the navigation bar (use `axisBehavior(.horizontalOnly)` to make it explicit) |

## Outer display content strategies [Tech Talk 111466]
1. **Inset content (default).** Align to the horizontal safe area so nothing hides under the side controls.
2. **Full-bleed immersive.** Center on the full display for visual UIs that don't scroll. Make sure nothing interactive is covered by the side controls.
3. **Hybrid.** A full-width background or header with inset scrollable content that holds every interactive element. The `backgroundExtensionEffect()` modifier extends a hero under the vertical bar.

## Inner display enhancements [Tech Talks 111466, 111461]
| Pattern | When | Template |
|---|---|---|
| List plus detail (`NavigationSplitView` / `UISplitViewController`) | Hierarchical content | `templates/*/SplitViewCollapse.swift` |
| Reflow from one column to two | Feeds and cards | `templates/swiftui/SizeClassRoot.swift` |
| Tab sidebar (`defaultTabBarPlacement(.sidebar)`) | Information-dense apps, as in Health | — |
| Split arrangement | An HStack or VStack of two peers | `templates/*/ArrangementPatterns.swift` |
| Overlay arrangement | A ZStack with a foreground and background | `templates/*/ArrangementPatterns.swift` |

Choosing between arrangements (Tech Talk 111463): pick **overlay** when there's a clear foreground and background, and partly covering scrollable content is acceptable. Pick **split** for a main and detail pair where neither should be covered.

## Across the fold

The prose is in `references/fold-aware-layout.md`. These rows are the parts that map to a template.

| What you're doing | What happens | Template |
|---|---|---|
| Sidebar with content, or content with detail | The only side-by-side pairs. The detail pane carries a Close of its own | `templates/*/SplitViewCollapse.swift` |
| Unfold while a detail is open | That detail sits beside its parent. The path order stays as it was | `templates/*/SplitViewCollapse.swift` |
| Full screen | One button enters full screen, and the same button leaves it | — |
| Open a list on the open phone | The list is on the left. Current content stays on the right until a row is picked. A sidebar hides an open detail and brings it back when the sidebar closes | `templates/*/SplitViewCollapse.swift` |

## Fold displacement [Tech Talk 111463]
- Move one element on its own if it can adapt independently. Move a group together if its parts work together.
- Avoid moving elements far from where they started.
- Book pose: alerts go to the trailing side, near where they'll appear on the outer display.
- Tabletop: glanceable content goes to the top region and touch controls to the bottom.
- A grid can keep its outer margins while widening the gap at the hinge.
- Continuous scrolling content (articles, feeds, lists) doesn't move.
- Templates: `templates/*/FoldAware*.swift`.

## Fold-aware grid [HIG]
Prefer an even column count. Query `reservedRegions(kind: .division, options: .includeInactive)` to decide even while the device is flat (`FoldFriendlyGrid` / `foldFriendlyColumnCount`).

## Optional tabletop layout [Tech Talk 111466]
Only use it when it adds value, for example media at the top and controls on the stable base. It must have the same controls and hierarchy as the other poses. Never make it the only way to reach a feature.

## Hero images [prepare page](https://developer.apple.com/iphone-duo/prepare/)
An unconditional `.scaleAspectFill`, `.scaledToFill()`, or `.aspectRatio(contentMode: .fill)` crops a hero when the window gets wider. Choose fill or fit from the horizontal size class or the current aspect ratio, or set a focal point. `templates/swiftui/VerticalBars.swift` and `templates/uikit/SizeClassRootViewController.swift` do the size-class choice. `duo-lint` DUO015 flags a fill that has no fit beside it.

## Testing
Use `references/test-plan.md` in Device Hub, and resize iPhone Mirroring on macOS 27. For a quick visual check of a screenshot, use `tools/duo-preview.html`.
