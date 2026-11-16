import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/learning_repository.dart';

void main() => runApp(LearningApp(repository: AssetLearningRepository()));
