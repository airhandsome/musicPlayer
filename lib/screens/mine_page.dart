import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:musicplayer/providers/music_provider.dart';
import 'package:musicplayer/widgets/import_progress_dialog.dart';

class MinePage extends StatelessWidget {
  const MinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: ListView(
        children: [
          // 用户信息
          ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: const Text('点击登录'),
            subtitle: const Text('登录后享受更多功能'),
            onTap: () {
              // TODO: 实现登录功能
            },
          ),
          const Divider(),
          // 功能列表
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('我喜欢的音乐'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 导航到我喜欢的音乐页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('最近播放'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 导航到最近播放页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('本地下载'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 导航到本地下载页面
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: const Text('导入本地音乐'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              final musicProvider = context.read<MusicProvider>();
              ImportProgressDialogState? dialogState;

              // 显示进度对话框
              if (!context.mounted) return;
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => ImportProgressDialog(
                  onInit: (state) => dialogState = state,
                ),
              );

              await musicProvider.importLocalMusic((progress, message) {
                dialogState?.updateProgress(progress, message);
              });

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('导入完成')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
