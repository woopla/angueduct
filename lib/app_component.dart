import 'package:angular2/core.dart';
import 'package:path/path.dart' as path;
import 'dart:html';
import 'dart:convert';

// Every Angular application has at least one component: the root component, named AppComponent here.
// Components are the basic building blocks of Angular applications. A component controls a portion of the screen—a view—through its associated template.
@Component(
    selector: 'my-app',
    templateUrl: "app_component.html")
class AppComponent implements OnInit {
  static const String baseURL = "http://127.0.0.1:8080/api";
  String title = "Quiz time!";
  List<Question> _questions;

  // OnInit is The AngularDart Way of doing things when loading data from a remote location
  void ngOnInit() {
    loadData();
  }

  // Use a getter to hide internal list in case we want to get smarter later on
  List<Question> get questions => _questions;

  int trackByQuestions(int index, Question question) => question.id;

  // Based on https://webdev.dartlang.org/articles/get-data/json-web-service
  void loadData() {
    var url = path.join(baseURL, "questions");

    // Call the web server asynchronously
    HttpRequest.getString(url).then(onDataLoaded);
  }

  void onDataLoaded(String responseText) {
    List dataFromJson = JSON.decode(responseText);

    _questions = new List<Question>();
    for (var obj in dataFromJson) {
      _questions.add(new Question.fromJSON(obj));
    }
  }
}

class Question {
  int id;
  String description;
  String answer;

  Question(this.id, this.description, this.answer);
  factory Question.fromJSON(Map<String, dynamic> qst) =>
    new Question(_toInt(qst['index']), qst['description'], qst['answer']['description']);
  
  Map toJSON() => {'index': id, 'description': description, 'answer': answer};
}

int _toInt(id) => id is int ? id : int.parse(id);