# Prompt: review a screen for iPhone Duo

Copy this prompt into your coding agent and fill in the `<…>` fields. It assumes the `iphone-duo-design` skill is installed, or that this repository is available at `<path-to-skill>`.

---

You are reviewing **<screen or flow name>** in **<repo path>** for iPhone Duo. Use only Apple's documentation as ground truth for iPhone Duo behavior and API names. The skill's `references/sources.md` and `references/api-index.md` list those pages.

Inputs:
- Code: <files or folders for this screen>
- Screenshots (optional): <paths; outer 1398×2034 / inner 2007×2853 or landscape equivalents>
- Platform: <SwiftUI | UIKit | mixed>; deployment target <iOS x>; built with Xcode 27.1 or later / iOS 27.1 SDK? <yes/no>

Do this, in order:
1. **Static scan.** Run `<path-to-skill>/scripts/duo-lint <code paths> --format json`. Treat each finding as a lead to confirm by reading the code, not as proof. Note false positives. DUO019 is a destructive action outside the overflow menu. DUO006 is text or controls ignoring the safe area, including under the toolbar.
2. **Read the code** against `references/review-rubric.md` areas 1–7 and `references/fold-aware-layout.md`. For each area, find the evidence the rubric asks for:
   - size-class branching, and one narrow layout plus one wide layout
   - safe-area use, with text and controls clear of the toolbar
   - bar ownership and item setup, with Delete only in the overflow menu
   - reserved-region handling
   - containers and arrangements, including the path order and the fixed pane pairs
   - sheet behavior
   - multitasking
3. **Compare variations.** If you are proposing a layout, put more than one version side by side and say which one you picked.
4. **Plan the device run.** From `references/test-plan.md`, list the cases that apply to this screen (for example A1–A8, B1–B6, C1–C4, D1–D9, E1–E9). For each one, give the exact steps in Device Hub: the Closed, Partially Open and Open buttons, rotation, and Split View by dragging from the home indicator. If you can't run a simulator, mark the case "not run" and say what you would check. Say whether a real iPhone Duo was used. A simulator pass still needs a hardware pass before you call it done.
5. **Visual check (optional).** If you have screenshots, say what to look for in `tools/duo-preview.html` with the fold overlay, the side-control guides and Split View turned on. If you have mockups, open `tools/fold-preview.html`, put them in the two slots, and scrub the fold slider. If you have a screen recording, watch it at full speed, then at quarter speed.
6. **Score** each rubric area 0–3, apply the ship bar, and fill in the rubric's report template.
7. **Fixes.** For each finding, propose the smallest change using the matching template in `templates/swiftui/` or `templates/uikit/`. Name only APIs that appear in `references/api-index.md`. If a fix needs something Apple doesn't document, say "not documented by Apple" instead of inventing an API. Layout practice that isn't an Apple fact comes from `references/fold-aware-layout.md`, and you say so.

Rules:
- Never invent iPhone Duo dimensions, inset values, fold widths, SDK versions or API names.
- Prefer system components and containers over custom geometry.
- Don't propose pose-specific features. Keep the same functionality on both displays. One narrow layout and one wide layout cover closed, open, portrait, landscape, and Split View.
- Follow `references/fold-aware-layout.md` for path order, pane pairs, and the toolbar, and label those points as belweave practice.
- Output the completed report template, then the patch plan (file → change → source URL), then the list of unverified assumptions.
