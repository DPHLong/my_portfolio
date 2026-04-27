class Project {
  final String id;
  final String title;
  final String description;
  final List<String> tech;
  final String imageUrl;
  final String? githubUrl;
  final String? liveDemoUrl;
  final int order;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.tech,
    required this.imageUrl,
    this.githubUrl,
    this.liveDemoUrl,
    required this.order,
  });

  factory Project.fromJson(Map<String, dynamic> json, String id) {
    return Project(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      tech: List<String>.from(json['tech'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      githubUrl: json['githubUrl'],
      liveDemoUrl: json['liveDemoUrl'],
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'tech': tech,
      'imageUrl': imageUrl,
      'githubUrl': githubUrl,
      'liveDemoUrl': liveDemoUrl,
      'order': order,
    };
  }
}
