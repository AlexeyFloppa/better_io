import 'dart:developer';
import 'dart:ui'; // Import for the Color class
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/get_nearest_to_date_hive_tasks.dart';

/// Data source for managing tasks in the calendar.
/// Converts `Task` entities into `Appointment` objects for display.
class TaskDataSource extends CalendarDataSource {
  final GetTasksByDateUseCase getTasksByDateUseCase;

  /// Constructor to initialize the data source with a list of appointments.
  TaskDataSource(List<Task> tasks, this.getTasksByDateUseCase) {
    appointments = tasks.map(_taskToAppointment).toList();
    this.appointments = appointments;
  }

  /// Converts a `Task` entity into an `Appointment` object.
  Appointment _taskToAppointment(Task task) {
    log('Converting Task to Appointment: ${task.id}');
    return Appointment(
      id: task.id,
      subject: task.title,
      startTime: task.startDate,
      endTime: task.endDate,
      color: task.color,
      isAllDay: task.isAllDay,
    );
  }

  // CalendarDataSource overrides for accessing appointment properties.

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

  /// Handles loading more data when the calendar requests it.
  @override
  Future<void> handleLoadMore(DateTime startDate, DateTime endDate) async {
    log('Loading more data from $startDate to $endDate');

    if (appointments!.isNotEmpty) {
      log(appointments!.last.startTime.toString());
    }
    // Fetch additional tasks using the domain use case
    final newTasks = await getTasksByDateUseCase.execute(
      startDate: appointments!.isNotEmpty ? appointments!.last.startTime : startDate,
      startTaskId: appointments!.isNotEmpty ? appointments!.last.id : null,
      taskAmount: 20, // Load 20 tasks at a time
    );

    final newAppointments = newTasks.map(_taskToAppointment).toList();

    appointments!.addAll(newAppointments);
    notifyListeners(CalendarDataSourceAction.add, newAppointments);
  }
}
