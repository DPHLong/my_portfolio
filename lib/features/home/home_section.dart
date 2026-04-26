import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: AppConstants.sectionHome,
      child: Center(
        child: Text(
          'Home Section',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
