import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'dart:core';

@Component(
    selector: 'ng-table',
    templateUrl: "table_component.html",
    styleUrls: const ['table_component.css'],
    // material{Directives,Providers} are required to use the angular2_components module
    directives: const [materialDirectives],
    providers: const [materialProviders])
class TableComponent {
  // tableData contains the per-row information.
  @Input()
  List<List<dynamic>> tableData;
  // columnNames contains the data for the table <thead> section
  @Input()
  List<String> columnNames;
  // showIDs controls the visibility of the indices column (the first one)
  @Input()
  bool showIDs = false;

  // incrOrdering contains the per-column sorting order
  List<bool> incrOrdering;

  void onClick(String column, [bool increasing]) {
    // Let's default to increasing order on first click.
    if (incrOrdering == null) {
      incrOrdering =
          new List<bool>.filled(columnNames.length, true, growable: true);
    }

    int idx = columnNames.indexOf(column);

    // If nothing is provided in the call, let's see what we have in the ordering table
    if (increasing != null) {
      incrOrdering[idx] = increasing;
    }

    // Is there a more idiomatic way to do this in Dart? I don't like the almost repeating code here...
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
