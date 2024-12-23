# Music Player App

一个基于 Flutter 开发的音乐播放器应用。

## 功能特点

- 推荐歌单展示
- 最新音乐列表
- 音乐播放控制
- 播放列表管理
- 迷你播放器
- 全屏播放页面

## 开发环境

- Flutter 3.x
- Dart 3.x
- Android Studio / VS Code
- just_audio: ^0.9.x

## 项目结构

```
lib/
  ├── models/          # 数据模型
  ├── providers/       # 状态管理
  ├── screens/         # 页面
  ├── widgets/         # 组件
  └── main.dart        # 入口文件

assets/
  ├── data/           # JSON 数据
  ├── images/         # 图片资源
  │   ├── banners/    # 轮播图
  │   └── covers/     # 封面图
  └── audio/          # 音频文件
```

## 开发说明

1. 克隆项目
```bash
git clone [项目地址]
cd musicplayer
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行项目
```bash
flutter run
```

## 数据说明

- `assets/data/recommended_playlists.json`: 推荐歌单数据
- `assets/data/songs.json`: 歌曲数据

## 主要依赖

- provider: 状态管理
- just_audio: 音频播放
- cached_network_image: 图片缓存

## 使用说明

1. 首页
   - 顶部轮播图展示推荐内容
   - 推荐歌单网格展示
   - 最新音乐列表

2. 播放控制
   - 点击歌曲播放
   - 迷你播放器显示当前播放
   - 点击迷你播放器进入全屏播放页

3. 歌单详情
   - 显示歌单信息
   - 歌曲列表
   - 播放控制

## 注意事项

1. 确保资源文件正确放置
2. 本地开发需要完整的测试数据
3. 音频文件需要放在 assets/audio 目录下

## 贡献指南

1. Fork 项目
2. 创建特性分支
3. 提交更改
4. 发起 Pull Request

## 许可证

GNU License