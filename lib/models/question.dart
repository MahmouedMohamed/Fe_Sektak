import 'answer.dart';

class Question {
  String questionID;
  String text;
  List<Answer> answers;
  Question(this.questionID, this.text, this.answers);
}
