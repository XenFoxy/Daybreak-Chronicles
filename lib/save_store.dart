import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'progression.dart';

class SaveStore {
  SaveStore(this._preferences);

  final SharedPreferencesAsync _preferences;
  static const _key = 'daybreak.profile';

  Future<Profile> load(DateTime now) async {
    final saved = await _preferences.getString(_key);
    return saved == null
        ? Profile(now)
        : Profile.fromJson(jsonDecode(saved) as Map<String, dynamic>);
  }

  Future<void> save(Profile profile) =>
      _preferences.setString(_key, jsonEncode(profile.toJson()));
}
