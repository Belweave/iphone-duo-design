---
description: "Scored review rubric for an iPhone Duo screen or app. Pairs with the test plan and the designer checklist."
connections: [test-plan, design-review-checklist, api-index]
---

# iPhone Duo review rubric

Use it to grade a screen, a flow or a whole app.
- The **checklist items** live in [`design-review-checklist.md`](design-review-checklist.md), the designer's pre-ship list. This rubric doesn't repeat them. It **scores** them and adds the code-level evidence to look for.
- The **evidence** comes from [`test-plan.md`](test-plan.md) case IDs, `scripts/duo-lint` rule IDs, and screenshots checked in `tools/duo-preview.html`.

## Scoring

Score each area 0–3:

| Score | Meaning |
|---|---|
| 0 | Broken: content hidden, a feature missing in some pose, or a control unreachable |
| 1 | Works but fights the system, for example custom bars, fixed widths, or controls in the fold |
| 2 | Follows Apple's guidance with minor gaps |
| 3 | Exemplary: system components throughout, deliberate fold handling, verified in every pose |

**Ship bar:** no 0 in any area, no 1 in areas 1–3, and a total of at least 18 out of 24.

## Areas

| # | Area | Checklist section | Evidence to require | Blocking failures (score 0) |
|---|---|---|---|---|
| 1 | **Resizing and size classes** | §1 | Test cases A1–A4, B1–B4, C5. No DUO001–DUO004, DUO014, DUO016, or DUO017 lint findings, or each one justified. Layout branches on `horizontalSizeClass` / `verticalSizeClass` or container bounds. Regular width is not gated as iPad | Feature only on one display. Layout keyed to orientation, idiom, `UIScreen.main`, or a hardcoded phone size |
| 2 | **Safe areas and asymmetry** | §1, §2 | Test cases A1, C1–C2, E3. No DUO006 or DUO007 | Controls under the side bar or camera. Insets assumed symmetric |
| 3 | **Vertical controls** | §2 | Test cases D1–D4. Bars come from navigation containers. Every item has a title and a symbol. Groups, visibility priorities and the system overflow menu are used. No DUO005, DUO010, DUO011 or DUO012 | Custom bar that never goes vertical while the system bars do. Actions unreachable when the bar compresses |
| 4 | **Fold and reserved regions** | §3 | Test cases A5–A8, E1–E2. Custom interactive views query `reservedRegions(kind: .division)` (and `.occlusion` where relevant) or use system components. No DUO008 or DUO009 | Tappable control resting in the fold. Large jumps when folding |
| 5 | **Containers and arrangements** | §4 | System split view for list and detail. `ArrangementView` / `UIArrangementViewController` for HStack, VStack or ZStack-style two-pane layouts, with navigation outside. No DUO013 | Arrangement inside a List, ScrollView or NavigationSplitView that hides content |
| 6 | **Sheets and presentations** | §5 | Test cases D5–D7. Any `toolbarVerticalBehavior(.disabled)` / `preferredVerticalBarBehavior` opt-out is stable and justified | A sheet's only action hidden or clipped by the camera |
| 7 | **Multitasking and media** | §5 | Test cases C1–C6, E7. Live Activities have a limited-width layout. New windows are requested only where the inner display can create them | App breaks or loses state in Split View, with pinned PiP, or when iPhone Mirroring is resized |
| 8 | **Assets and verification** | §6 | Test plan section F. Screenshots at Apple's sizes, uploaded so the product page can show the badge. No DUO015 or DUO018. Built with Xcode 27.1 or later and the iOS 27.1 SDK. Every pose tested in Device Hub or on a device | Never run on an iPhone Duo simulator or device. Product page claims Duo support with no Duo screenshots |

Games: score area 4 against test case E4 and HIG "Make your game playable in every device pose" as well.

## Report template

```
Screen: <name>        Reviewer: <agent/human>        Build: Xcode 27.1 or later / iOS 27.1 SDK
Scores: 1 _/3  2 _/3  3 _/3  4 _/3  5 _/3  6 _/3  7 _/3  8 _/3   Total _/24   Ship: yes/no
Blocking: <list or none>
Findings (most severe first):
- [area #] <what> — evidence: <test case / lint rule / screenshot> — fix: <change> — source: <Apple URL>
Unverified assumptions: <anything not backed by an Apple page>
```
