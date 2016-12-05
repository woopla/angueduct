part of quiz;

class Question extends ManagedObject<_Question> implements _Question {}

// By convention, but not required, persistent types are prefixed with ‘_’
class _Question {
  @managedPrimaryKey int index;

  String description;
  Answer answer;
}