import 'package:angular2/core.dart';
import 'dart:core';

@Component(selector: 'ng-table', templateUrl: "table_component.html")
class TableComponent {
  @Input()
  List<List<dynamic>> tableData;
  @Input()
  List<String> columnNames;
  @Input()
  bool showIDs = false;

  // Used by ngForTrackBy in the HTML template code
  int trackByRow(int index, List<dynamic> row) => row[0];
}
