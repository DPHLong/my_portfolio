class Project {
  final String title;
  final String description;
  final String imageAsset;
  final List<String> technologies;
  final String? githubUrl;
  final String? liveUrl;

  const Project({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.technologies,
    this.githubUrl,
    this.liveUrl,
  });
}
