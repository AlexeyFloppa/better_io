
import 'package:better_io/features/tasks/data/models/hive_task_model.dart';
import 'package:better_io/features/tasks/data/repositories/hive_task_repository.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/get_hive_recurrency.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentColorIndicator extends StatelessWidget {
  final Color color;
  const AppointmentColorIndicator({required this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 7,
    );
  }
}

class AppointmentTimeText extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final TextStyle? style;
  const AppointmentTimeText({
    required this.startTime,
    required this.endTime,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${TimeOfDay.fromDateTime(startTime).format(context)} - '
      '${TimeOfDay.fromDateTime(endTime).format(context)}',
      style: style,
    );
  }
}

class AppointmentSubjectText extends StatelessWidget {
  final String subject;
  final TextStyle? style;
  const AppointmentSubjectText({required this.subject, this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(subject, style: style);
  }
}

class AppointmentDescriptionText extends StatelessWidget {
  final String description;
  final TextStyle? style;
  const AppointmentDescriptionText(
      {required this.description, this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(description, style: style);
  }
}

class AppointmentPriorityText extends StatelessWidget {
  final String priority;
  final TextStyle? style;
  const AppointmentPriorityText(
      {required this.priority, this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(priority, style: style);
  }
}

class AppointmentSectionGap extends StatelessWidget {
  final double width;
  const AppointmentSectionGap({this.width = 24, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

class MobileAppointmentBuilder extends StatelessWidget {
  final dynamic appointment;
  final Future<Task> taskFuture;
  const MobileAppointmentBuilder({
    required this.appointment,
    required this.taskFuture,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Task>(
      future: taskFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final task = snapshot.data!;
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First row: Title (left), Priority, Color (right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child:
                          Row(
                            children: [
                              AppointmentSubjectText(subject: appointment.subject, style: TextStyle(fontSize: 18)),
                              SizedBox(width: 8),
                              AppointmentColorIndicator(color: appointment.color),
                            ],
                          ),
                    ),
                    AppointmentPriorityText(priority: task.priority),

                  ],
                ),
                const SizedBox(height: 0),
                // Second row: Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppointmentTimeText(
                      startTime: appointment.startTime,
                      endTime: appointment.endTime,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const SizedBox(child: Text('No data available'));
        }
      },
    );
  }
}

class DesktopAppointmentBuilder extends StatelessWidget {
  final dynamic appointment;
  final Future<Task> taskFuture;
  const DesktopAppointmentBuilder({
    required this.appointment,
    required this.taskFuture,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Task>(
      future: taskFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SizedBox(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final task = snapshot.data!;
          return SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppointmentColorIndicator(color: appointment.color),
                const AppointmentSectionGap(),
                AppointmentTimeText(
                  startTime: appointment.startTime,
                  endTime: appointment.endTime,
                ),
                const AppointmentSectionGap(),
                AppointmentSubjectText(subject: appointment.subject),
                const AppointmentSectionGap(),
                AppointmentDescriptionText(description: task.description),
                const AppointmentSectionGap(),
                AppointmentPriorityText(priority: task.priority),
                const AppointmentSectionGap(),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

Widget scheduleAppointmentBuilder(
  BuildContext context,
  CalendarAppointmentDetails calendarAppointmentDetails,
) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final appointment = calendarAppointmentDetails.appointments.first;
  final String appointmentId = appointment.id.toString();

  final taskBox = Hive.box<HiveTaskModel>('tasks');
  final repository = HiveTaskRepository(taskBox);
  final GetHiveRecurrencyUseCase getTaskUseCase =
      GetHiveRecurrencyUseCase(repository, appointmentId);
  final Future<Task> taskFuture = getTaskUseCase.execute();

  if (screenWidth < 600) {
    return MobileAppointmentBuilder(
      appointment: appointment,
      taskFuture: taskFuture,
    );
  } else {
    return DesktopAppointmentBuilder(
      appointment: appointment,
      taskFuture: taskFuture,
    );
  }
}
