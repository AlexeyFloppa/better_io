import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:better_io/features/tasks/presentation/calendars/view_models/calendars_view_model.dart';

class CalendarMonthlyScreen extends StatelessWidget {
  const CalendarMonthlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarsViewModel(),
      child: Consumer<CalendarsViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SfCalendar(
                    headerHeight: 0,
                    view: CalendarView.month,
                    dataSource: TaskCalendarDataSource(viewModel.appointments),
                  ),
          );
        },
      ),
    );
  }
}

class TaskCalendarDataSource extends CalendarDataSource {
  TaskCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}
