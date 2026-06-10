class Experience {
  final String id;
  final String role;
  final String company;
  final String duration;
  final String description;
  final List<String> tech;
  final int order;

  Experience({
    required this.id,
    required this.role,
    required this.company,
    required this.duration,
    required this.description,
    required this.tech,
    required this.order,
  });

  factory Experience.fromJson(Map<String, dynamic> json, String id) {
    return Experience(
      id: id,
      role: json['role'] ?? '',
      company: json['company'] ?? '',
      duration: json['duration'] ?? '',
      description: json['description'] ?? '',
      tech: List<String>.from(json['tech'] ?? []),
      order: json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'company': company,
      'duration': duration,
      'description': description,
      'tech': tech,
      'order': order,
    };
  }
}
