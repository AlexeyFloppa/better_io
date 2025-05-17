import 'package:better_io/features/tasks/data/models/hive_task_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// Add the controller as a parameter or get it from context if needed
Widget scheduleAppointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails calendarAppointmentDetails) {
    final HiveTaskModel appointment =
    calendarAppointmentDetails.appointments.first;
    return SizedBox(
      width: calendarAppointmentDetails.bounds.width,
      height: calendarAppointmentDetails.bounds.height,
      child: Center(
         child: Row(
          children: [
            const Icon(Icons.circle, size: 10, color: Colors.blue),
            const SizedBox(width: 5),
            Text(appointment.title, style: const TextStyle(fontSize: 16)),
          ],
         ),)
    );
}