class Post {
  final String id;
  final String userId;
  final String username;
  final String? userAvatarUrl;
  final String content;
  final DateTime createTime;
  final String? songId;
  final String? songTitle;
  final String? songArtist;
  final int likeCount;
  final int commentCount;
  final int shareCount;
  final bool isLiked;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    this.userAvatarUrl,
    required this.content,
    required this.createTime,
    this.songId,
    this.songTitle,
    this.songArtist,
    this.likeCount = 0,
    this.commentCount = 0,
    this.shareCount = 0,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      userAvatarUrl: json['userAvatarUrl'] as String?,
      content: json['content'] as String,
      createTime: DateTime.parse(json['createTime'] as String),
      songId: json['songId'] as String?,
      songTitle: json['songTitle'] as String?,
      songArtist: json['songArtist'] as String?,
      likeCount: json['likeCount'] as int? ?? 0,
      commentCount: json['commentCount'] as int? ?? 0,
      shareCount: json['shareCount'] as int? ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userAvatarUrl': userAvatarUrl,
      'content': content,
      'createTime': createTime.toIso8601String(),
      'songId': songId,
      'songTitle': songTitle,
      'songArtist': songArtist,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'shareCount': shareCount,
      'isLiked': isLiked,
    };
  }
}
