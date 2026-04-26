import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: AppConstants.sectionAbout,
      child: Center(
        child: Text(
          'About Section',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
