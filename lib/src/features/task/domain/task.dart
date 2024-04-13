import 'dart:convert';

import 'package:task_management/src/features/task/domain/unique_id.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppTask {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  const AppTask({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
  });

  AppTask copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
  }) {
    return AppTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
    };
  }

  factory AppTask.fromMap(Map<String, dynamic> map) {
    return AppTask(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory AppTask.fromJson(String source) =>
      AppTask.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppTask(id: $id, title: $title, description: $description, dueDate: $dueDate)';
  }

  @override
  bool operator ==(covariant AppTask other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.dueDate == dueDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        dueDate.hashCode;
  }
}
