import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: AppConstants.sectionContact,
      child: Center(
        child: Text(
          'Contact Section',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
