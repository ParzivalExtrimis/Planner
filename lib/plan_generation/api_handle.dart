import 'dart:convert';

import 'package:dart_openai/dart_openai.dart';
import 'package:planner/plan_generation/models/generated_plan_model.dart';
import 'package:planner/plan_generation/models/prompt_parametric_model.dart';

class ApiHandle {
  ApiHandle._();

  // TODO: Move aip-key to env file. Required before making repo public
  // https://pub.dev/packages/dart_openai

  static void init() {
    OpenAI.apiKey =
        '9dtY50y0TLjCXZDYpnVcZrFZlyxPhdxOcW5rDJZI8oVRTT5RQ84gJQQJ99ALAC77bzfXJ3w3AAABACOGdM2d';
  }

  static Future<GeneratedPlanModel?> resolve(
      PromptParametricModel inputModel) async {
    init();
    Map<String, String> inputPrompt = _parseToPrompt(inputModel);
    String? resultJson = await _chatHandle(inputPrompt);
    return _parseToResult(resultJson);
  }

  static Map<String, String> _parseToPrompt(PromptParametricModel inputModel) {
    // SYSTEM
    String systemPrompt = '''
    You are an expert at using instructions provided to you
    ( constraints and details ) and producing a plan to complete
    the task and produce JSON outputs in the form
    {
      "plan": [
        {
          "day": 1,
          "summary":  "-- summary of daily tasks --",

          "tasks": [
            {
              "time": "09:00-09:30",
              "task": "Do task 1"
            },
            {
              "time": "09:00-09:30",
              "task": "Do task 2"
            },
            <... any number of required tasks> 
          ]
        },
        {
          "day": 2,
          "summary":  "-- summary of daily tasks --", 
          "tasks": [
            {
              "time": "09:00-09:30",
              "task": "Do task 3"
            },
            {
              "time": "09:00-09:30",
              "task": "Do task 4"
            },
            <... any number of required tasks>
          ]
        },
        <... for the number of days>
      ]
    }
    The summary section is no more than 30 words. Include a summary of the day's tasks with a bit of explanation or tips of the same 
    DO NOT ADD ANYTHING ELSE IN THE RESPONSE BUT A JSON OF THE ABOVE FORMAT
    ''';

    // USER
    String userPrompt = '''
    Title: ${inputModel.title}
    Allotted time: ${inputModel.days} days
    Daily allotment: ${inputModel.hoursInDay} hours per day
    Preferred work hours: Between ${inputModel.preferredStartTime_s} and ${inputModel.preferredEndTime_s}
    Priority: ${inputModel.priority_s}

    Details: ${inputModel.details} 

    [You need to generate a plan to complete the above tasks
    based on the constraints provided.]
    ''';

    return {'system': systemPrompt, 'user': userPrompt};
  }

  static Future<String?> _chatHandle(Map<String, String> inputPrompt) async {
    // the system message that will be sent to the request.
    final systemMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          inputPrompt['system']!,
        ),
      ],
      role: OpenAIChatMessageRole.assistant,
    );

    // the user message that will be sent to the request.
    final userMessage = OpenAIChatCompletionChoiceMessageModel(
      content: [
        OpenAIChatCompletionChoiceMessageContentItemModel.text(
          inputPrompt['user']!,
        ),
      ],
      role: OpenAIChatMessageRole.user,
    );

    // all messages to be sent.
    final requestMessages = [
      systemMessage,
      userMessage,
    ];

    // the actual request.
    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
      model: "gpt-4o",
      responseFormat: {"type": "json_object"},
      messages: requestMessages,
      temperature: 0.2,
    );
    return chatCompletion.choices.first.message.content?.first.text;
  }

  static GeneratedPlanModel? _parseToResult(String? resultJson) {
    if (resultJson == null) {
      return null;
    }
    return GeneratedPlanModel.fromJson(const JsonDecoder().convert(resultJson));
  }
}
