class Question extends Object {
  final int id;
  final String text;
  final List<String> choices;
  final String answerPath;

  Question({required this.id, required this.text, required this.choices, required this.answerPath});

  Question.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        text = json['question'] as String,
        choices = List.from(json['options']),
        answerPath = json['answer_post_path'] as String;
}