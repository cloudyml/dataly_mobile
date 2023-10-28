class StoryModel {
  final int? id;
  final int? isViewed;
  final String? story;
  final String? path;
  StoryModel({this.isViewed, this.story, this.path, this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isViewed': isViewed,
      'story': story,
      'path': path,
    };
  }
}
