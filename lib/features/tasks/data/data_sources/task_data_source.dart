import 'dart:ui';
import 'package:better_io/features/tasks/domain/usecases/hive/get_all_hive_tasks.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';

class TaskDataSource extends CalendarDataSource {
  final GetAllHiveTasksUseCase getAllHiveTasksUseCase;

  final Set<String> _loadedInstanceKeys = {};

  TaskDataSource(List<Task> tasks, this.getAllHiveTasksUseCase) {
    appointments = tasks.map(_taskToAppointment).toList();
    for (final task in tasks) {
      _loadedInstanceKeys.add(_generateInstanceKey(task));
    }
  }

  Appointment _taskToAppointment(Task task) {
    return Appointment(
      id: task.id,
      subject: task.title,
      startTime: task.startDate,
      endTime: task.endDate,
      color: task.color,
      isAllDay: task.isAllDay,
      notes: task.description,
      recurrenceRule: task.recurrenceRule,
    );
  }

  String _generateInstanceKey(Task task) =>
      '${task.id}_${task.startDate.toIso8601String()}';

  @override
  DateTime getStartTime(int index) => appointments![index].startTime;

  @override
  DateTime getEndTime(int index) => appointments![index].endTime;

  @override
  String getSubject(int index) => appointments![index].subject;

  @override
  Color getColor(int index) => appointments![index].color as Color;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay ?? false;
}
