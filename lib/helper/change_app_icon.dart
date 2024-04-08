import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';

class ChangeAppIconIOS {
  static void changeAppIconIOS(String iconName) async {
    try {
      if (await FlutterDynamicIcon.supportsAlternateIcons) {
        await FlutterDynamicIcon.setAlternateIconName(iconName);
        debugPrint("App icon change successful");
        return;
      }
    } catch (e) {
      throw Exception("Exception: ${e.toString()}");
    }
    throw Exception("Failed to change app icon ");
  }
}

class ChangeAppIconAndroid {
  final packageManager = AndroidPackageManager();
  void changeAppIconAndroid({
    required String targetActivityName,
    required String currActivityName,
    required BuildContext context,
  }) async {
    try {
      String pkg = 'com.example.dynamic_app_icon';
      String cls = 'com.example.dynamic_app_icon.$targetActivityName';
      try {
        await packageManager.setComponentEnabledSetting(
          componentName: ComponentName(pkg, cls),
          newState: ComponentEnabledState.stateEnabled,
          flags: EnabledFlags(
            {
              PMFlag.doNotKillApp,
              PMFlag.synchronous,
            },
          ),
        );
      } catch (e) {
        throw Exception('Activity Enable Error : $e');
      }

      try {
        if (currActivityName == targetActivityName) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Already in the Club'),
              duration: Duration(seconds: 1),
            ),
          );
          return;
        }

        await packageManager.setComponentEnabledSetting(
          componentName: ComponentName(
            pkg,
            currActivityName.isNotEmpty
                ? 'com.example.dynamic_app_icon.$currActivityName'
                : 'com.example.dynamic_app_icon.MainActivity',
          ),
          newState: ComponentEnabledState.stateDisabled,
          flags: EnabledFlags({
            PMFlag.doNotKillApp,
            PMFlag.synchronous,
          }),
        );
      } catch (e) {
        throw Exception('Activity Disable Error : $e');
      }
    } catch (e) {
      throw Exception('Failed to change activity: $e');
    }
  }
}

class GetActivityName {
  static Future<String> getActivityName() async {
    const platform = MethodChannel('my_channel');
    try {
      final String activityName =
          await platform.invokeMethod('getCurrentActivityName');
      print('Current Activity Name : $activityName');
      return activityName;
    } on PlatformException catch (e) {
      throw Exception('Failed to get activity name: ${e.message}');
    }
  }
}
