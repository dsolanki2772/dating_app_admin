import 'dart:convert';

class NotificationModel {}

class MatchingNotificationModel extends NotificationModel {
  String id;
  String userId;
  String machedUserId;
  String matchId;
  String title;
  String body;
  String? image;
  bool isRead;
  DateTime createdAt;
  MatchingNotificationModel({
    required this.id,
    required this.userId,
    required this.machedUserId,
    required this.matchId,
    required this.title,
    required this.body,
    this.image,
    required this.isRead,
    required this.createdAt,
  });

  MatchingNotificationModel copyWith({
    String? id,
    String? userId,
    String? machedUserId,
    String? matchId,
    String? title,
    String? body,
    String? image,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return MatchingNotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      machedUserId: machedUserId ?? this.machedUserId,
      matchId: matchId ?? this.matchId,
      title: title ?? this.title,
      body: body ?? this.body,
      image: image ?? this.image,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'userId': userId});
    result.addAll({'machedUserId': machedUserId});
    result.addAll({'matchId': matchId});
    result.addAll({'title': title});
    result.addAll({'body': body});
    if (image != null) {
      result.addAll({'image': image});
    }
    result.addAll({'isRead': isRead});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory MatchingNotificationModel.fromMap(Map<String, dynamic> map) {
    return MatchingNotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      machedUserId: map['machedUserId'] ?? '',
      matchId: map['matchId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      image: map['image'],
      isRead: map['isRead'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchingNotificationModel.fromJson(String source) =>
      MatchingNotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MatchingNotificationModel(id: $id, userId: $userId, machedUserId: $machedUserId, matchId: $matchId, title: $title, body: $body, image: $image, isRead: $isRead, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MatchingNotificationModel &&
        other.id == id &&
        other.userId == userId &&
        other.machedUserId == machedUserId &&
        other.matchId == matchId &&
        other.title == title &&
        other.body == body &&
        other.image == image &&
        other.isRead == isRead &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        machedUserId.hashCode ^
        matchId.hashCode ^
        title.hashCode ^
        body.hashCode ^
        image.hashCode ^
        isRead.hashCode ^
        createdAt.hashCode;
  }
}

class MessageNotificationModel extends NotificationModel {
  String id;
  String userId;
  String receiverId;
  String matchId;
  String messageId;
  MessageNotificationModel({
    required this.id,
    required this.userId,
    required this.receiverId,
    required this.matchId,
    required this.messageId,
  });

  MessageNotificationModel copyWith({
    String? id,
    String? userId,
    String? receiverId,
    String? matchId,
    String? messageId,
  }) {
    return MessageNotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      receiverId: receiverId ?? this.receiverId,
      matchId: matchId ?? this.matchId,
      messageId: messageId ?? this.messageId,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'userId': userId});
    result.addAll({'receiverId': receiverId});
    result.addAll({'matchId': matchId});
    result.addAll({'messageId': messageId});

    return result;
  }

  factory MessageNotificationModel.fromMap(Map<String, dynamic> map) {
    return MessageNotificationModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      matchId: map['matchId'] ?? '',
      messageId: map['messageId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageNotificationModel.fromJson(String source) =>
      MessageNotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MessageNotificationModel(id: $id, userId: $userId, receiverId: $receiverId, matchId: $matchId, messageId: $messageId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MessageNotificationModel &&
        other.id == id &&
        other.userId == userId &&
        other.receiverId == receiverId &&
        other.matchId == matchId &&
        other.messageId == messageId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        receiverId.hashCode ^
        matchId.hashCode ^
        messageId.hashCode;
  }
}
