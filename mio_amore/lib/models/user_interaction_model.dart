import 'dart:convert';
import 'package:collection/collection.dart';

class UserInteractionModel {
  String id;
  List<InteractionUser> interactions;
  List<String> userIds;
  DateTime createdAt;
  UserInteractionModel({
    required this.id,
    required this.interactions,
    required this.userIds,
    required this.createdAt,
  });

  UserInteractionModel copyWith({
    String? id,
    List<InteractionUser>? interactions,
    List<String>? userIds,
    DateTime? createdAt,
  }) {
    return UserInteractionModel(
      id: id ?? this.id,
      interactions: interactions ?? this.interactions,
      userIds: userIds ?? this.userIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result
        .addAll({'interactions': interactions.map((x) => x.toMap()).toList()});
    result.addAll({'userIds': userIds});
    result.addAll({'createdAt': createdAt.millisecondsSinceEpoch});

    return result;
  }

  factory UserInteractionModel.fromMap(Map<String, dynamic> map) {
    return UserInteractionModel(
      id: map['id'] ?? '',
      interactions: List<InteractionUser>.from(
          map['interactions']?.map((x) => InteractionUser.fromMap(x))),
      userIds: List<String>.from(map['userIds']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInteractionModel.fromJson(String source) =>
      UserInteractionModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserInteractionModel(id: $id, interactions: $interactions, userIds: $userIds, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is UserInteractionModel &&
        other.id == id &&
        listEquals(other.interactions, interactions) &&
        listEquals(other.userIds, userIds) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        interactions.hashCode ^
        userIds.hashCode ^
        createdAt.hashCode;
  }
}

class InteractionUser {
  String userId;
  bool isSuperliked;
  bool isLiked;
  bool isDisliked;
  InteractionUser({
    required this.userId,
    required this.isSuperliked,
    required this.isLiked,
    required this.isDisliked,
  });

  InteractionUser copyWith({
    String? userId,
    bool? isSuperliked,
    bool? isLiked,
    bool? isDisliked,
  }) {
    return InteractionUser(
      userId: userId ?? this.userId,
      isSuperliked: isSuperliked ?? this.isSuperliked,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'userId': userId});
    result.addAll({'isSuperliked': isSuperliked});
    result.addAll({'isLiked': isLiked});
    result.addAll({'isDisliked': isDisliked});

    return result;
  }

  factory InteractionUser.fromMap(Map<String, dynamic> map) {
    return InteractionUser(
      userId: map['userId'] ?? '',
      isSuperliked: map['isSuperliked'] ?? false,
      isLiked: map['isLiked'] ?? false,
      isDisliked: map['isDisliked'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory InteractionUser.fromJson(String source) =>
      InteractionUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'InteractionUser(userId: $userId, isSuperliked: $isSuperliked, isLiked: $isLiked, isDisliked: $isDisliked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InteractionUser &&
        other.userId == userId &&
        other.isSuperliked == isSuperliked &&
        other.isLiked == isLiked &&
        other.isDisliked == isDisliked;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        isSuperliked.hashCode ^
        isLiked.hashCode ^
        isDisliked.hashCode;
  }
}
