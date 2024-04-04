import 'package:flutter/material.dart';
import 'package:android_dynamic_icon/android_dynamic_icon.dart';

void main() {
  runApp(const ChangeIcon2());
}

class ChangeIcon2 extends StatefulWidget {
  const ChangeIcon2({super.key});

  @override
  State<ChangeIcon2> createState() => _ChangeIcon2State();
}

class _ChangeIcon2State extends State<ChangeIcon2> {
  final _androidDynamicIconPlugin = AndroidDynamicIcon();
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> iconName = <String>[
      'ic_launcher_1',
      'ic_launcher_2',
      'ic_launcher_3',
      'ic_launcher_4',
      'ic_launcher_5',
    ];
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: GestureDetector(
          onTap: () async {
            print('before change index :$index');
            await _androidDynamicIconPlugin.changeIcon(
              bundleId: "com.example.dynamic_app_icon",
              isNewIcon: true,
              iconName: iconName[index],
              iconNames: iconName,
            );
            print(
                'after change index :$index and Changed the icon ${iconName[index]}');
            index += 1;
          },
          child: const Center(
            child: Text('Change Icon'),
          ),
        ),
      ),
    );
  }
}
