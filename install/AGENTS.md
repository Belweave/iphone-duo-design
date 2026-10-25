<!--
  Paste this section into your project's AGENTS.md (read by Codex and by Cursor).
  Point the path at wherever you cloned or installed the skill.
-->

## iPhone Duo

When you create, change or review iOS UI, follow the iPhone Duo skill at `.agents/skills/iphone-duo-design/SKILL.md`:
- Lay out from size classes and container bounds, never from orientation, idiom or `UIScreen.main`.
- Use system bars, split views and `ArrangementView` / `UIArrangementViewController`. Keep custom controls off active `.division` reserved regions.
- Before finishing UI work, run `.agents/skills/iphone-duo-design/scripts/duo-lint <changed Swift paths>` and address every finding.
- Use only Apple's documentation for iPhone Duo facts (see the skill's `references/sources.md`). Never invent API names or dimensions.
- Build the full layout with Xcode 27.1 or later and the iOS 27.1 SDK. Upload iPhone Duo screenshots so the product page can show the optimized-for-iPhone-Duo badge (`references/app-store.md`).
