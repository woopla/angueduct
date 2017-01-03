// Tutorial @ https://stablekernel.github.io/aqueduct/tut/getting-started.html

import 'package:aqueduct_angular/quiz.dart';

void main() {
  var config = new QuizConfiguration("config.yaml");
  var app = new Application<QuizRequestSink>()
    ..configuration.configurationOptions = {
      QuizRequestSink.ConfigurationKey : config
    }
    ..configuration.port = 8081;
    
  app.start();
}