# iphone-duo-design

An agent skill for designing iOS apps that work well on iPhone Duo, across the small outer display and the large inner one. It covers size classes, freely resizable layouts, moving controls to the side when vertical space is tight, keeping interactive elements clear of the fold, and Split View.

It's based on Apple's Design for iPhone Duo guidance and the Human Interface Guidelines.

## Install

Copy the `iphone-duo-design` folder into your agent's skills directory. For Claude Code, that's:

```sh
git clone https://github.com/belweave/iphone-duo-design.git
cp -r iphone-duo-design ~/.claude/skills/iphone-duo-design
```

Other agents that read `SKILL.md` folders work the same way. Only the path is different.

## Layout

```
SKILL.md                 the skill: principles, checklist, layout guidance
references/
  hig-summary.md         condensed HIG notes for iPhone Duo
  patterns.md            layout patterns and examples
evals/
  evals.json             test prompts with expected behavior
  triggers.json          prompts that should and shouldn't trigger the skill
CHANGELOG.md
```

## License

MIT
