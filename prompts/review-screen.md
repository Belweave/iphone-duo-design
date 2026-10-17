# Prompt: review a screen for iPhone Duo

Copy this prompt into your coding agent and fill in the `<…>` fields. It assumes the `iphone-duo-design` skill is installed, or that this repository is available at `<path-to-skill>`.

---

You are reviewing **<screen or flow name>** in **<repo path>** for iPhone Duo. Use only Apple's documentation as ground truth for iPhone Duo behavior and API names. The skill's `references/sources.md` and `references/api-index.md` list those pages.

Inputs:
- Code: <files or folders for this screen>
- Screenshots (optional): <paths; outer 1398×2034 / inner 2007×2853 or landscape equivalents>
- Platform: <SwiftUI | UIKit | mixed>; deployment target <iOS x>; built with Xcode 27.1 / iOS 27.1 SDK? <yes/no>

Do this, in order:
1. **Static scan.** Run `<path-to-skill>/scripts/duo-lint <code paths> --format json`. Treat each finding as a lead to confirm by reading the code, not as proof. Note false positives.
2. **Read the code** against `references/review-rubric.md` areas 1–7. For each area, find the evidence the rubric asks for:
   - size-class branching
   - safe-area use
   - bar ownership and item setup
   - reserved-region handling
   - containers and arrangements
   - sheet behavior
   - multitasking
3. **Plan the device run.** From `references/test-plan.md`, list the cases that apply to this screen (for example A1–A8, B1–B4, C1–C4, D1–D7, E1–E6). For each one, give the exact steps in Device Hub: the Closed, Partially Open and Open buttons, rotation, and Split View by dragging from the home indicator. If you can't run a simulator, mark the case "not run" and say what you would check.
4. **Visual check (optional).** If you have screenshots, say what to look for in `tools/duo-preview.html` with the fold overlay, the side-control guides and Split View turned on.
5. **Score** each rubric area 0–3, apply the ship bar, and fill in the rubric's report template.
6. **Fixes.** For each finding, propose the smallest change using the matching template in `templates/swiftui/` or `templates/uikit/`. Name only APIs that appear in `references/api-index.md`. If a fix needs something Apple doesn't document, say "not documented by Apple" instead of inventing an API.

Rules:
- Never invent iPhone Duo dimensions, inset values, fold widths, SDK versions or API names.
- Prefer system components and containers over custom geometry.
- Don't propose pose-specific features. Keep the same functionality on both displays.
- Output the completed report template, then the patch plan (file → change → source URL), then the list of unverified assumptions.
