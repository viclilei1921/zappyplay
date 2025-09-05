import 'package:flutter/material.dart';
import 'package:zappyplay/manager/app.dart';
import 'package:zappyplay/manager/register.dart';
import 'package:zappyplay/routes/delegate.dart';
import 'package:zappyplay/utils/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = getIt<AppManager>();
    final delegate = Router.of(context).routerDelegate as ZappyRouterDelegate;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Container(
            height: 44,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => delegate.goHome(),
                  icon: const Icon(Icons.arrow_back),
                  tooltip: '返回',
                ),
                const SizedBox(width: 8),
                const Text(
                  '设置',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SwitchListTile(
                  value: Theme.of(context).brightness == Brightness.dark,
                  title: const Text('夜间模式'),
                  onChanged: (v) => app.setTheme(
                    themeMode: v ? ThemeMode.dark : ThemeMode.light,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (int i = 0; i < themeColors.length; i++)
                      InkWell(
                        onTap: () => app.setTheme(themeCode: i),
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: themeColors[i],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
