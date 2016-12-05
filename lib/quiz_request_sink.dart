part of quiz;

// RequestSunk is one of the base classes in the Aqueduct pipeline
class QuizRequestSink extends RequestSink {
  // Configuration loaded by Dart library safe_config
  static String ConfigurationKey = "QuizRequestSink.Configuration";

  QuizRequestSink(Map<String, dynamic> options) : super(options) {
    var dataModel = new ManagedDataModel.fromPackageContainingType(QuizRequestSink);

    var config = options[ConfigurationKey];
    var db = config.database;
    var persistentStore = new PostgreSQLPersistentStore.fromConnectionInfo(db.username, db.password, db.host, db.port, db.databaseName);

    context = new ManagedContext(dataModel, persistentStore);
  }

  ManagedContext context;

  @override
  void setupRouter(Router router) {
    router
      .route("/questions/[:index(\\d+)]")
      .generate(() => new QuestionController());
  }
}

// QuizConfiguration reads and validates the DB configuration from a YAML file
// See https://pub.dartlang.org/packages/safe_config for documentation of ConfigurationItem
class QuizConfiguration extends ConfigurationItem {
  QuizConfiguration(String fileName) : super.fromFile(fileName);

  DatabaseConnectionConfiguration database;
}
