import 'dart:convert';

import 'package:hive/hive.dart';

part 'task.g.dart';

class AppTask {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isDone;
  const AppTask(
      {required this.id,
      required this.title,
      required this.description,
      required this.dueDate,
      required this.isDone});

  AppTask copyWith(
      {int? id,
      String? title,
      String? description,
      DateTime? dueDate,
      bool? isDone}) {
    return AppTask(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        dueDate: dueDate ?? this.dueDate,
        isDone: isDone ?? this.isDone);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'isDone': isDone
    };
  }

  factory AppTask.fromMap(Map<String, dynamic> map) {
    return AppTask(
        id: map['id'] as int,
        title: map['title'] as String,
        description: map['description'] as String,
        dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
        isDone: map['isDone'] as bool);
  }

  String toJson() => json.encode(toMap());

  factory AppTask.fromJson(String source) =>
      AppTask.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppTask(id: $id, title: $title, description: $description, dueDate: $dueDate, isDone:$isDone)';
  }

  @override
  bool operator ==(covariant AppTask other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.dueDate == dueDate &&
        other.isDone == isDone;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        dueDate.hashCode ^
        isDone.hashCode;
  }
}

@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final DateTime? dueDate;

  @HiveField(3)
  final bool isDone;

  TaskModel({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isDone,
  });
}
