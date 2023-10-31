class Topic extends Object {
    final int id;
    final String title;
    final String questionPath;

    Topic({required this.id, required this.title, required this.questionPath});

    Topic.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['name'] as String,
        questionPath = json['question_path'] as String;

    Map<String, dynamic> toJson() {
      return {
        'id': id,
        'name': title,
        'question_path': questionPath,
      };
    }
        
}