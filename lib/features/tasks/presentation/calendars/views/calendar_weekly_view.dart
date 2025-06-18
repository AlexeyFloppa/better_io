import 'package:better_io/features/tasks/data/data_sources/task_data_source.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:better_io/features/tasks/presentation/calendars/view_models/calendars_view_model.dart';

class CalendarWeeklyView extends StatelessWidget {
  const CalendarWeeklyView({super.key});

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
                    view: CalendarView.week,
                    dataSource: TaskDataSource(viewModel.appointments),
                  ),
          );
        },
      ),
    );
  }
}
