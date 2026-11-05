# Daybreak Chronicles — Art Bible v1

**Status:** Living specification / provisional until approved in an actual Flutter + Flame screen.  
**Visual thesis:** *Celestial Storybook Fantasy* — dawn-lit magical landscapes, endearing expressive chibi adventurers, painterly fantasy environments, and restrained jewel-like UI ornamentation.

## 1. Originality and mood

Daybreak should feel warm, adventurous, magical, gentle and optimistic. The identity is **an adventurer's living chronicle**, not a futuristic academy command centre. It takes broad inspiration from Japanese anime/JRPG polish without reproducing another game's UI, character uniforms, settings, weapon motifs or trademarked visual symbols.

**Lean into:** dawn light, floating pollen, glowing runes, layered valleys, enchanted woods, village craft, hand-drawn flourishes, creature expressions, skies changing through the day.  
**Avoid:** tactical academy gun combat, distinctive Blue Archive halos/Schale labels/Sensei text, near-identical resource HUDs, copied characters, crowded event dashboards, recycled Ragnarok monsters or pixel-perfect interface clones.

This is an original universe. Foxes may appear as optional player choices/creatures, but **the whole product is not fox-only**. Player characters should support varied species, appearances and identity expression in later builds.

## 2. Palette (proposed design tokens)

| Token | Hex | Usage |
| --- | --- | --- |
| Dawn gold | #F1BE7C | Highlights, earned rewards, sunrise edges |
| Dawn rose | #E8A4B8 | Friendly accents, blossoms and soft UI feedback |
| Twilight lavender | #A99BDA | Class affinity and magical accents |
| Celestial blue | #768DBB | Secondary actions and sky-associated UI |
| Mist teal | #8BBFB2 | Calm/support/wellbeing accents |
| Warm ivory | #FFF1D9 | Warm UI surfaces and gentle highlights |
| Deep ink | #273047 | Primary readable text on light backgrounds (provisional) |
| Night indigo | #222B49 | High-contrast dark panel surface (provisional) |

Gameplay background art may contain richer local palettes; the UI tokens must remain recognisable. Ensure normal-sized text contrast meets WCAG AA targets where practicable (4.5:1 normal text, 3:1 large text); avoid placing thin gold text on pale illustrated scenery.

## 3. Art directions

### Player and companions
- Anime chibi proportion starting target: ~2.5–3 heads tall, readable at small sprite scale; refine with an in-game preview.
- Strong silhouette: class and role readable without small decorative details.
- Expressive motion: anticipation, squash/stretch, clean attack timing, victory and personality animations.
- Canonical character master must define shape language, front/side/back, colours, accessory placements and expression sheet before animation production.
- Detailed 2D anime portrait and chibi sprite are separate deliverables representing the same character.
- Keep clothing, equipment and accessories consistent between frames. Decide layered versus baked equipment before making variants.
- Build original personalities and attire; never trace another franchise's named cast.

### Monsters
- Charming but legible; separate silhouettes for weak enemy, special enemy and boss.
- Use a small family of consistent shapes, expressions and colour values per area.
- Avoid recreating recognisable Poring designs or other protected monster characters. “Dew Slime” is merely a generic provisional concept, not a copy.

### Environments
- Painterly 2D side-scrolling layers: sky/atmosphere, distant landmark, midground village/forest, walkable ground, near-ground foliage/FX.
- Sunlight/dawn establishes Daybreak's distinctive look; use different seasons/times of day as later variations.
- Maintain uniform perspective, horizon and scale across layers; scrolling seam test required.
- Silhouette and contrast must keep enemies, companions, health indicators and damage numbers clear.

### UI
- Storybook panels: warm ivory/translucent mist, restrained gold filigree, occasional celestial motifs.
- For gameplay use large unobstructed visual space; no permanent wall of panels.
- Design nine-slice/scalable frames with distinct hover/pressed/disabled/focus states.
- Text, counters, progress bars and active buttons always drawn by Flutter, not baked into a generated full-screen raster.
- Decorative imagery is never the sole means of communicating task status.

### Icons/typography
- Consistent icon stroke/fill style; skill and navigation symbols should read at 24px logical size.
- Highly legible body font with proper Unicode/diacritics support; more ornate headings only when legibility allows.
- Establish minimum tap target sizes and text-scale support before finalising UI frame thickness.

## 4. Asset production protocol

Each asset enters the pipeline:

1. **Specification:** asset ID, role, target size/scale, required views/frames, palette, reference link, transparent/background requirements.
2. **Concept:** produce candidate concepts; review originality and silhouette.
3. **Character/environment lock:** approve master sheet and perspective before derivatives.
4. **Production:** create frames/layers; clean alpha, correct anatomy, align pivots, enforce consistent illumination and dimensions.
5. **Export:** preserve original master; deliver optimised PNG/WebP/other supported runtime format plus frame/anchor metadata.
6. **Integration:** load in Flutter/Flame at actual phone and desktop scale; review seams, readability, FPS and memory.
7. **Acceptance:** mark complete only after reviewer agrees and in-game test passed. Store credit/provenance/terms in asset record.

### Example naming
- assets/characters/hero_01/hero_01_reference_master.*
- assets/characters/hero_01/hero_01_run_sheet.png
- assets/characters/hero_01/hero_01_run.json
- assets/environments/lantern_meadow/bg_sky.png
- assets/ui/panels/panel_quest_9slice.png

Source/master files may live under a separate source-art directory or LFS when warranted; runtime builds should not ship unnecessarily large masters.

## 5. Initial animation contract

Start with hero: idle, run, attack, cast, hurt, victory; first companion: idle, run, attack, hurt; enemy: idle, attack, hurt, defeated; boss with a telegraphed attack. Typical initial target 4–8 frames per action, adjusted to animation quality.

A successful animation must pass:
- character's feet/pivot not sliding or jumping unexpectedly;
- pose size, costume, ears, tails and weapons remain consistent;
- sprite frames have expected transparent backgrounds and stable bounding boxes;
- hit frames and damage feedback are clear and accessibility-friendly;
- idle and run loops are visually seamless enough at actual game speed.

Generated sprite sheets are **candidates**, never automatically considered production-ready.

## 6. Concept-screen versus production-screen rule

The previous full-screen Daybreak mockup is a **mood and layout reference**, not an executable asset. The actual game should consist of:
- layered scenic assets rendered through Flame;
- individual animated chibi entities and particles;
- native Flutter task, skill, menu, navigation and status widgets;
- reusable decorative UI frames/icons;
- responsive composition that adapts to iPhone, tablet, Mac and later platforms.

Do not crop text-bearing elements out of the composite mockup and ship them as buttons.

## 7. Assets and rights

Current repository's *Sunny Land* pixel-art pack is credited as **CC0** in assets/CREDITS.md. It is the current functional placeholder and may remain until each replacement meets quality/testing criteria. Retain required source metadata and verify license for every external asset.

Keep a provenance entry for each new image/sound/source: asset name, creator/source tool, generation date, upstream reference, license/permission, modifications, intended use and review status. Keep third-party inspiration separate from final work.

## 8. Approval checkpoints

- [ ] Art direction/colour palette approved through one Home screenshot.
- [ ] One character turnaround + portrait matching approved.
- [ ] Hero animation reads clearly at actual viewport size.
- [ ] First environment parallax and combat contrast approved.
- [ ] UI kit passes mobile legibility, focus/selected states and reduced-motion requirements.
- [ ] Asset manifest records source, license and integration status for each file.

**Next companion document:** [Asset Manifest](../production/asset-manifest.md).