class GeneratedPlanModel {
  GeneratedPlanModel({
    required this.plan,
  });

  final List<Plan> plan;

  factory GeneratedPlanModel.fromJson(Map<String, dynamic> json) {
    return GeneratedPlanModel(
      plan: json["plan"] == null
          ? []
          : List<Plan>.from(json["plan"]!.map((x) => Plan.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$plan, ";
  }

  String debugPrint() {
    String plansString = '';
    for (Plan p in plan) {
      plansString += p.debugPrint();
    }
    return '''
    GeneratedPlanModel(plan: [$plansString]);
    ''';
  }
}

class Plan {
  Plan({
    required this.day,
    required this.summary,
    required this.tasks,
  });

  final int? day;
  final String? summary;
  final List<Task> tasks;

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      day: json["day"],
      summary: json["summary"],
      tasks: json["tasks"] == null
          ? []
          : List<Task>.from(json["tasks"]!.map((x) => Task.fromJson(x))),
    );
  }

  @override
  String toString() {
    return "$day, $summary, $tasks, ";
  }

  String debugPrint() {
    String tasksString = '';
    for (Task task in tasks) {
      tasksString += task.debugPrint();
    }
    return '''
    Plan(day: $day, summary: "$summary", tasks: [$tasksString]),
    ''';
  }
}

class Task {
  Task({
    required this.time,
    required this.task,
  });

  final String? time;
  final String? task;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      time: json["time"],
      task: json["task"],
    );
  }

  String get startTime {
    return time?.split('-').first ?? '';
  }

  String get endTime {
    return time?.split('-').last ?? '';
  }

  @override
  String toString() {
    return "$time, $task, ";
  }

  String debugPrint() {
    return '''
    Task(time: "$time", task: "$task"),
    ''';
  }
}
