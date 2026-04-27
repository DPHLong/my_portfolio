class Project {
  final String title;
  final String description;
  final String imageAsset;
  final List<String> technologies;
  final String category;
  final String? githubUrl;
  final String? liveUrl;
  final bool featured;

  const Project({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.technologies,
    required this.category,
    this.githubUrl,
    this.liveUrl,
    this.featured = false,
  });
}
