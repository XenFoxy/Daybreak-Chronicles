# Daybreak Chronicles — Complete Production Roadmap

**Status:** Planning baseline (2026-11). **Product:** original anime-fantasy life RPG built primarily in Flutter + Flame. **Initial targets:** iPhone and macOS, with platform-neutral gameplay logic so Android, Windows, Linux and web can follow.

> This document is the **full end-to-end roadmap**, not a claim that every milestone is unstarted. The repository already contains a small, functioning-shaped prototype called *The Lantern Trail* with three life quests, three skills, three encounters, one recruitable companion, class discovery, local save logic, tests and a Flame scene. Its runtime/build status still needs verification.

## North-star experience

The player records a meaningful real-life activity -> earns skill XP -> develops a unique affinity profile -> their fantasy character gains powers/class awakenings -> their idle party overcomes tougher side-scrolling stages -> returns to more of the world's stories, companions and discoveries. Keep conventional RPG XP, equipment and strategy valuable too, so no particular real-life activity is compulsory.

## Non-negotiables

- No loss of earned life XP for missed days; avoid manipulative streaks, scarcity pressure or guilt-inducing companions.
- XP reflects participation; **mastery** must be demonstrated separately rather than inferred from repeated easy check-ins.
- Surprise awakenings should be legible in hindsight, reversible/branchable, and not lock the player into a class forever.
- Real-life activities provide meaningful advantages, but the fantasy game has alternative paths and remains intrinsically fun.
- Offline progression must be bounded, save-safe and deterministic; it must not depend on continuous iOS background execution.
- Use original character designs, world art, UI and terminology. Treat Blue Archive and RO: Idle Poring as high-level inspirations only. No copied logos, characters, settings, halos, scene layouts or protected assets.
- Every asset requires a specification, ownership/license notes, test in the actual game, and source/master export where possible.

## Gate 1 — Foundation (Phase 1, steps 0–3)

### 0. Repository audit and technical foundation — **Existing; verify**

- Review current Flutter + Flame scaffold, branch hygiene, package versions, assets, tests and existing documentation.
- Verify Flutter analyse/test results and Mac run; validate iOS runner generation/signing path and supported Flutter/Xcode.
- Inspect the current prototype without breaking its existing three-stage campaign.
- Define a modular target layout: shared progression model; quest, skills, adventure, characters, companions and Chronicle features; app shell; persistence; test fixtures.
- Create docs index, roadmap, design doc, art bible and manifest, then GitHub Issues for unfinished tasks.

**Exit:** current features are inventoried; baseline verification recorded; project can be built/tested on a configured Mac; no hidden unreviewed migrations.

### 1. Daybreak visual design bible — **Planned, starter document created**

- Set the original *Celestial Storybook Fantasy* direction: sunrise gold, rose, twilight lavender, mist teal and deep celestial blue.
- Establish chibi proportions, portrait treatment, UI ornament density, background layering, visual effects, accessibility contrast, responsive design, naming and safe-area rules.
- Produce approved reference sheets rather than using composite screen mockups as game assets.
- Document provenance, license, and clean export conventions.

**Exit:** one approved art bible with in-game readability sample and character/world/UI references.

### 2. UX architecture and six wireframes — **Planned**

- Define responsive layouts for Home, Quests, Skills, Party, Adventure and Chronicle.
- Home prioritises a substantial animated game scene plus a compact daily progress summary. Full task/skill lists belong on their own screens.
- Entry to full Adventure from the Home scene; primary nav target ~5 destinations (Home, Quests, Skills, Party, Chronicle) with Base/Equipment in subordinate screens.
- Define empty, loading, completed, offline, error, small-phone, tablet and desktop states.
- Use design tokens and real Flutter text/controls, not baked-in UI screenshots.

**Exit:** six mobile wireframes plus desktop adaptation rules, reviewed before mass asset generation.

### 3. Canonical rules and data contract — **Partially existing; extend**

