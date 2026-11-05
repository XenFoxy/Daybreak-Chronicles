# Daybreak Chronicles — Vertical Slice Asset Manifest v1

**Status:** Planning inventory. Entries are not automatically complete or already generated.  
**Scope:** One polished playable region with one hero, one recruitable companion, two regular monster species, one boss and functional task/skill/party UI.  
**See also:** [Roadmap](roadmap.md) · [Art Bible](../art/art-bible-v1.md) · [Stage 1 Design](../design/stage-1-foundation.md).

## Status legend and quality gate

Use **proposed -> specified -> concept approved -> production -> integrated -> accepted**. A model-generated preview counts at most as *concept approved* until it passes transparency, loop/pivot, scale and gameplay checks.

Each finished file needs: stable ID, human-readable purpose, source/master, runtime export, sizes/frames, anchor or nine-slice metadata where applicable, provenance/license, reviewer and screenshot from the running game.

## Batch A — Brand, UI and system icons

| ID | Asset group | Initial target | Technical notes |
| --- | --- | --- | --- |
| BRAND-01 | App icon + wordmark | 2 deliverables | Source + iOS/macOS scale variants, legible tiny icon |
| UI-01 | Flexible panels | 4–6 families | Nine-slice frames, dark/light contexts, corner/edge metadata |
| UI-02 | Buttons and tab states | 1 component family | Default/selected/pressed/disabled/focus; prefer vector/runtime-generated elements |
| UI-03 | Navigation, quest, skill, party icons | 15–25 | Consistent optical size and stroke, export vector where possible |
| UI-04 | HP/XP/affinity bars | 3–4 | Dynamic fill + scale, not baked text |
| UI-05 | Reward/level/achievement FX | 6–10 | Short animations or particles; reduced-motion alternative |
| UI-06 | Empty/loading/error states | 3–5 | Illustrations with readable supporting UI copy |

Do not embed task text, XP values or button labels in generated imagery.

## Batch B — Original hero

| ID | Deliverable | Initial target | Acceptance |
| --- | --- | --- | --- |
| HERO-01 | Full character design reference | front/side/back + expressions | Proportions, costume, colours and silhouette approved |
| HERO-02 | High-detail portrait | 1 key art + variants later | Faithfully matches HERO-01 |
| HERO-03 | Idle animation | initial 4–8 frames | Loop, steady pivot and clean alpha |
| HERO-04 | Run animation | initial 6–8 frames | Loop, consistent feet/weapon/ears/tail |
| HERO-05 | Attack animation | initial 4–8 frames | Clear telegraph/impact |
| HERO-06 | Cast animation | initial 4–8 frames | Spell staging and silhouette |
| HERO-07 | Hurt animation | initial 2–4 frames | Readable without excessive flashing |
| HERO-08 | Victory animation | initial 4–8 frames | Short, expressive and replayable |

Do not commit to thousands of equipment permutations until layered outfits/rigging are evaluated.

## Batch C — First companion and encounters

| ID | Deliverable | Initial target | Acceptance |
| --- | --- | --- | --- |
| COMP-01 | Miri reference + portrait | 2 main illustrations | Matches story/personality and hero proportion guide |
| COMP-02 | Miri core states | idle/run/attack/hurt (4 states) | Distinct silhouette, stable anchors |
| ENEMY-01 | Small enemy type A | reference + idle/attack/hurt/defeat | Recognisable, readable at mobile scale |
| ENEMY-02 | Small enemy type B | reference + idle/attack/hurt/defeat | Distinct threat/readability |
| BOSS-01 | First guardian boss | reference + idle/telegraph/attack/hurt/defeat | Telegraph must be readable and not visually overwhelming |
| FX-01 | Combat impacts | 4–8 effects | Lightweight and composable |
| FX-02 | Healing/reward/class aura | 3–5 effects | Visible and accessible |

Use original monster species and names. Avoid recognisable franchise monster copies.

## Batch D — Environment and story

| ID | Deliverable | Target | Acceptance |
| --- | --- | --- | --- |
| ENV-01 | Coordinated first-region master | 1 concept | Approved horizon, perspective and palette |
| ENV-02 | Parallax layer set | ~5–6 layers | Seamless loops, consistent lighting and scale |
| ENV-03 | Stage props | ~8–12 | Reusable and correctly depth-sorted |
| ENV-04 | Ground/terrain pieces | tile/segment kit | No obvious joins at varied device widths |
| STORY-01 | Recruitment scene art | 2–3 images or dynamic compositions | Fits character masters and dialogue |
| STORY-02 | Scene transition/loading | 2–3 | No need for large unique art per load |
| ENV-05 | Lighting/daytime variants | optional later | Do not delay first slice for all time-of-day states |

Working code currently uses Lantern Meadow/Copperwood/Dawnspire and the CC0 Sunny Land pack. Coordinate any rename or visual replacement with Stage 1 decisions.

## Batch E — Audio and data-driven content

| ID | Deliverable | Target | Acceptance |
| --- | --- | --- | --- |
| AUD-01 | Exploration theme | 1 loop | Original/licensed, loop seam tested |
| AUD-02 | Battle/boss cue | 1 loop | Does not dominate task UI |
| AUD-03 | UI, combat and reward SFX | ~10–15 groups | Mute/volume policy and file-size budget |
| DATA-01 | First area encounters | 2 enemies + boss | Deterministic rules/tests |
| DATA-02 | Early activities/skills | initial 5-skill plan (prototype currently 3) | Accessible mapping and non-exploitative XP |
| DATA-03 | Initial class paths | 3–4 | Surprising but explainable, all viable |
| DATA-04 | Companion recruitment story | 1 short arc | Discoverable without paid randomness or daily deadline |

## Integration and naming practices

Keep one authoritative sprite/frame atlas per animation only after reference approval. Provide frame dimensions, frame count, FPS, pivot/origin, scale in logical world units and an in-app screenshot. Nine-slice components need minimum size and corner inset values. Environments need layer parallax multipliers, full scene bounds and seamless-loop verification.

All source/master files should be retained through a declared workflow. If generated PNGs are too big for the main repository, define a Git LFS or external asset-storage policy before adding them.

## Production order

1. UI typography/scale and one Hero master.
2. One environment master and game viewport framing.
3. Hero run/attack/idle -> one enemy -> playable art proof.
4. Remaining hero states, second enemy, boss.
5. Companion design/animation and recruitment scene.
6. UI kit refinement and skill/class effects.
7. Audio, optimisation and visual QA.

Do not mass-generate companion outfits, region variants or bosses before this first playable art pipeline is proven.

## Open art decisions

- Canonical first-region name: Lantern Meadow/Trail (existing) versus Dawnmeadow Trail (concept).
- Chibi height ratio, outline weight and initial runtime resolution.
- Hero species/identity customisation: which appearance options are essential for alpha.
- Equipment layering versus baked character variations.
- Preferred asset masters: layered raster, SVG, skeletal rigging or clean frame sheets.
- How to version and store generative source files/prompts and asset license metadata.

The definitive checklist belongs in issues/asset tracking when production begins; this file is the baseline manifest, not a substitute for per-asset review.