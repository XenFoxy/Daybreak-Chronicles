# Daybreak Chronicles

A Flutter + Flame idle RPG where the things you do in real life shape your adventurer. The first playable chapter is **The Lantern Trail**.

## Play the prototype

1. Let your adventurer auto-battle through Lantern Meadow. Miri, the lantern scout, joins you at the bridge.
2. Log a walk, a learning session, or a creative activity in **Life quests**. Each activity grants 10 XP to its corresponding skill once per local day. Skill XP raises party attack.
3. At 20 XP in a skill, its class awakening appears in **Skill profile**. Select a discovered class to equip its combat bonus.
4. Close the app and return after at least a minute. Cleared stages earn one XP per cleared stage per full idle minute for each party member, up to eight hours per absence. Offline rewards never clear new stages. Miri gains battle XP alongside you after joining.

The Flame scene uses original drawn placeholders for the chibi party and landscapes. The three-stage campaign replays its final encounter after completion.

## Run on macOS or iOS

Install the current stable [Flutter SDK](https://docs.flutter.dev/install), full [Xcode](https://developer.apple.com/xcode/), and the platform tools reported by `flutter doctor`. The iOS simulator requires an installed iOS runtime.

From the repository root:

```sh
flutter doctor -v
./tool/bootstrap_apple.sh
flutter pub get
flutter run -d macos
```

The bootstrap script generates the Apple runner folders from Flutter templates and leaves existing runners in place.

For an iOS simulator, open Simulator, then use the device ID printed by Flutter:

```sh
open -a Simulator
flutter devices
flutter run -d <simulator-device-id>
```

A physical iPhone requires Apple development signing and Developer Mode. See [Flutter's iOS setup](https://docs.flutter.dev/platform-integration/ios/setup).

## Checks

```sh
flutter analyze
flutter test
```

## Code layout

- `lib/progression.dart` holds the pure Dart rules for life quests, skills, class discoveries, encounters, companions and offline rewards.
- `lib/save_store.dart` reads and writes a single versioned local profile using shared preferences. Combat and reward checkpoints are saved alongside XP. This prototype uses one local slot per installation.
- `lib/main.dart` binds the profile, lifecycle and saved actions to the Flutter interface.
- `lib/trail_scene.dart` draws the animated trail in Flame. Simulation stays independent of frame rate.

Android, Linux, Windows and web can use the same game rules and interface. Platform packaging and verification are future work.
