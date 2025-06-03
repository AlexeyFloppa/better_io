import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

Widget origAppointmentBuilder(
  BuildContext context,
  CalendarAppointmentDetails calendarAppointmentDetails,
) {
  final Appointment appointment = calendarAppointmentDetails.appointments.first;
  return Container(
    width: calendarAppointmentDetails.bounds.width,
    height: calendarAppointmentDetails.bounds.height,
    child: Text(appointment.subject),
  );
}
