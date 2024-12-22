// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicplayer/models/playlist.dart';
import 'package:musicplayer/main.dart';
import 'package:musicplayer/services/api_service.dart';
import 'package:musicplayer/services/audio_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // 设置 SharedPreferences 的模拟实例
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // 创建服务实例
    final apiService = ApiService();
    final audioService = AudioService();

    // 构建应用并触发一个frame
    await tester.pumpWidget(MyApp(
      prefs: prefs,
      apiService: apiService,
      audioService: audioService,
    ));

    // 基本UI测试
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  test('Playlist model test', () {
    final playlist = Playlist(
      id: 'test_id',
      title: '测试歌单',
      description: '测试描述',
      coverUrl: 'test_cover.jpg',
      creatorId: 'user_1',
      creatorName: '测试用户',
      songIds: ['1', '2', '3'],
      playCount: 1000,
      isOfficial: false,
    );

    expect(playlist.id, 'test_id');
    expect(playlist.title, '测试歌单');
    expect(playlist.description, '测试描述');
    expect(playlist.coverUrl, 'test_cover.jpg');
    expect(playlist.creatorId, 'user_1');
    expect(playlist.creatorName, '测试用户');
    expect(playlist.songIds, ['1', '2', '3']);
    expect(playlist.playCount, 1000);
    expect(playlist.isOfficial, false);
  });

  test('Playlist fromJson test', () {
    final json = {
      'id': 'test_id',
      'title': '测试歌单',
      'description': '测试描述',
      'coverUrl': 'test_cover.jpg',
      'creatorId': 'user_1',
      'creatorName': '测试用户',
      'songIds': ['1', '2', '3'],
      'playCount': 1000,
      'isOfficial': false,
    };

    final playlist = Playlist.fromJson(json);

    expect(playlist.id, json['id']);
    expect(playlist.title, json['title']);
    expect(playlist.description, json['description']);
    expect(playlist.coverUrl, json['coverUrl']);
    expect(playlist.creatorId, json['creatorId']);
    expect(playlist.creatorName, json['creatorName']);
    expect(playlist.songIds, json['songIds']);
    expect(playlist.playCount, json['playCount']);
    expect(playlist.isOfficial, json['isOfficial']);
  });
}
