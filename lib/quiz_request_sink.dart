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

  logger.onRecord.listen((rec) {
      String errStr;
      rec.error == null ? errStr = "" : errStr = " ::: ${rec.error.toString()}";
      print("${rec.level.name}: ${rec.time}: ${rec.message}${errStr}");
    });

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
    Response.addEncoder(io.ContentType.parse("application/javascript"), (j) => UTF8.decode(j));
    Response.addEncoder(io.ContentType.parse("text/*"), (j) => UTF8.decode(j));
    // This ain't working because HttpResponse.write will convert to a string no matter what.
    // Needs a way to use HttpResponse.add which takes data in whatever format it's in.
    Response.addEncoder(io.ContentType.parse("image/*"), (List<int> j) => new List<int>.from(j));
  }
}

// QuizConfiguration reads and validates the DB configuration from a YAML file
// See https://pub.dartlang.org/packages/safe_config for documentation of ConfigurationItem
class QuizConfiguration extends ConfigurationItem {
  QuizConfiguration(String fileName) : super.fromFile(fileName);

  DatabaseConnectionConfiguration database;
}
