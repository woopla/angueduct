import 'package:aqueduct/aqueduct.dart';
import 'dart:async';

class Migration1 extends Migration {
  Future upgrade() async {
    database.createTable(new SchemaTable("_Question", [
      new SchemaColumn("index", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("description", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
    ]));

    database.createTable(new SchemaTable("_Answer", [
      new SchemaColumn("id", ManagedPropertyType.bigInteger, isPrimaryKey: true, autoincrement: true, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn("description", ManagedPropertyType.string, isPrimaryKey: false, autoincrement: false, isIndexed: false, isNullable: false, isUnique: false),
      new SchemaColumn.relationship("question", ManagedPropertyType.bigInteger, relatedTableName: "_Question", relatedColumnName: "index", rule: ManagedRelationshipDeleteRule.cascade, isNullable: false, isUnique: true),
    ]));

  }

  Future downgrade() async {
  }
  Future seed() async {
    var questions = [
      "How much wood can a woodchuck chuck?",
      "What's the tallest mountain in the world?"
    ];
    var answersIterator = [
      "Depends on if they can",
      "Mount Everest"
    ].iterator;

    for (var question in questions) {
      var insertedQuestionRows = await store
        .execute("INSERT INTO _question (description) VALUES (@desc) RETURNING index",
          substitutionValues: {
            "desc" : question
          }) as List<List<int>>;

      answersIterator.moveNext();
      await store
        .execute("INSERT INTO _answer (description, question_index) VALUES (@desc, @idx)",
          substitutionValues: {
            "desc" : answersIterator.current,
            "idx" : insertedQuestionRows.first.first
          });
    }
  }
}
