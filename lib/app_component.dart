import 'package:angular2/core.dart';
import 'package:path/path.dart' as path;

// Every Angular application has at least one component: the root component, named AppComponent here.
// Components are the basic building blocks of Angular applications. A component controls a portion of the screen—a view—through its associated template.
@Component(
    selector: 'my-app',
    templateUrl: "app_component.html")
class AppComponent {
  static const String baseURL = "http://127.0.0.1:8080/api";

  // Based on https://webdev.dartlang.org/articles/get-data/json-web-service
  void loadData() {
    var url = path.join(baseURL, "questions");

    // Call the web server asynchronously
    var request = HttpRequest.getString(url).then(onDataLoaded);
  }

  void onDataLoaded(String responseText) {
    var jsonString = responseText;
    print(jsonString);
  }
}
