---
description: "App Store product page, screenshots, featuring, and the metadata rules that decide whether an iPhone Duo app is discoverable."
connections: [sources, test-plan, design-review-checklist]
---

# App Store for iPhone Duo

Checked against Apple on 2026-10-25. Quote the pages below rather than paraphrasing a deadline into one rule. Two of them don't say the same thing.

## Optimized for iPhone Duo badge

Uploading iPhone Duo screenshots is what earns the badge. Apple uses the same sentence on three pages:

> When you submit iPhone Duo screenshots in App Store Connect, your App Store product page will display a badge to let people know your app is optimized for iPhone Duo.

Sources: [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications), [Prepare and submit your apps for iPhone Duo](https://developer.apple.com/news/?id=kkphp5qo) (October 5, 2026), and [Three steps to make your app shine on iPhone Duo](https://developer.apple.com/iphone-duo/prepare/).

Screenshots are 1398 × 2034 or 2034 × 1398 px for the outer display, and 2007 × 2853 or 2853 × 2007 px for the inner display. Up to 10 per display, `.jpeg`, `.jpg`, or `.png`, no alpha. Capture them from Device Hub. Preview the product page, including creative assets, with the preview tool in App Store Connect before you submit ([prepare page](https://developer.apple.com/iphone-duo/prepare/), [What's New](https://developer.apple.com/app-store/whats-new/)).

Show the app in use, in more than one pose, so the badge isn't the only signal that the layout actually adapts.

## April 2027 screenshot requirement — two wordings

Apple has not picked one sentence. Keep both.

| Page | What it says |
|---|---|
| [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications) | "Starting in April 2027, screenshots will be required for any app using the iOS 27.1 SDK or later." |
| [Prepare and submit your apps for iPhone Duo](https://developer.apple.com/news/?id=kkphp5qo) | "Starting April 2027, any apps or games submitted will need to include screenshots for iPhone Duo." |
| [App Store Connect release notes](https://developer.apple.com/help/app-store-connect/release-notes/) (October 5 and October 15, 2026) | Same as the news post: "any apps or games submitted." |
| [What's New on the App Store](https://developer.apple.com/app-store/whats-new/) | Same: "any apps or games submitted." |

The specifications page limits the requirement to apps **using the iOS 27.1 SDK or later**. The news, the release notes, and What's New say **any apps or games submitted**. This skill does not collapse those into one rule. Ship Duo screenshots with the build that uses the iOS 27.1 SDK, and treat "any submission" as the stricter reading until Apple aligns the pages.

The iOS 27 SDK upload floor below is a separate deadline. It does not say screenshots are required for every iOS 27 SDK build. Only the specifications page ties screenshots to the 27.1 SDK.

## SDK upload floor (April 2027)

[Submitting](https://developer.apple.com/app-store/submitting/) says that starting April 2027, apps and games uploaded to App Store Connect must meet these minimums:

- iOS and iPadOS apps must be built with the iOS & iPadOS 27 SDK or later, and target iOS 15 or later.
- tvOS, visionOS, and watchOS apps must be built with that platform's 27 SDK or later.

That page also says iPhone Duo submissions are open (the device is available starting October 23, 2026). The minimum for a new upload is the **iOS 27 SDK**, built with Xcode 27. The full Duo layout, with side bars, still needs the **iOS 27.1 SDK** in **Xcode 27.1 or later**. See the SDK tiers in `SKILL.md`.

## Featuring

[Three steps to make your app shine on iPhone Duo](https://developer.apple.com/iphone-duo/prepare/) tells you to submit a featuring nomination and, in Helpful Details, say the app is optimized for iPhone Duo, including support for all device poses.

How to file it: [Nominate your app for featuring](https://developer.apple.com/help/app-store-connect/manage-featuring-nominations/nominate-your-app-for-featuring/). Helpful Details on that page is the free-text field for accessibility, inclusivity, priority, or anything else distinctive. The pose sentence itself lives on the prepare page, not in the nomination field's generic description. Say it there anyway: closed, partially open, and open, in both orientations.

## App Review Guidelines (updated October 16, 2026)

The guidelines page is [Last Updated: October 16, 2026](https://developer.apple.com/app-store/review/guidelines/). Apple's news post the same day, [Updated App Review Guidelines are now available](https://developer.apple.com/news/?id=92th7e5i), calls out two new rules:

- **2.3.14** is a new guideline covering creative assets.
- **2.5.19** clarifies the long-standing ban on hidden, dormant, or undocumented features. That policy used to live in 2.3.1.

Neither new paragraph names iPhone Duo. They still govern the metadata and the binary you submit for a Duo product page.

**2.3.14 (creative assets).** Creative assets highlight the app in ways app-in-use screenshots and preview videos don't, including the product page header and search results. They must pertain to the app's content and functionality or its brand, follow standard metadata guidelines, and be appropriate for all audiences. They should not include inappropriate content, references to other apps meant to mislead, unverifiable product claims, or specific or discounted pricing. Apple points at App Store asset best practices for the rest.

**2.5.19 (the binary).** Don't include hidden, dormant, or undocumented features. Functionality should be clear to end users and to App Review. Hiding undocumented features in the binary, including by obfuscation, is grounds for removal from the App Store and termination of the developer account.

**Screenshots and the rest of 2.3**, which 2.3.14 does not replace:

- **2.3** — metadata, including the description, screenshots, and previews, must accurately reflect the app's core experience and stay current.
- **2.3.3** — screenshots should show the app in use, not only title art, a login page, or a splash screen. Overlays that explain input are allowed.
- **2.3.7** — names, subtitles, screenshots, and previews follow the metadata rules: no prices or terms that don't belong to that metadata type, no misleading references to other apps, no unverifiable claims.
- **2.3.8** — icons, screenshots, and previews stay at a 4+ treatment even when the app is rated higher.

A Duo screenshot that shows a layout the build doesn't actually have, or a creative asset that claims "optimized for iPhone Duo" without the badge's screenshots behind it, fails 2.3 even when 2.3.14 is only about creative assets.

## What to hand the reviewer

In Notes for Review (2.3.1 still requires specific notes for new features), say the build was made with Xcode 27.1 or later and the iOS 27.1 SDK, and list the poses you exercised in Device Hub. Describe only poses the binary supports.
