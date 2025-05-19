// Flutter and third-party imports
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/helpers/repeat_helper.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/get_nearest_to_date_hive_tasks.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer'; // For debugging

// Feature-specific imports
import 'package:better_io/features/tasks/data/data_sources/task_data_source.dart';
import 'package:better_io/features/tasks/data/models/hive_task_model.dart';
import 'package:better_io/features/tasks/data/repositories/hive_task_repository.dart';

// Main widget for the weekly calendar screen
class CalendarWeeklyScreen extends StatefulWidget {
  const CalendarWeeklyScreen({super.key});

  @override
  State<CalendarWeeklyScreen> createState() => _CalendarWeeklyScreenState();
}

class _CalendarWeeklyScreenState extends State<CalendarWeeklyScreen> with RouteAware {
  // Variables
  TaskDataSource? _taskDataSource; // Nullable to handle uninitialized state
  late final GetTasksByDateUseCase _getTasksByDateUseCase;
  late final RepeatHelper _repeatHelper; // Assuming this is defined somewhere

  // Lifecycle: Initialize the screen
  @override
  void initState() {
    super.initState();
    log('CalendarWeeklyScreen initialized');
    _initializeUseCase(); // Initialize domain logic
    _initializeDataSource(); // Load data
  }

  // Initialize the use case (domain logic)
  void _initializeUseCase() {
    final taskBox = Hive.box<HiveTaskModel>('tasks'); // Assume the box is already opened
    final repository = HiveTaskRepository(taskBox);
    _repeatHelper = RepeatHelper(); // Initialize the repeat helper
    // _getAllTasksUseCase = GetAllTasksUseCase(repository);
    _getTasksByDateUseCase = GetTasksByDateUseCase(repository, _repeatHelper);
  }

  // Load tasks and map them to calendar appointments
  Future<void> _initializeDataSource() async {
    // final tasks = await _getTasksByDateUseCase.execute(taskAmount: 20);
    List<Task> tasks = [];

    setState(() {
      _taskDataSource = TaskDataSource(tasks, _getTasksByDateUseCase);
      _taskDataSource!.handleLoadMore(DateTime.now(), DateTime.now().add(const Duration(days: 7)));
    });
  }

  // Build the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _taskDataSource == null
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator
          : _buildCalendar(),
    );
  }

  // Build the calendar widget
  Widget _buildCalendar() {
    return SfCalendar(
      headerHeight: 0,
      view: CalendarView.week,
      dataSource: _taskDataSource,
      loadMoreWidgetBuilder: _buildLoadMoreWidget,
    );
  }

  Widget _buildLoadMoreWidget(BuildContext context, LoadMoreCallback loadMoreAppointments) {
    return FutureBuilder<void>(
      future: loadMoreAppointments(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
