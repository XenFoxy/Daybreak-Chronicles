# Stage 1 Design Document — Foundation and First Verified Experience

**Project:** Daybreak Chronicles  
**Version:** 0.1 draft  
**Scope:** Phase 1 / Gate 1 (roadmap steps 0–3), including Sprint 01 validation of the existing prototype.  
**Status:** Requirements baseline for review; not proof of successful platform testing.  
**Related:** [Roadmap](../production/roadmap.md) · [Art Bible](../art/art-bible-v1.md) · [Asset Manifest](../production/asset-manifest.md)

## 1. Vision and player promise

Daybreak Chronicles is an **original anime-style life RPG**: the player completes self-chosen, meaningful activities in everyday life; those activities add XP to real-life skills; skill profiles shape their adventurer's growing capabilities and **surprising class awakenings**; the chibi adventurer and encountered companions advance through an idle, side-scrolling fantasy story.

Core emotional promises:
- Opening the app should feel like visiting a delightful, living fantasy world rather than receiving another administrative demand.
- Finishing an everyday activity should visibly and fairly contribute to adventure progress.
- The player's interests should lead to distinctive character development, without punishing varied interests or changing circumstances.
- Companions join through exploration and story; relationships feel warm but never demand check-ins.
- Gameplay remains fun without compelled task grinding, monetised chance or streak penalties.

### Design influences — boundaries

- **RO: Idle Poring:** compact side-scrolling auto-battle loop, incremental stage advancement, pets/party and readable growth.
- **Blue Archive:** lively chibi animation, appealing anime portraits, character interactions and polish.
- **Persona:** intentional daily-life activities, relationships and character growth.
- **Daybreak's identity:** sunrise, whimsical fantasy, original mythology, storybook interface and real-life-derived class awakenings.

Inspiration must remain high-level. No copied lore, names, art, logos, costumes, Schale/Sensei framing, gun-academy setting or near-identical layout/UX. Daybreak must be recognisable without another game's branding.

## 2. Current repository baseline (audit from main branch)

This document builds on **existing work**, not a blank slate. Current repository contents include:

| Location | Existing capability | Next verification / limitation |
| --- | --- | --- |
| lib/progression.dart | Pure Dart Profile, 3 Skill enums (vitality/focus/craft), 3 fixed LifeQuest entries, XP, three discoverable Awakening options, 3 Stage encounters, companion XP, combat tick simulation, bounded idle settlement and JSON v1 | Verify deterministic tests; expand from rigid enums to configurable content later |
| lib/main.dart | Flutter app, app lifecycle, saved state, tick loop and battle integration | Smoke test on macOS and iOS; inspect accessibility and error recovery |
| lib/home_view.dart, lib/chronicle_view.dart | Existing Home/journal/party UI and Flame battle viewport | Review information hierarchy and responsive wireframes; replace provisional styling deliberately |
| lib/trail_scene.dart | Flame animated adventure drawing from placeholder pixel assets | Preserve while developing original art pipeline; inspect different aspect ratios |
| lib/save_store.dart | Local versioned save using shared_preferences | Verify save failure/recovery, migrations, export and future sync plan |
| test/progression_test.dart, test/chronicle_view_test.dart | Existing domain and widget tests | Run them and expand edge-case coverage |
| assets/CREDITS.md | Attribution and CC0 source for Sunny Land pixel-art placeholder pack | Retain credit for bundled source; do not relabel it as original Daybreak art |
| README.md, tool/bootstrap_apple.sh | Prototype usage and Apple platform bootstrap instructions | Verify actual toolchain and platform runner generation on configured Mac |

Existing named content: **The Lantern Trail**, **Lantern Meadow**, **Copperwood**, **Dawnspire**, and **Miri the lantern scout**. An earlier visual concept called *Dawnmeadow Trail* remains a proposal, not an automatic rename.

