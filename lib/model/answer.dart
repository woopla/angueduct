part of quiz;

class Answer extends ManagedObject<_Answer> implements _Answer {}
class _Answer {
  @managedPrimaryKey int id;
  String description;

  @ManagedRelationship(#answer, onDelete: ManagedRelationshipDeleteRule.cascade, isRequired: true) Question question;
}
