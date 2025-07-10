import 'package:better_io/features/tasks/data/models/task_model.dart';
import 'package:better_io/features/tasks/data/repositories/task_repository.dart';
import 'package:better_io/features/tasks/domain/entities/task.dart';
import 'package:better_io/features/tasks/domain/usecases/task/get_recurrency.dart';
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
      '${TimeOfDay.fromDateTime(startTime.toLocal()).format(context)} - '
      '${TimeOfDay.fromDateTime(endTime.toLocal()).format(context)}',
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
    return Text(
      subject,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class AppointmentDescriptionText extends StatelessWidget {
  final String description;
  final TextStyle? style;
  const AppointmentDescriptionText(
      {required this.description, this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
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

class AppointmentTimeStatusText extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final TextStyle? style;
  final TextStyle? nowColor;
  final TextStyle? laterColor;
  final TextStyle? beforeColor;
  const AppointmentTimeStatusText({
    this.style,
    this.nowColor,
    this.laterColor,
    this.beforeColor,
    required this.startTime,
    required this.endTime,
    super.key,
  });
  Text _getStatus(BuildContext context) {
    final now = DateTime.now();
    final ongoingStyle = style?.copyWith(color: nowColor?.color ?? Colors.blue);
    final upcomingStyle =
        style?.copyWith(color: laterColor?.color ?? Colors.grey);
    final endedStyle = style?.copyWith(color: beforeColor?.color ?? Colors.red);

    if (now.isBefore(startTime)) {
      return Text('Upcoming',
          style: upcomingStyle ?? TextStyle(color: Colors.grey));
    } else if (now.isAfter(endTime)) {
      return Text('Ended', style: endedStyle ?? TextStyle(color: Colors.red));
    } else {
      return Text('Ongoing',
          style: ongoingStyle ?? TextStyle(color: Colors.blue));
    }
  }

  @override
  Widget build(BuildContext context) {
    return _getStatus(context);
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
  final Task task;
  const MobileAppointmentBuilder({
    required this.appointment,
    required this.task,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppointmentSubjectText(
                subject: appointment.subject,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 8),
              AppointmentColorIndicator(color: appointment.color),
              const Spacer(),
              AppointmentTimeStatusText(
                startTime: appointment.startTime,
                endTime: appointment.endTime,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppointmentTimeText(
                startTime: appointment.startTime,
                endTime: appointment.endTime,
                style: const TextStyle(fontSize: 14),
              ),
              const Spacer(),
              AppointmentPriorityText(priority: task.priority),
            ],
          ),
        ],
      ),
    );
  }
}

class DesktopAppointmentBuilder extends StatelessWidget {
  final dynamic appointment;
  final Task task;
  const DesktopAppointmentBuilder({
    required this.appointment,
    required this.task,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppointmentColorIndicator(color: appointment.color),
          const AppointmentSectionGap(),
          SizedBox(
            width: 135,
            child: AppointmentTimeText(
              startTime: appointment.startTime,
              endTime: appointment.endTime,
            ),
          ),
          const AppointmentSectionGap(),
          Expanded(
            flex: 1,
            child: AppointmentSubjectText(subject: appointment.subject),
          ),
          const AppointmentSectionGap(),
          Expanded(
            flex: 3,
            child: AppointmentDescriptionText(
              description: task.description,
            ),
          ),
          const AppointmentSectionGap(),
          IntrinsicWidth(
            child: AppointmentPriorityText(priority: task.priority),
          ),
          const AppointmentSectionGap(),
          SizedBox(
            width: 70,
            child: AppointmentTimeStatusText(
              startTime: appointment.startTime,
              endTime: appointment.endTime,
            ),
          ),
        ],
      ),
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

  final taskBox = Hive.box<TaskModel>('tasks');
  final repository = TaskRepository(taskBox);
  final GetRecurrencyUseCase getTaskUseCase =
      GetRecurrencyUseCase(repository, appointmentId);
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
          child: Text('Error: \${snapshot.error}'),
        );
      } else if (snapshot.hasData) {
        final task = snapshot.data!;
        final isMobile = screenWidth < 600;
        return isMobile
            ? MobileAppointmentBuilder(
                appointment: appointment,
                task: task,
              )
            : DesktopAppointmentBuilder(
                appointment: appointment,
                task: task,
              );
      } else {
        return const SizedBox(child: Text('No data available'));
      }
    },
  );
}
