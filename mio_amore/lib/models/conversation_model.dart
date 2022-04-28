import 'dart:convert';
import 'package:collection/collection.dart';

class ConversationModel {
  String id;
  List<String> userIds;
  ConversationModel({
    required this.id,
    required this.userIds,
  });

  ConversationModel copyWith({
    String? id,
    List<String>? userIds,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      userIds: userIds ?? this.userIds,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'userIds': userIds});

    return result;
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      id: map['id'] ?? '',
      userIds: List<String>.from(map['userIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationModel.fromJson(String source) =>
      ConversationModel.fromMap(json.decode(source));

  @override
  String toString() => 'ConversationModel(id: $id, userIds: $userIds)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is ConversationModel &&
        other.id == id &&
        listEquals(other.userIds, userIds);
  }

  @override
  int get hashCode => id.hashCode ^ userIds.hashCode;
}