Existing game mechanics: three fixed life quests award **10 skill XP once per local day per quest**. The corresponding path is discoverable at **20 XP** and is manually selected. The side-scrolling stage logic uses a 5-second battle window and increases attack via skill XP, level, awakening and companion progression. Offline awards require an initial cleared stage, grant both player and companion adventure XP per cleared stage per full minute, and cap each absence at eight hours; they do not advance new stages. These are **prototype tuning values**, not final balance decisions.

**Caveat:** Source inspection confirms the implementation is present; it does not prove builds have been run on this machine or that every interaction works on hardware.

## 3. Users, accessibility and contexts

### Primary scenarios
1. **Quick check-in (phone):** Open, view a friendly adventure, mark a task done in a few taps, see XP feedback, leave.
2. **Reflection (phone):** Inspect a skill's recent progress, next mastery target or emerging affinity when desired.
3. **Planning (desktop):** Create or review projects and quests with roomier layouts and input.
4. **Relaxed game visit:** Watch the auto-party, adjust equipment/party and revisit a story scene.
5. **Return after time away:** Receive bounded idle rewards with no guilt, punishment or busy backlog.

### Principles
- Phone interactions: minimal taps, clear hit targets, safe areas, scalable type, readable labels on illustrated backgrounds.
- No requirement to complete an exact number of tasks or maintain a streak.
- Rest/recovery is a legitimate choice, not a debt to be paid.
- Avoid visual overload, fast flashing and nonessential animation; provide reduced-motion paths.
- Full core functions must not depend on an animated scene being visible.
- Buttons and progress should use accessible Flutter semantics, not images containing text.

## 4. Core user flows (Stage 1)

### A. Open and resume
Launch -> load/validate local Profile -> settle elapsed offline rewards at most once -> show battle stage and a compact reward summary -> continue auto-battle in foreground. If load fails, provide a clear recovery path without silently deleting the save.

### B. Complete a life quest
View Quests or Home's optional next quest -> confirm completion -> create a unique completion event -> update associated skill XP exactly once -> persist -> show concise XP toast/skill bar advance -> resulting character bonuses appear on next encounter resolution. Provide undo/correction in future iteration; do not silently revoke genuine XP on mere navigation.

### C. Skill discovery
Open Skills -> view actual skills and experience -> optionally inspect emerging affinities -> reach skill-profile threshold -> show class-awakening event when appropriate. **Target design:** class becomes a surprising but explainable reflection of multiple skill investments; alternative paths stay viable. **Prototype:** current single-skill thresholds and player selection are acceptable temporary mechanics.

### D. Side-scrolling adventure
Auto-battle -> encounters/retry -> gain adventure XP/loot -> clear stage or pause at a challenge -> optionally adjust strategy -> recruit first companion through story. Losing a battle never penalises recorded real-life XP.

### E. Cross-device future
The same logical player profile should ultimately appear across devices, but Stage 1 is local-only. Do not imply cloud accounts or two-way sync are implemented.

## 5. Information architecture and screen design

| Screen | Primary job | Must show | Avoid |
| --- | --- | --- | --- |
| Home | Feel immersed + know immediate next step | Adventurer, current stage/auto-battle, compact daily progress, one meaningful skill hint | Full task list, full skill list, large party strip, multiple competing event banners |
| Quests | Manage real-life commitments | Today/Upcoming, complete/add/edit, recurrence and project grouping (future), clear reward mapping | Game combat clutter |
| Skills | Understand growth and awakenings | Skill XP, levels, history, masteries, emerging affinities/hints | Equating XP with proven competence |
| Party | Connect with characters | Hero, recruited companions, level, role, relationship, equipment (expand later) | Gacha acquisition prompts |
| Adventure | Focus on fantasy progression | Full-screen stage, enemy/boss, loot, pause/auto, battle options | Mandatory real-life task input during combat |
| Chronicle | Remember and reflect | Quest and chapter journal, discoveries, class/companion story records | Dense analytics by default |

**Mobile navigation:** recommended persistent Home / Quests / Skills / Party / Chronicle. Full Adventure opens from the Home battlefield. Base and equipment live within contextual navigation initially.

