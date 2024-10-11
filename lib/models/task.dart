// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  Task({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.createAtTime,
    required this.createAtDate,
    required this.isCompleted,
  });

  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String subTitle;
  @HiveField(3)
  DateTime createAtTime;
  @HiveField(4)
  DateTime createAtDate;
  @HiveField(5)
  bool isCompleted;

  factory Task.create({
    required String? title,
    required String? subTitle,
    DateTime? createAtTime,
    DateTime? createAtDate,
  }) =>
      Task(
        id: const Uuid().v1(),
        title: title ?? "",
        subTitle: subTitle ?? "",
        createAtTime: createAtTime ?? DateTime.now(),
        createAtDate: createAtDate ?? DateTime.now(),
        isCompleted: false,
      );
}
