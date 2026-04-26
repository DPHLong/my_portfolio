import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';

class SkillsSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const SkillsSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: AppConstants.sectionSkills,
      globalKey: sectionKey,
      child: Center(
        child: Text(
          'Skills Section',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