**Desktop:** constrain text/task column width; use more horizontal space for the animated game and optionally a companion details pane. Layout must adapt, not merely stretch a phone mockup.

**Home hierarchy:** (1) compact identity and level, (2) large visual battle viewport, (3) small daily/skill status, (4) clear navigation. Character art should stay the hero; controls must have sufficient contrast.

## 6. Visual design contract

Use [Art Bible v1](../art/art-bible-v1.md). Proposed colour tokens:
- Dawn Gold #F1BE7C, Dawn Rose #E8A4B8, Twilight Lavender #A99BDA,
- Celestial Blue #768DBB, Mist Teal #8BBFB2, Warm Ivory #FFF1D9,
- plus deep ink/navy for legible text.

A detailed anime portrait and a chibi gameplay sprite are **separate assets** for each character. Use layered parallax scenery and separate Flame entities. Render task text, progress bars, buttons and notifications as actual Flutter widgets. A concept mockup is a composition reference, not a shippable screen texture.

Style decisions still requiring visual signoff: portrait-to-sprite mapping, character proportions, equipment layering, outline weight, font families, border ornament density, day/night treatment and minimum text contrast.

## 7. Technical architecture (target direction)

**Application:** Flutter/Dart, platform-adaptive navigation, accessibility, forms and UI.  
**Scene:** Flame 2D renderer, sprite animation, parallax, particles and interactions.  
**Rules:** pure Dart deterministic progression/simulation, independent of frame rate.  
**Persistence:** local versioned snapshot + future event log, migrations and export.  
**Sync:** future server-side or account-based service; not part of the first release gate.

Proposed modular boundaries:
- domain/progression: skills, levels, classes, activities, rewards, mastery, party, stage simulation.
- application/state: commands such as CompleteActivity, SettleIdle, RecruitCompanion, EquipClass; validation and orchestration.
- features/quests, skills, adventure, party, chronicle: Flutter presentation.
- rendering/flame: scenes, animation components, parallax and effects reading approved game state.
- infrastructure/save: local persistence and migrations, future synchronisation adapter.

**Do not refactor current source solely to match folder naming** until we have validated the baseline and an incremental migration plan.

### Data model growth path

| Entity | Prototype | Target extension |
| --- | --- | --- |
| PlayerProfile | player XP, cleared, checkpoint, awakening | profile ID, settings, created/updated times, explicit schema version |
| Activity/Quest | fixed enum + daily log | stable ID, category, recurrence, timezone, status, skill weights, event timestamp |
| Skill | enum + integer XP | configurable stable ID, XP curve, level, specialties, provenance |
| Mastery | absent | verifiable milestone, evidence/portfolio link, criteria, independent rank |
| Affinity/Awakening | single-skill enum threshold, manual equip | weighted profile, multiple-class hints, reveal, branching, accessible alternatives |
| AdventureStage | 3 fixed encounters | data-driven stage ID, enemies, difficulty, rewards, boss/story flags |
| Companion | Miri unlocked after first clear | roster ID, recruitment story, XP, class, bond, active/bench state |
| Inventory | absent | item IDs, rarity, ownership, equipment slots, modifiers |
| ActivityEvent | limited last-day map | immutable unique event IDs, adjustments, idempotency across devices |
| Save | version 1 JSON | migration, backup/export, crash safety and eventual sync reconciliation |

Keep life XP, adventure XP, skill proficiency/mastery and relationship/bond advancement separate. Never derive mastery solely from logged time.

## 8. Test strategy

### Domain tests
- Same quest cannot grant twice in the same local day; future-day completion works.
- Dates, timezone transitions, daylight saving, backwards clock and long absence behaviour are explicit and tested.
- Skill XP increase deterministically adjusts attack or other promised ability; quest completion never modifies previously resolved damage.
- Class requirement combinations, branch choices and hints are deterministic; unfair dead ends are avoided.
- Companion joins at the intended story event; both protagonist and companion receive appropriate future rewards.
- Failed stages retry consistently and do not touch life XP.
- Offline payout caps, partial-minute carry, no double settlement, no new-stage clearing and serialization round-trips.
- Invalid or unknown save versions fail safely with recovery guidance rather than overwriting.

