import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../providers/background_provider.dart';

class AnimatedBackground extends StatelessWidget {
  final Widget child;
  final String pageName;
  final String defaultBackgroundImage;

  const AnimatedBackground({
    super.key,
    required this.child,
    required this.pageName,
    this.defaultBackgroundImage = 'assets/images/default_bg.jpg',
  });

  @override
  Widget build(BuildContext context) {
    print('Building AnimatedBackground for page: $pageName');

    return Consumer<BackgroundProvider>(
      builder: (context, backgroundProvider, _) {
        print('Background settings loaded');

        try {
          final settings = backgroundProvider.getBackgroundForPage(pageName);
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;

          return Stack(
            fit: StackFit.expand,
            children: [
              // 背景图片
              Builder(builder: (context) {
                print('Building background image');
                if (settings.imagePath != null) {
                  return Image.file(
                    File(settings.imagePath!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading file image: $error');
                      return Image.asset(
                        defaultBackgroundImage,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          print('Error loading default image: $error');
                          return const ColoredBox(color: Colors.grey);
                        },
                      );
                    },
                  );
                } else {
                  return Image.asset(
                    defaultBackgroundImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading default image: $error');
                      return const ColoredBox(color: Colors.grey);
                    },
                  );
                }
              }),

              // 渐变遮罩
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isDarkMode
                        ? [
                            Colors.black.withOpacity(settings.opacity),
                            Colors.black.withOpacity(settings.opacity + 0.05),
                          ]
                        : [
                            Colors.white.withOpacity(settings.opacity),
                            Colors.white.withOpacity(settings.opacity + 0.05),
                          ],
                  ),
                ),
              ),

              // 内容
              child,
            ],
          );
        } catch (e, stackTrace) {
          print('Error in AnimatedBackground: $e');
          print('Stack trace: $stackTrace');
          return const ColoredBox(color: Colors.grey);
        }
      },
    );
  }
}
