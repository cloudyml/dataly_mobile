class QuizModel {
  final String id;
  final int? isAnswered;
  final String? option;
  QuizModel({this.isAnswered, this.option, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isAnswered': isAnswered,
      'option': option,
    };
  }
}
