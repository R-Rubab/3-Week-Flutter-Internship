import '../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({required super.title, required super.time, required super.date, super.isDone});

  Map<String, dynamic> toMap() {
    return {'title': title, 'time': time, 'date': date, 'isDone': isDone};
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      title: map['title'],
      time: map['time'],
      date: map['date'],
      isDone: map['isDone'],
    );
  }
}
