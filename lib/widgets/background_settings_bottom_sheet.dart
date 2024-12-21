import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/background_provider.dart';

// 定义简化的混合模式选项
class BlendModeOption {
  final BlendMode mode;
  final String name;
  final String description;

  const BlendModeOption({
    required this.mode,
    required this.name,
    required this.description,
  });
}

class BackgroundSettingsBottomSheet extends StatelessWidget {
  final String pageName;

  const BackgroundSettingsBottomSheet({
    super.key,
    required this.pageName,
  });

  // 简化的混合模式选项列表
  static const blendModeOptions = [
    BlendModeOption(
      mode: BlendMode.srcOver,
      name: '正常',
      description: '默认模式，直接显示图片',
    ),
    BlendModeOption(
      mode: BlendMode.multiply,
      name: '正片叠底',
      description: '加深图片颜色，增加氛围感',
    ),
    BlendModeOption(
      mode: BlendMode.screen,
      name: '滤色',
      description: '提亮图片，创造梦幻效果',
    ),
    BlendModeOption(
      mode: BlendMode.overlay,
      name: '叠加',
      description: '增强对比度，使图片更有层次感',
    ),
    BlendModeOption(
      mode: BlendMode.softLight,
      name: '柔光',
      description: '柔和的光效，适合营造温馨氛围',
    ),
  ];

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

          // 选择图片
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('选择图片'),
            subtitle: const Text('从相册中选择背景图片'),
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
                    const Text(
                      '调整背景图片的透明度，数值越大背景越清晰',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
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

          // 混合模式选择
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Consumer<BackgroundProvider>(
              builder: (context, provider, _) {
                final settings = provider.getBackgroundForPage(pageName);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('混合模式'),
                    const SizedBox(height: 8),
                    DropdownButton<BlendMode>(
                      value: settings.blendMode,
                      isExpanded: true,
                      items: BackgroundSettings.blendModeOptions.map((option) {
                        return DropdownMenuItem(
                          value: option.mode,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(option.name),
                              Text(
                                option.description,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (BlendMode? value) {
                        if (value != null) {
                          provider.updateBlendMode(pageName, value);
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 重置按钮
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('恢复默认背景'),
            subtitle: const Text('重置所有背景设置为默认值'),
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
