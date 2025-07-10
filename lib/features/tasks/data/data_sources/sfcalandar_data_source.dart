import 'package:syncfusion_flutter_calendar/calendar.dart';

class SfCalandarDataSource extends CalendarDataSource {
  SfCalandarDataSource(List<Appointment> source) {
    appointments = source;
  }
}
