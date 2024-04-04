import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:android_package_manager/android_package_manager.dart';
// import 'package:launcher_icon_switcher/launcher_icon_switcher.dart';

class ChangeAppIconScreen extends StatefulWidget {
  const ChangeAppIconScreen({super.key});

  @override
  State<ChangeAppIconScreen> createState() => _ChangeAppIconScreenState();
}

class _ChangeAppIconScreenState extends State<ChangeAppIconScreen> {
  final packageManager = AndroidPackageManager();
  final String pkg = 'com.example.dynamic_app_icon';
  int iconIndex = 0;
  String name = '';

  List<String> iconName = <String>[
    'ic_launcher_1',
    'ic_launcher_2',
    'ic_launcher_3',
    'ic_launcher_4',
    'ic_launcher_5',
  ];

  List<String> imagefiles = [
    'lib/assets/icon_1.png',
    'lib/assets/icon_2.png',
    'lib/assets/icon_3.png',
    'lib/assets/icon_4.png',
    'lib/assets/icon_5.png',
  ];

  @override
  void initState() {
    super.initState();
    _getActivityName();
  }

  void _getActivityName() async {
    const platform = MethodChannel('my_channel');
    try {
      final String activityName =
          await platform.invokeMethod('getCurrentActivityName');
      setState(() {
        name = activityName;
      });
      print('Current Activity Name : $name');
    } on PlatformException catch (e) {
      throw 'Failed to get activity name: ${e.message}';
    }
  }

  void changeAppIconAndroid(String iconCls) async {
    try {
      String cls = 'com.example.dynamic_app_icon.$iconCls';

      // Enable the activity alias
      try {
        await packageManager.setComponentEnabledSetting(
          componentName: ComponentName(pkg, cls),
          newState: ComponentEnabledState.stateEnabled,
          flags: EnabledFlags({
            PMFlag.doNotKillApp,
            PMFlag.synchronous,
          }),
        );
      } catch (e) {
        print('Activity Enable Error : $e');
      }

      try {
        if (iconCls == name) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Already in the Club'),
              duration: Duration(seconds: 1),
            ),
          );
          print('Already in the club');
          return;
        }

        await packageManager.setComponentEnabledSetting(
          componentName: ComponentName(
            pkg,
            name.isNotEmpty
                ? 'com.example.dynamic_app_icon.$name'
                : 'com.example.dynamic_app_icon.MainActivity',
          ),
          newState: ComponentEnabledState.stateDisabled,
          flags: EnabledFlags({
            PMFlag.doNotKillApp,
            PMFlag.synchronous,
          }),
        );
        print('Activity Disabled = $name');
        print('Activity Changed Succesfully');
      } catch (e) {
        print('Activity Disable Error : $e');
      }
    } catch (e) {
      print('Failed to change activity: $e');
    }
  }

  changeAppIconIOS() async {
    try {
      if (await FlutterDynamicIcon.supportsAlternateIcons) {
        await FlutterDynamicIcon.setAlternateIconName(iconName[iconIndex]);
        debugPrint("App icon change successful");
        return;
      }
    } catch (e) {
      debugPrint("Exception: ${e.toString()}");
    }
    debugPrint("Failed to change app icon ");
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('IOS Required')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change App Icon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildIconTile(0, 'Unicorn Club'),
            buildIconTile(1, 'Chealsea Club'),
            buildIconTile(2, 'Manchester United Club'),
            buildIconTile(3, 'Barcelona Club'),
            buildIconTile(4, 'Real Madrid Club'),
          ],
        ),
      ),
    );
  }

  Widget buildIconTile(int index, String themeTxt) => Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            setState(
              () => iconIndex = index,
            );
            changeAppIconAndroid(iconName[index]);
          },
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
            leading: Image.asset(
              imagefiles[index],
              width: 45,
              height: 45,
            ),
            title: Text(themeTxt, style: const TextStyle(fontSize: 25)),
            trailing: iconIndex == index
                ? const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 30,
                  )
                : Icon(
                    Icons.circle_outlined,
                    color: Colors.grey.withOpacity(0.5),
                    size: 30,
                  ),
          ),
        ),
      );
}
