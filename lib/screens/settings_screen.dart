import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/background_settings_screen.dart';
import '../providers/audio_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: ListView(
        children: [
          const _SettingsSection(
            title: '个性化',
            children: [
              _ThemeSettingTile(),
              _BackgroundSettingTile(),
            ],
          ),
          const _SettingsSection(
            title: '通用设置',
            children: [
              _ThemeSettingTile(),
              _SwitchSettingTile(
                title: '自动播放',
                subtitle: '打开应用时自动继续播放',
                icon: Icons.play_circle_outline,
              ),
              _SwitchSettingTile(
                title: '移动网络播放',
                subtitle: '使用移动网络时播放音乐',
                icon: Icons.network_cell,
              ),
            ],
          ),
          const _SettingsSection(
            title: '播放设置',
            children: [
              _SwitchSettingTile(
                title: '硬件解码',
                subtitle: '使用硬件加速进行音频解码',
                icon: Icons.memory,
              ),
              _QualitySettingTile(),
            ],
          ),
          const _SettingsSection(
            title: '下载设置',
            children: [
              _StorageSettingTile(),
              _SwitchSettingTile(
                title: '仅WiFi下载',
                subtitle: '仅在WiFi网络下下载音乐',
                icon: Icons.wifi,
              ),
            ],
          ),
          const _SettingsSection(
            title: '关于',
            children: [
              _AboutSettingTile(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _ThemeSettingTile extends StatelessWidget {
  const _ThemeSettingTile();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text('主题设置'),
          subtitle: Text(
            themeProvider.themeMode == ThemeMode.system
                ? '跟随系统'
                : themeProvider.themeMode == ThemeMode.light
                    ? '亮色'
                    : '暗色',
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => _ThemeDialog(),
            );
          },
        );
      },
    );
  }
}

class _ThemeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return SimpleDialog(
          title: const Text('选择主题'),
          children: [
            RadioListTile<ThemeMode>(
              title: const Text('跟随系统'),
              value: ThemeMode.system,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('亮色'),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: const Text('暗色'),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  themeProvider.setThemeMode(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _SwitchSettingTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _SwitchSettingTile({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  State<_SwitchSettingTile> createState() => _SwitchSettingTileState();
}

class _SwitchSettingTileState extends State<_SwitchSettingTile> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: _value,
      onChanged: (value) {
        setState(() {
          _value = value;
        });
      },
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      secondary: Icon(widget.icon),
    );
  }
}

class _QualitySettingTile extends StatelessWidget {
  const _QualitySettingTile();

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        return ListTile(
          leading: const Icon(Icons.high_quality),
          title: const Text('音质设置'),
          subtitle: Text(audioProvider.quality.label),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => _QualityDialog(),
            );
          },
        );
      },
    );
  }
}

class _QualityDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        return SimpleDialog(
          title: const Text('音质设置'),
          children: [
            ...AudioQuality.values.map((quality) {
              return RadioListTile<AudioQuality>(
                title: Text(quality.label),
                subtitle: Text(quality.description),
                value: quality,
                groupValue: audioProvider.quality,
                onChanged: (AudioQuality? value) {
                  if (value != null) {
                    if (value == AudioQuality.hifi) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('提示'),
                          content: const Text('无损音质需要更多的存储空间和流量，确定要切换吗？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () {
                                audioProvider.setQuality(value);
                                Navigator.pop(context); // 关闭确认对话框
                                Navigator.pop(context); // 关闭音质设置对话框
                              },
                              child: const Text('确定'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      audioProvider.setQuality(value);
                      Navigator.pop(context);
                    }
                  }
                },
              );
            }).toList(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                '提示：较高音质需要更多的存储空间和流量',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StorageSettingTile extends StatelessWidget {
  const _StorageSettingTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder),
      title: const Text('下载位置'),
      subtitle: const Text('内部存储/Music'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: 实现存储位置设置
      },
    );
  }
}

class _AboutSettingTile extends StatelessWidget {
  const _AboutSettingTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: const Text('关于'),
      subtitle: const Text('版本 1.0.0'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        showAboutDialog(
          context: context,
          applicationName: 'Music Player',
          applicationVersion: '1.0.0',
          applicationIcon: const FlutterLogo(size: 32),
          children: const [
            Text('这是一个使用Flutter开发的音乐播放器示例应用。'),
          ],
        );
      },
    );
  }
}

class _BackgroundSettingTile extends StatelessWidget {
  const _BackgroundSettingTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.wallpaper),
      title: const Text('背景设置'),
      subtitle: const Text('自定义应用背景'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BackgroundSettingsScreen(
              pageName: 'home',
            ),
          ),
        );
      },
    );
  }
}
