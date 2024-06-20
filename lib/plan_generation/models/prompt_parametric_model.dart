import 'package:planner/plan_generation/models/priority_model.dart';
import 'package:planner/utils/time_formatter.dart';
import 'package:progressive_time_picker/progressive_time_picker.dart';

class PromptParametricModel {
  PromptParametricModel({
    required this.title,
    required this.days,
    required this.hoursInDay,
    required this.preferredStartTime,
    required this.preferredEndTime,
    required this.priority,
    required this.details,
  });

  String title;
  int days;
  int hoursInDay;
  PickedTime preferredStartTime;
  PickedTime preferredEndTime;
  Priority priority;
  String details;

  String get preferredStartTime_s {
    return getFormattedTime(preferredStartTime);
  }

  String get preferredEndTime_s {
    return getFormattedTime(preferredEndTime);
  }

  String get priority_s {
    return priority.name;
  }
}
