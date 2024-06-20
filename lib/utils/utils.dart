import 'dart:developer';

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => log(
        match.group(0) ?? '',
      ));
}
