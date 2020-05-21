import 'package:fedi/local_preferences/local_preferences_model.dart';
import 'package:hive/hive.dart';

part 'my_account_settings_model.g.dart';

@HiveType()
class MyAccountSettings implements IPreferencesObject {
  @HiveField(0)
  bool isRealtimeWebSocketsEnabled;
  @HiveField(1)
  bool isNewChatsEnabled;

  MyAccountSettings(
      {this.isRealtimeWebSocketsEnabled, this.isNewChatsEnabled});

  MyAccountSettings copyWith(
          {bool isRealtimeWebSocketsEnabled, bool isNewChatsEnabled}) =>
      MyAccountSettings(
          isRealtimeWebSocketsEnabled:
              isRealtimeWebSocketsEnabled ?? this.isRealtimeWebSocketsEnabled,
          isNewChatsEnabled:
              isNewChatsEnabled ?? this.isNewChatsEnabled);
}