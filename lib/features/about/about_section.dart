import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const AboutSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: AppConstants.sectionAbout,
      globalKey: sectionKey,
      child: Center(
        child: Text(
          'About Section',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
