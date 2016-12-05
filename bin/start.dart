// Tutorial @ https://stablekernel.github.io/aqueduct/tut/getting-started.html

import 'package:quiz/quiz.dart';

void main() {
  var config = new QuizConfiguration("config.yaml");
  var app = new Application<QuizRequestSink>()
    ..configuration.configurationOptions = {
      QuizRequestSink.ConfigurationKey : config
    };
    
  app.start();
}