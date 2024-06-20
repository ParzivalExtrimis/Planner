import 'package:progressive_time_picker/progressive_time_picker.dart';

String getFormattedTime(PickedTime time) {
  String hr = time.h > 9 ? time.h.toString() : '0${time.h}';
  String min = time.m > 9 ? time.m.toString() : '0${time.m}';

  return '$hr:$min';
}
