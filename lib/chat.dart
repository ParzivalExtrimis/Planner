import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

Future<String?> chatHandle() async {
  // Set the OpenAI API key from the .env file.
  OpenAI.apiKey = 'sk-proj-NCMwg5jE0oo5nomI9a12T3BlbkFJJlvfsvDvQRloqjY59sWH';

  // Start using!
  final response = await OpenAI.instance.chat.create(
    model: "gpt-4o",
    maxTokens: 200,
    temperature: 0.4,
    messages: [
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.system,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              'You are a helpful assistant.')
        ],
      ),
      OpenAIChatCompletionChoiceMessageModel(
        role: OpenAIChatMessageRole.user,
        content: [
          OpenAIChatCompletionChoiceMessageContentItemModel.text(
              'What do you know about GPT 4 Omni?'),
        ],
      ),
    ],
  );

  print(response);
  return response.choices[0].message.content?.first.text;
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: const BorderSide(
                color: Colors.black54, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(12)),
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: FutureBuilder(
                future: chatHandle(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState == ConnectionState.done ||
                      snapshot.connectionState == ConnectionState.none) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        child: Text(
                          snapshot.data!,
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                  }
                  return const Text('Could not get response',
                      style: TextStyle(fontSize: 18));
                }),
          ),
        ),
      ),
    );
  }
}
