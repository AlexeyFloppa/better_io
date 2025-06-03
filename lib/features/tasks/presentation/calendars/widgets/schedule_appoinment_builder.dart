import 'package:better_io/features/tasks/data/models/hive_task_model.dart';
import 'package:better_io/features/tasks/data/repositories/hive_task_repository.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/get_all_hive_tasks.dart';
import 'package:better_io/features/tasks/domain/usecases/hive/get_hive_task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentColorIndicator extends StatelessWidget {
  final Color color;
  const AppointmentColorIndicator({required this.color, Key? key})
      : super(key: key);

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
  const AppointmentTimeText(
      {required this.startTime, required this.endTime, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${TimeOfDay.fromDateTime(startTime).format(context)} - '
      '${TimeOfDay.fromDateTime(endTime).format(context)}',
    );
  }
}

class AppointmentSubjectText extends StatelessWidget {
  final String subject;
  const AppointmentSubjectText({required this.subject, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(subject);
  }
}

class AppointmentDescriptionText extends StatelessWidget {
  final String Description;
  const AppointmentDescriptionText({required this.Description, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(Description);
  }
}

class AppointmentPriorityText extends StatelessWidget {
  final String Priority;
  const AppointmentPriorityText({required this.Priority, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(Priority);
  }
}

class AppointmentSectionGap extends StatelessWidget {
  final double width;
  const AppointmentSectionGap({this.width = 24, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

Widget scheduleAppointmentBuilder(
  BuildContext context,
  CalendarAppointmentDetails calendarAppointmentDetails,
) {
  final appointment = calendarAppointmentDetails.appointments.first;
  final String appointmentId = appointment.id.toString(); // <-- use String

  final taskBox = Hive.box<HiveTaskModel>('tasks');
  final repository = HiveTaskRepository(taskBox);
  final GetHiveTaskUseCase getTaskUseCase =
      GetHiveTaskUseCase(repository, appointmentId);
  final Future<Task> taskFuture = getTaskUseCase.execute();

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
          child: Container(
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
                AppointmentDescriptionText(Description: task.description),
                const AppointmentSectionGap(),
                AppointmentPriorityText(Priority: task.priority),
                const AppointmentSectionGap(),
              ],
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    },
  );
}
