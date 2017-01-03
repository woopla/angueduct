// Tutorial @ https://stablekernel.github.io/aqueduct/tut/getting-started.html

import 'package:aqueduct_angular/quiz.dart';

void main() {
  var config = new QuizConfiguration("config.yaml");
  // Server runs on 8081 instead of the 8080 default to allow 'pub serve web/' for Frontend debugging.
  var app = new Application<QuizRequestSink>()
    ..configuration.configurationOptions = {
      QuizRequestSink.ConfigurationKey: config
    }
    ..configuration.port = 8081;

  app.start();
}
