import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite_demo/data/theme_provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    bool themeDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: false,
        backgroundColor: Colors.blue.withOpacity(0.5),
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 26.0,
          ),
        ),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
            child: ListTile(
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              title: const Text(
                "Dark Mode",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 22.0,
                ),
              ),
              subtitle: const Text(
                "Change Theme Mode Here!",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                ),
              ),
              trailing: Switch.adaptive(
                activeTrackColor: Colors.blueGrey,
                thumbColor: WidgetStateProperty.all(
                    themeDark ? Colors.white : Colors.black),
                value: provider.getThemeData(),
                onChanged: (value) async {
                  provider.updateTheme(value: value);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('isDarkMode', value);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
