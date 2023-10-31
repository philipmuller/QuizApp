class Question extends Object {
  final int id;
  final String text;
  final String? imagePath;
  final List<String> choices;
  final String answerPath;

  Question({required this.id, required this.text, this.imagePath, required this.choices, required this.answerPath});

  Question.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        text = json['question'] as String,
        imagePath = json['image_url'] as String?,
        choices = List.from(json['options']),
        answerPath = json['answer_post_path'] as String;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': text,
      if (imagePath != null) 'image_url': imagePath,
      'options': choices,
      'answer_post_path': answerPath
    };
  }
}