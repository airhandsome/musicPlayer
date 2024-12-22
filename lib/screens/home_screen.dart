import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:musicplayer/providers/background_provider.dart';
import 'package:musicplayer/providers/theme_provider.dart';
import 'package:musicplayer/widgets/theme_switch.dart';
import 'discover_page.dart';
import 'podcast_page.dart';
import 'community_page.dart';
import 'my_music_page.dart';
import 'settings_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/animated_background.dart';
import 'package:provider/provider.dart';
import '../widgets/background_settings_bottom_sheet.dart';
import '../providers/audio_provider.dart';
import 'player_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DiscoverPage(),
    const PodcastPage(),
    const CommunityPage(),
    const MyMusicPage(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // 在构建开始时验证 Provider 是否可用
    final backgroundProvider = Provider.of<BackgroundProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    print('HomeScreen building...');

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: GestureDetector(
        onLongPress: () {
          _showBackgroundSettings(context);
        },
        child: SafeArea(
          child: AnimatedBackground(
            pageName: 'home',
            defaultBackgroundImage: 'assets/images/bg.jpg',
            child: Stack(
              children: [
                ColoredBox(
                  color: Colors.red.withOpacity(0.1),
                  child: Column(
                    children: [
                      Builder(builder: (context) {
                        print('Building AppBar...');
                        return _buildAppBar();
                      }),
                      Expanded(
                        child: Builder(builder: (context) {
                          print('Building Screen: $_selectedIndex');
                          return _screens[_selectedIndex];
                        }),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Builder(builder: (context) {
                    print('Building bottom section...');
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMiniPlayer(),
                        _buildBottomNav(),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    print('_buildAppBar called');
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '搜索二次元音乐...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Icon(Icons.mic),
            const SizedBox(width: 16),
            const ThemeSwitch(),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniPlayer() {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final currentSong = audioProvider.currentSong;
        if (currentSong == null) return const SizedBox.shrink();

        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayerDetailPage(),
              ),
            );
          },
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: AssetImage(currentSong.coverUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                currentSong.title,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                currentSong.artist,
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    onPressed: () => audioProvider.playPause(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    onPressed: () => audioProvider.nextSong(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav() {
    print('_buildBottomNav called');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: GNav(
        gap: 8,
        activeColor: Theme.of(context).primaryColor,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.grey[600],
        iconSize: 24,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: '发现',
          ),
          GButton(
            icon: Icons.podcasts,
            text: '播客',
          ),
          GButton(
            icon: Icons.people,
            text: '社区',
          ),
          GButton(
            icon: Icons.person,
            text: '我的',
          ),
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  // 音乐卡片件

  // 推荐歌单卡片

  // 添加背景设置弹窗方法
  void _showBackgroundSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackgroundSettingsBottomSheet(
        pageName: 'home',
      ),
    );
  }
}
