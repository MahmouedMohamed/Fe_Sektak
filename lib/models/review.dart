import 'question.dart';

class Review{
  String userID;
  String reviewID;
  List<Question> questions;
  List<String> chosenAnswers;

  Review(this.userID, this.reviewID, this.questions);
}