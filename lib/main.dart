import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'providers/background_provider.dart';
import 'providers/music_provider.dart';
import 'services/api_service.dart';
import 'services/audio_service.dart';
import 'providers/audio_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // 初始化服务
  final apiService = ApiService();
  final audioService = AudioService();

  runApp(MyApp(
    prefs: prefs,
    apiService: apiService,
    audioService: audioService,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final ApiService apiService;
  final AudioService audioService;

  const MyApp({
    super.key,
    required this.prefs,
    required this.apiService,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => BackgroundProvider(prefs),
        ),
        ChangeNotifierProvider(
          create: (_) => MusicProvider(
            apiService: apiService,
            audioService: audioService,
          ),
        ),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: Consumer2<ThemeProvider, BackgroundProvider>(
        builder: (context, themeProvider, backgroundProvider, child) {
          return MaterialApp(
            title: 'Music Player',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
