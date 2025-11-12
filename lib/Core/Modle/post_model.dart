class PostModel {
  final String id;
  final String title;
  final String content;
  final String status;
  final bool isDeleted;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AuthorModel author;
  final List<MediaModel> media;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.status,
    required this.isDeleted,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.viewsCount,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.media,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json["id"] ?? json["_id"] ?? "",
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      status: json["status"] ?? "",
      isDeleted: json["isDeleted"] ?? false,
      likesCount: json["likesCount"] ?? 0,
      commentsCount: json["commentsCount"] ?? 0,
      sharesCount: json["sharesCount"] ?? 0,
      viewsCount: json["viewsCount"] ?? 0,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? "") ?? DateTime.now(),
      author: AuthorModel.fromJson(json["author"] ?? {}),
      media: (json["media"] as List<dynamic>?)
              ?.map((e) => MediaModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AuthorModel {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final bool isActive;
  final String imageUrl;

  AuthorModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.isActive,
    required this.imageUrl,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json["id"] ?? json["_id"] ?? "",
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      username: json["username"] ?? "",
      isActive: json["isActive"] ?? false,
      imageUrl: json["imageUrl"] ?? "",
    );
  }

  String get fullName => "$firstName $lastName".trim();
}

class MediaModel {
  final String type;
  final String file;

  MediaModel({required this.type, required this.file});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      type: json["type"] ?? "",
      file: json["file"] ?? "",
    );
  }
}
