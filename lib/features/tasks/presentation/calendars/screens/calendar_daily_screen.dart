import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:better_io/features/tasks/presentation/calendars/view_models/calendars_view_model.dart';

class CalendarDailyScreen extends StatelessWidget {
  const CalendarDailyScreen({super.key});

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
                    view: CalendarView.day,
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