- Document real-life task, habit, project, skill, XP, level, mastery evidence, emerging affinity, awakening, party, encounter, checkpoint, inventory and event-history concepts.
- Distinguish earned life XP from adventure XP and companion/relationship progression.
- Specify idempotent activity completions, correction/undo and save schema version migrations.
- Define battle/offline simulation with stable deterministic tests, capped rewards and explicit progression rules.
- Keep specific XP numbers and class thresholds configurable rather than hard-coded into content.

**Exit:** domain schema and acceptance cases documented; existing pure-Dart rules remain passing; new rules have unit tests.

## Gate 2 — First playable (Phase 2, steps 4–6)

### 4. Real-life quest engine — **Prototype exists; extend**

Implement flexible task creation/editing, one-off/recurring schedules, optional habits/projects, completion tracking, skill XP, history, undo, day-boundary/timezone behaviour and persistence. Existing prototype only has three fixed quests with once-per-local-day awards; do not describe it as full task management.

**Exit:** user can add and complete an activity; skill XP updates once for a unique completion and survives restart.

### 5. Auto-battle vertical-slice engine — **Prototype exists; verify/extend**

Use a side-scrolling Flame scene with autonomous movement, attack/defence, two basic enemies, one boss, stage retry, simple loot and adventure XP. The existing three-stage Lantern Trail and the licensed SunnyLand placeholder pack are our baseline. Introduce original art later.

**Exit:** a character can clear stages, fail/retry a boss, recruit the first companion and preserve combat state after restart.

### 6. Connect skill XP to stage advancement — **Prototype exists; deepen**

Demonstrate a real task completion increasing party capability so a previously failing encounter can be cleared. Keep genuine RPG gearing, tactics and companion options relevant. Make the result understandable through nonintrusive feedback.

**Exit:** repeatable integration test and a playable recorded demonstration of task -> XP -> stronger party -> further stage.

**Gate 2 deliverable:** functional prototype with temporary art and validated saves; mechanics before content volume.

## Gate 3 — Visual vertical slice (Phase 3, steps 7–10)

### 7. Original hero art and animation — **Planned**

Generate and approve a front/side/back reference sheet, original character portrait, gameplay sprite and animation states (idle, run, attack, cast, hurt, victory). Clean silhouette, frame alignment, transparent exports, pivot metadata and consistent equipment. Start with one reference hero; customisable appearance is later.

**Exit:** all approved states animate in Flame at target resolutions without flicker, stretching or visual drift.

### 8. First original environment — **Planned**

Produce a coordinated, layered sunrise fantasy landscape. Initial art concept is *Dawnmeadow Trail*; current code uses *Lantern Meadow / Copperwood / Dawnspire* and *The Lantern Trail*. Retain current canonical names until a deliberate naming decision. Export sky, distant hills, architecture, midground, terrain and foreground layers; ensure seamless parallax seams and readable combat.

**Exit:** scrolling environment looks coherent on phone/desktop and loops cleanly.

### 9. Enemies, boss and first companion — **Planned**

Create two enemy species, first boss and companion with reference sheets, sprites, attack/hurt/defeat or celebration states, portraits as appropriate, and data-driven encounters. First companion in code is **Miri the lantern scout**; preserve or consciously redesign.

**Exit:** hero and companion fight two enemy types and a boss with original art and readable effects.

### 10. Daybreak UI component kit — **Planned**

Produce flexible nine-slice panel frames, buttons and states, progress bars, skill/quest icons, reward toasts, party portrait frames, tabs, modal treatments, and in-app typography/contrast tests. All functional labels remain dynamic Flutter text.

**Exit:** Home, Quests and Skills assembled from reusable components, not single flattened illustrations.

**Gate 3 deliverable:** one gorgeous functional area, with real-life progression, companion and polished original art.

## Gate 4 — Feature-complete alpha (Phase 4, steps 11–14)

### 11. Class awakening system — **Prototype discovery exists; evolve**

Use real skill profiles to produce understandable but partially surprising class affinities and reveal events. Begin with 3–4 classes. Include branching/hybrid discoveries, optional hints, visually distinct class assets and reversible choices without forcing a player to change their real life for a specific class. Separate XP participation from mastery proofs.

**Exit:** class-awakening journeys tested, balanced and clearly connected to input skills.

