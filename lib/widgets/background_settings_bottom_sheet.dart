import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/background_provider.dart';

class BackgroundSettingsBottomSheet extends StatelessWidget {
  final String pageName;

  const BackgroundSettingsBottomSheet({
    super.key,
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 顶部拖动条
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // 标题
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '背景设置',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),

          // 选项列表
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('选择图片'),
            onTap: () async {
              final picker = ImagePicker();
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image != null && context.mounted) {
                context.read<BackgroundProvider>().setBackgroundForPage(
                      pageName,
                      image.path,
                    );
              }
              if (context.mounted) Navigator.pop(context);
            },
          ),

          // 透明度调节
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<BackgroundProvider>(
              builder: (context, provider, _) {
                final settings = provider.getBackgroundForPage(pageName);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '背景不透明度: ${(settings.opacity * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: settings.opacity,
                      min: 0.0,
                      max: 1.0,
                      onChanged: (value) {
                        provider.updateOpacity(pageName, value);
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          // 重置按钮
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('恢复默认背景'),
            onTap: () {
              context.read<BackgroundProvider>().resetToDefault(pageName);
              Navigator.pop(context);
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
