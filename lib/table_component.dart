import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'dart:core';

@Component(
    selector: 'ng-table',
    templateUrl: "table_component.html",
    // material{Directives,Providers} are required to use the angular2_components module
    directives: const [materialDirectives],
    providers: const [materialProviders])
class TableComponent {
  @Input()
  List<List<dynamic>> tableData;
  @Input()
  List<String> columnNames;
  @Input()
  bool showIDs = false;

  List<bool> incrOrdering;

  void onClick(String column) {
    if (incrOrdering == null) {
      incrOrdering =
          new List<bool>.filled(columnNames.length, true, growable: true);
    }
    int idx = columnNames.indexOf(column);
    // TODO: Figure out why the table is not updated in the DOM - the sorting works fine...
    if (incrOrdering[idx]) {
      incrOrdering[idx] = false;
      tableData
          .sort((List<dynamic> a, List<dynamic> b) => a[idx].compareTo(b[idx]));
    } else {
      incrOrdering[idx] = true;
      tableData
          .sort((List<dynamic> a, List<dynamic> b) => b[idx].compareTo(a[idx]));
    }
  }

  // Used by ngForTrackBy in the HTML template code
  int trackByRow(int index, List<dynamic> row) => row[0];
}
