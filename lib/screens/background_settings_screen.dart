import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/background_provider.dart';

class BackgroundSettingsScreen extends StatelessWidget {
  final String pageName;

  const BackgroundSettingsScreen({
    super.key,
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('背景设置'),
      ),
      body: Consumer<BackgroundProvider>(
        builder: (context, backgroundProvider, _) {
          final settings = backgroundProvider.getBackgroundForPage(pageName);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 当前背景预览
              if (settings.imagePath != null)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(File(settings.imagePath!)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // 选择图片按钮
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final image = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    await backgroundProvider.setBackgroundForPage(
                      pageName,
                      image.path,
                    );
                  }
                },
                icon: const Icon(Icons.image),
                label: const Text('选择背景图片'),
              ),

              const SizedBox(height: 24),

              // 透明度滑块
              Text(
                '背景不透明度: ${(settings.opacity * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Slider(
                value: settings.opacity,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  backgroundProvider.updateOpacity(pageName, value);
                },
              ),

              const SizedBox(height: 24),

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
                          items:
                              BackgroundSettings.blendModeOptions.map((option) {
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

              const SizedBox(height: 24),

              // 重置按钮
              OutlinedButton.icon(
                onPressed: () {
                  backgroundProvider.resetToDefault(pageName);
                },
                icon: const Icon(Icons.restore),
                label: const Text('恢复默认背景'),
              ),
            ],
          );
        },
      ),
    );
  }
}
