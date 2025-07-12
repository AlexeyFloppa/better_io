import 'package:syncfusion_flutter_calendar/calendar.dart';

class SfCalendarDataSource extends CalendarDataSource {
  SfCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}
