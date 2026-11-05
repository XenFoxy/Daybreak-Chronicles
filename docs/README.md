# Daybreak Chronicles — Project Documents

Daybreak Chronicles is an original anime-fantasy life RPG: real-life activities earn skill XP, which influences an automatic, side-scrolling fantasy adventure. The player's emerging real-world skill profile informs surprise class awakenings; companions are recruited through exploration and grow alongside the party.

## Start here

1. [Production roadmap](production/roadmap.md) — all phases, milestones 0–18, completion gates, dependencies and delivery order.
2. [Stage 1: Foundation design document](design/stage-1-foundation.md) — requirements, current-repo audit, interface plan, architecture, data rules, Sprint 01 and acceptance tests.
3. [Art bible v1](art/art-bible-v1.md) — original *Celestial Storybook Fantasy* visual direction, design tokens, character and environment standards.
4. [Asset manifest v1](production/asset-manifest.md) — first vertical-slice asset batches, specifications, review and acceptance standards.

## Source-of-truth rules

- The **roadmap** defines delivery order and stage gates; it is not evidence that something is finished.
- The **Stage 1 document** specifies what we need to implement or verify now. It explicitly identifies existing prototype work.
- The **art bible** describes visual rules. Palette, proportions and game art remain provisional until approved in an in-game test.
- The **asset manifest** tracks what is needed. Generated concept art is not automatically a production-ready sprite, texture, icon or animation.
- When code and plans differ, record the discrepancy and decide deliberately. Do not silently overwrite existing work.
- All changes should be reviewed in pull requests with screenshots, reproducible test results and credit/license metadata for any new art.

## Status vocabulary

- **Existing:** present in the repository (not necessarily independently verified on every device).
- **Verify:** inspect/test an existing feature against its stated requirements.
- **Planned:** approved direction, not implemented.
- **Proposed:** subject to gameplay/art review and change.
- **Complete:** acceptance criteria actually passed and recorded.

## Product pillars

1. Real life meaningfully influences fantasy progression, without compulsory daily grinding.
2. The game must be enjoyable on its own, not just an elaborate reminder app.
3. Cute, expressive chibi adventures in a distinct **Daybreak** storybook world.
4. Classes emerge from skill development; companions join through the story, not paid random draws.
5. Kind, sustainable mechanics: no lost real-life XP, punitive missed-day penalties or compulsory streaks.
6. Offline-first and eventually cross-platform, with reliable saves and a testable simulation.

The project does **not** yet commit to being a Kitsune Innovation Labs product. Naming and publishing ownership remain independent decisions.

## Working agreements

Maintain the docs when mechanics change. Keep task tracking in GitHub Issues/Projects; avoid treating a Markdown checklist as a replacement for ticket status. Make smallest playable increment first, then expand content.