import 'package:flutter_test/flutter_test.dart';
import 'package:week3_task_manager/data/models/task_model.dart';

void main() {
  test('TaskModel serialization round-trip works', () {
    final task = TaskModel(
      title: 'Prepare weekly report',
      time: '09:00 AM',
      date: 'Mon 27/4/2026',
      isDone: true,
    );

    final map = task.toMap();
    final restored = TaskModel.fromMap(map);

    expect(restored.title, task.title);
    expect(restored.time, task.time);
    expect(restored.date, task.date);
    expect(restored.isDone, task.isDone);
  });
}
