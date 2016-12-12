import 'package:angular2/platform/browser.dart';
import 'package:aqueduct_angular/app_component.dart';

// Why create separate main.dart and app component files?
// App bootstrapping is a separate concern from presenting a view. 
// Testing the component is much easier if it doesn't also try to run the entire application.
void main() {
  bootstrap(AppComponent);
}
