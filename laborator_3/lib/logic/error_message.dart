import 'package:flutter/foundation.dart';

/// Transformă o excepție într-un mesaj scurt, afișat în starea Error.
String describeError(Object error) => switch (error) {
  FormatException(:final message) => 'The JSON data is not valid. $message',
  FlutterError() => 'The data file could not be read.',
  _ => 'Something went wrong: $error',
};
