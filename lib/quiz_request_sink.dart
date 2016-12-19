part of quiz;

// RequestSunk is one of the base classes in the Aqueduct pipeline
class QuizRequestSink extends RequestSink {
  // Configuration loaded by Dart library safe_config also from Stable|Kernel
  static String ConfigurationKey = "QuizRequestSink.Configuration";
  final Logger log = new Logger('QuizRequestSink');

  QuizRequestSink(Map<String, dynamic> options) : super(options) {
    var dataModel = new ManagedDataModel.fromCurrentMirrorSystem();


    var config = options[ConfigurationKey];
    var db = config.database;
    var persistentStore = new PostgreSQLPersistentStore.fromConnectionInfo(db.username, db.password, db.host, db.port, db.databaseName);

    logger.onRecord.listen((rec) => print("${rec.level.name}: ${rec.time}: ${rec.message} ::: ${rec.error.toString()}"));

    context = new ManagedContext(dataModel, persistentStore);
  }

  ManagedContext context;

  @override
  void setupRouter(Router router) {
    router
      .route("/api/questions/[:index(\\d+)]")
      .generate(() => new QuestionController());

    // Catch-all for static files
    router
      .route("/*")
      .generate(() => new StaticFilesController());
    Response.addEncoder(io.ContentType.parse("application/javascript"), (j) => j.toString());
  }
}

// QuizConfiguration reads and validates the DB configuration from a YAML file
// See https://pub.dartlang.org/packages/safe_config for documentation of ConfigurationItem
class QuizConfiguration extends ConfigurationItem {
  QuizConfiguration(String fileName) : super.fromFile(fileName);

  DatabaseConnectionConfiguration database;
}