### 12. Companion and party system — **One prototype companion exists; extend**

Meet companions through optional story and exploration, not gacha. Add party slots, bench XP/training options, class growth, bond scenes, support skills and combination attacks. Companions should not demand daily care to avoid guilt loops.

**Exit:** swap companions, level them, encounter story events and keep saves stable.

### 13. Adventure content systems — **Planned**

Add data-driven stages, enemies and scaling; loot and equipment; crafting; area unlocks; map, narrative events and side quests. Avoid content explosion until content-authoring pipeline is efficient.

**Exit:** complete a replayable mini-chapter with at least one meaningful build/strategy choice.

### 14. Home base and world interactions — **Planned**

Add a cosy home/base with furniture and companions doing simple routines; optional dialogue and world ambience. Keep it secondary to the core life-RPG loop; avoid turning it into a chore.

**Exit:** accessible base scene and optional customisation, without blocking main progression.

## Gate 5 — Release quality (Phase 5, steps 15–18)

### 15. Audio and atmosphere — **Planned**
Original/cleared music, ambience, UI sounds and combat SFX; mix, audio settings, mute/accessibility and small download footprint.

### 16. Offline progression — **Basic implementation exists; verify/extend**
Simulate elapsed time on resume; cap/validate payout, protect from clock reversal, avoid double payouts, distinguish repeat farming from new-stage clearing; present understandable adventure reports.

### 17. Persistence, export and synchronisation — **Local v1 exists; extend**
Versioned saves and migrations, graceful corrupted-save recovery, manual export/backup, account model, multi-device sync conflict handling and idempotent task/event rewards. Do not promise sync until implemented.

### 18. QA, accessibility and platform release — **Planned**
Tests for life-quest logic, date/time edge cases, class evolution, idle simulation, UI, mobile/desktop sizing; battery/thermal profiling, text scaling, colour contrast, reduced motion, screen-reader labels; signed iOS/macOS builds first, additional platform packaging later. Check artwork provenance, attribution and store policies.

**Gate 5 deliverable:** accessible, stable build with clear known limitations and release notes.

## First vertical-slice scope (v0.1 visual target)

- One polished region and clear stage/boss encounter
- One original chibi hero, one story-recruited companion
- Two normal enemy types and one boss
- Five proposed broad real-life skill categories; migrate deliberately from prototype's three fixed categories
- Basic quest entry/completion and XP progress; first class reveal
- Local persistence and bounded offline expedition rewards
- Original Daybreak UI with restrained home-screen information density

Out of scope for first vertical slice: huge class roster, gacha, online multiplayer, guilds, full story campaign, elaborate housing, live service events, mandatory daily check-ins and cross-device cloud sync.

## Dependency sequence

Rules and project audit -> wireframes/design bible -> functional vertical slice -> first original hero & environment -> first polished stage -> deeper class/party features -> wider content -> sync/release. Do not mass-generate art ahead of approved character proportions, stage camera framing or UX layouts.

## Delivery and review

Every step needs: owner/issue, spec, expected artefact, review screenshots, source and attribution records, reproducible tests (or explicit testing gap), and link to a PR. Use statuses *existing*, *verify*, *planned*, *in progress*, *complete*; do not equate GitHub file presence with a passing device build.

## Immediate Sprint 01

1. Audit repository, document existing feature inventory and test baseline.
2. Create these planning docs and reference them from root README.
3. Review/approve art bible v1 and six screen wireframes.
4. Decide canonical names for first region and character.
5. Confirm architecture boundary between progression rules, game rendering, Flutter views and save store.
6. Verify existing quest -> XP -> class discovery -> battle -> save flow with tests and a macOS/iOS smoke run.
7. Create follow-up Issues for gaps rather than rewriting working prototype code.

**Sprint 01 done when:** current code passes the agreed checks on a configured environment, documentation is linked and reviewed, and unresolved technical/art decisions are recorded. If platform verification is unavailable, record it as open rather than declaring a pass.

See [Stage 1 design](../design/stage-1-foundation.md), [art bible](../art/art-bible-v1.md) and [asset manifest](asset-manifest.md).