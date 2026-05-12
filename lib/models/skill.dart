class Skill {
  final String name;
  final String category;
  final double proficiency; // 0.0 to 1.0
  final String? iconAsset;

  const Skill({
    required this.name,
    required this.category,
    required this.proficiency,
    this.iconAsset,
  });
}
