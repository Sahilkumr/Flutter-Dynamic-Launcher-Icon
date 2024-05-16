import 'dart:io';
import 'package:dynamic_app_icon/helper/change_app_icon.dart';
import 'package:flutter/material.dart';
import 'package:launcher_icon_switcher/launcher_icon_switcher.dart';

class ChangeAppIconScreen extends StatefulWidget {
  const ChangeAppIconScreen({super.key});

  @override
  State<ChangeAppIconScreen> createState() => _ChangeAppIconScreenState();
}

class _ChangeAppIconScreenState extends State<ChangeAppIconScreen> {
  ValueNotifier<int> iconIndex = ValueNotifier(0);
  final _iconSwitcher = LauncherIconSwitcher();
  String currActivityName = '';
  List<String> iconName = <String>[
    'ic_launcher_1',
    'ic_launcher_2',
    'ic_launcher_3',
    'ic_launcher_4',
    'ic_launcher_5',
    'MainActivityAlias',
  ];
  List<String> imagefiles = [
    'lib/assets/icon_1.png',
    'lib/assets/icon_2.png',
    'lib/assets/icon_3.png',
    'lib/assets/icon_4.png',
    'lib/assets/icon_5.png',
    'lib/assets/icon_5.png',
  ];

  @override
  void initState() {
    super.initState();
    _iconSwitcher.initialize(iconName, 'MainActivityAlias');
    GetActivityName.getActivityName().then((name) => currActivityName = name);
  }

  Future<void> changeIcon(String iconName) async{
    String currIcon = await _iconSwitcher.getCurrentIcon();
    print("Currently Used Icon : $currIcon");
    print("Icon To be Set : $iconName");
    await _iconSwitcher.setIcon(iconName,shouldKeepAlive: true);
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
            buildIconTile(5, 'Default'),
          ],
        ),
      ),
    );
  }

  Widget buildIconTile(int index, String themeTxt) => Padding(
        padding: const EdgeInsets.all(20),
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: const Text(
                    'App Icon Changed.\nApp Will Restart to Reflect Changes!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                        onPressed: () {
                          iconIndex.value = index;
                          changeIcon(iconName[index]);
                          // if (Platform.isAndroid) {
                          //   ChangeAppIconAndroid().changeAppIconAndroid(
                          //     context: context,
                          //     currActivityName: currActivityName,
                          //     targetActivityName: iconName[index],
                          //   );
                          // } else if (Platform.isIOS) {
                          //   ChangeAppIconIOS.changeAppIconIOS(iconName[index]);
                          // }
                          Navigator.pop(context);
                        },
                        child: const Text('Restart')),
                  ],
                );
              },
            );
          },
          child: ValueListenableBuilder(
            valueListenable: iconIndex,
            builder: (context, value, child) => ListTile(
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              leading: Image.asset(
                imagefiles[index],
                width: 45,
                height: 45,
              ),
              title: Text(themeTxt, style: const TextStyle(fontSize: 25)),
              trailing: value == index
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
        ),
      );
}