### UI/device checks
- Phone portrait, tablet, desktop wide and minimum small-phone width.
- Dynamic text sizes, contrast, focus and screen reader labelling.
- Complete a task, observe XP and restart with progress intact.
- Battlefield art does not obscure tap targets or overwhelm critical information.
- Low/reduced-motion mode, battery usage and lifecycle pause/resume.
- Flutter analyze and Flutter test on supported toolchain; record exact device and results.

### Test evidence
Attach PR summary with test command results, screenshots for phone and desktop, and any known limitation. Do not claim platform verification without actual device/simulator run.

## 9. Sprint 01 implementation/review backlog

1. **Inventory current state** (existing): review files, dependencies, asset credit, baseline tests and run instructions.
2. **Save the production documents** (this PR): docs index, roadmap, foundation design, art bible starter and manifest; root README link.
3. **Verify the prototype**: run Flutter analyze/test and macOS application; iOS simulator/configuration if available.
4. **Visual approval**: choose one definitive look through a Daybreak Home reference and a reference hero, then lock art parameters for one area.
5. **Wireframe six screens**: start with Home, Quests and Skills; define desktop adaptations.
6. **Write progression contracts**: document how configurable quests/skills replace hard-coded enums without breaking v1 saves.
7. **Create targeted issues** for improvements discovered in the audit, especially error recovery and eventual event log.
8. **Demonstrate the loop**: real task -> correct XP -> battle benefit -> stage progression -> persistent save. Record evidence.

## 10. Definition of done for Stage 1

- [ ] Baseline repo architecture and feature inventory reviewed.
- [ ] Documentation present and linked from root README.
- [ ] Current tests and static analysis executed with results recorded.
- [ ] macOS build/run checked on a configured Mac; iOS path verified or explicitly marked pending.
- [ ] Six screen wireframes approved or tracked as outstanding.
- [ ] Original art direction and hero/scene reference approved or tracked as outstanding.
- [ ] Quest and skill data-model direction agreed; existing save compatibility documented.
- [ ] Task -> XP -> adventure progression -> save flow tested end to end.
- [ ] Unresolved risks recorded in GitHub Issues rather than hidden under a generic 'complete' label.

The **docs portion** can be merged independently. Stage 1 as a whole remains open until the other acceptance criteria have evidence.

## 11. Risks and open decisions

1. **Visual consistency:** generative sprite sheets can vary between frames. Use approved turnarounds, manual cleanup and per-frame inspection.
2. **Art pipeline:** current CC0 SunnyLand pixel art is a licensed prototype baseline; final visual target is original hand-painted fantasy/chibi, potentially requiring replacement of multiple sprite/environment assets.
3. **Scope creep:** enormous class trees, open world, home-building and multiplayer are excluded from the first vertical slice.
4. **Class agency:** surprise should be delightful rather than coercive; design multiple viable paths, hints and respecialisation.
5. **UX friction:** measure task entry/completion speed and app maintenance burden. No extensive daily admin loop.
6. **Save integrity:** shared_preferences is adequate for initial local prototype, but robust evolving data will require migration and possibly a stronger storage/event mechanism.
7. **Sync conflicts:** device clock alone cannot secure multi-device rewards; event IDs and reconciliation need planned server/account semantics.
8. **Naming:** *The Lantern Trail*, *Lantern Meadow* and *Dawnmeadow Trail* must be deliberately reconciled, not silently renamed.
9. **Project ownership:** public product, private hobby project, or KIL publication is undecided.

## 12. Handoff to Stage 2

After these foundations are reviewed, build/extend a playable vertical slice with working tasks and stage combat using placeholders. Only after mechanics and on-screen scale are verified should the team create final hero animation sheets and fully layered scenery. The production roadmap controls subsequent gate entry.
