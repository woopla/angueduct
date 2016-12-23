import 'package:angular2/core.dart';
import 'package:path/path.dart' as path;
import 'dart:html';
import 'dart:convert';

// Every Angular application has at least one component: the root component, named AppComponent here.
// Components are the basic building blocks of Angular applications. A component controls a portion of the screen—a view—through its associated template.
@Component(
    selector: 'my-app',
    templateUrl: "app_component.html")
class AppComponent {
  static const String baseURL = "http://127.0.0.1:8080/api";
  static const String baseURL = "http://127.0.0.1:8081/api";
  String title = "Quiz time!";
  List<Question> questions;

  AppComponent() {
    loadData();
  }

  // Based on https://webdev.dartlang.org/articles/get-data/json-web-service
  void loadData() {
    var url = path.join(baseURL, "questions");

    // Call the web server asynchronously
    var request = HttpRequest.getString(url).then(onDataLoaded);
  }

  void onDataLoaded(String responseText) {
    List dataFromJson = JSON.decode(responseText);

    questions = new List<Question>()..length = dataFromJson.length;
    for (var obj in dataFromJson) {
      questions.add(new Question.fromJSON(obj));
    }
  }
}

class Question {
  int id;
  String description;
  String answer;

  Question(this.id, this.description, this.answer);
  factory Question.fromJSON(Map<String, dynamic> qst) =>
    new Question(_toInt(qst['index']), qst['description'], qst['answer']);
  
  Map toJSON() => {'index': id, 'description': description, 'answer': answer};
}

int _toInt(id) => id is int ? id : int.parse(id);