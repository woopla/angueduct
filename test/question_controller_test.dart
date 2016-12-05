import 'package:test/test.dart';
import 'package:quiz/quiz.dart';

void main() {
  var config = new QuizConfiguration("config.yaml.src");
  var app = new Application<QuizRequestSink>()
    ..configuration.configurationOptions = {
      QuizRequestSink.ConfigurationKey : config
    };
    
  var client = new TestClient(app);

  setUpAll(() async {
    await app.start(runOnMainIsolate: true);

    var ctx = ManagedContext.defaultContext;
    var builder = new SchemaBuilder.toSchema(ctx.persistentStore, new Schema.fromDataModel(ctx.dataModel), isTemporary: true);

    for (var cmd in builder.commands) {
      await ctx.persistentStore.execute(cmd);
    }

    var questions = [
      "How much wood can a woodchuck chuck?",
      "What's the tallest mountain in the world?"
    ];
    var answersIterator = [
      "Depends on if they can",
      "Mount Everest"
    ].iterator;

    for (var question in questions) {
      var insertQuery = new Query<Question>()
        ..values.description = question;
        question = await insertQuery.insert();

      answersIterator.moveNext();
      insertQuery = new Query<Answer>()
        ..values.description = answersIterator.current
        ..values.question = question;
      await insertQuery.insert();
    }
  });

  tearDownAll(() async {
    await ManagedContext.defaultContext.persistentStore.close();
    await app.stop();
  });

  test("/questions returns list of questions", () async {
    var response = await client.request("/questions").get();
    expect(response, hasResponse(200, everyElement({
        "index" : greaterThanOrEqualTo(0),
        "description" : endsWith("?"),
        "answer" : partial({
          "description" : isString
        })
    })));
    expect(response.decodedBody, hasLength(greaterThan(0)));
  });

  test("/questions/index returns a single question", () async {
    var response = await client.request("/questions/1").get();
    expect(response, hasResponse(200, {
        "index" : greaterThanOrEqualTo(0),
        "description" : endsWith("?")
    }));
  });

  test("/questions/index out of range returns 404", () async {
    var response = await client.request("/questions/100").get();
    expect(response, hasStatus(404));
  });

  test("/questions returns list of questions filtered by contains", () async {
    var response = await client.request("/questions?contains=mountain").get();
  expect(response, hasResponse(200, [{
      "index" : greaterThanOrEqualTo(0),
      "description" : "What's the tallest mountain in the world?",
      "answer" : partial({
        "description" : "Mount Everest"
      })
  }]));
    expect(response.decodedBody, hasLength(1));
  });  
}
