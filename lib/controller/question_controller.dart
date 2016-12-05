part of quiz;

class QuestionController extends HTTPController {
  /*
    Could also have the following signature:
    @httpGet getAllQuestions(...
    "Because responder methods in HTTPController must always return a Response and must always have HTTPMethod metadata"
  */
  @httpGet Future<Response> getAllQuestions({@HTTPQuery("contains") String containsSubstring: null}) async {
    var questionQuery = new Query<Question>()
        ..matchOn.answer.includeInResultSet = true;

    if (containsSubstring != null) {
      questionQuery.matchOn.description = whereContains(containsSubstring);
    }
    var questions = await questionQuery.fetch();
    return new Response.ok(questions);
  }

  @httpGet getQuestionAtIndex(@HTTPPath("index") int index) async {
    var questionQuery = new Query<Question>()
      ..matchOn.index = whereEqualTo(index);    

    var question = await questionQuery.fetchOne();

    if (question == null) {
      return new Response.notFound();
    }
    return new Response.ok(question);
  }
}
