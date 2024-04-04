import 'package:flutter/material.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:launcher_icon_switcher/launcher_icon_switcher.dart';

class ChangeAppIconScreen extends StatefulWidget {
  const ChangeAppIconScreen({super.key});

  @override
  State<ChangeAppIconScreen> createState() => _ChangeAppIconScreenState();
}

class _ChangeAppIconScreenState extends State<ChangeAppIconScreen> {
  int iconIndex = 0;
  AndroidPackageManager ap = AndroidPackageManager();

  @override
  void initState() {
    super.initState();
  }

  void changeIcon() {}
  List iconName = <String>[
    'ic_launcher_1',
    'ic_launcher_2',
  ];
  List<String> imagefiles = ['lib/assets/icon_1.png', 'lib/assets/icon_2.png'];

  changeAppIcon() async {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildIconTile(0, 'Unicorn Club'),
            buildIconTile(1, 'Chealsea Club'),
            ElevatedButton(
              onPressed: () => changeAppIcon(),
              child: const Text('Set as app icon'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIconTile(int index, String themeTxt) => Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () => setState(() => iconIndex = index),
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
