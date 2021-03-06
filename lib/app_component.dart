import 'package:angular2/core.dart';
import 'package:path/path.dart' as path;
import 'dart:html';
import 'dart:convert';
import 'table_component.dart';

// Every Angular application has at least one component: the root component, named AppComponent here.
// Components are the basic building blocks of Angular applications. A component controls a portion of the screen—a view—through its associated template.
@Component(
    selector: 'my-app',
    templateUrl: "app_component.html",
    directives: const [TableComponent])
class AppComponent implements OnInit {
  static const String baseURL = "http://127.0.0.1:8081/api";
  String title = "Quiz time!";
  List<Question> _questions;
  List<List<dynamic>> tableData = [];
  final List<String> columns = ["Index", "Description", "Answer"];

  // OnInit is The AngularDart Way of doing things when loading data from a remote location
  void ngOnInit() {
    loadData();
  }

  // Use a getter to hide internal list in case we want to get smarter later on
  List<Question> get questions => _questions;

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

    for (Question question in _questions) {
      tableData.add(question.toList());
    }
  }
}

class Question {
  int id;
  String description;
  String answer;

  Question(this.id, this.description, this.answer);
  factory Question.fromJSON(Map<String, dynamic> qst) => new Question(
      _toInt(qst['index']), qst['description'], qst['answer']['description']);

  Map toJSON() => {'index': id, 'description': description, 'answer': answer};
  // toList() is used to convert the object to a list suitable for TableComponent
  List toList() => [id, description, answer];
}

int _toInt(id) => id is int ? id : int.parse(id);
