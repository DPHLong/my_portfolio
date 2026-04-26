import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';

class ContactSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const ContactSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionKey: AppConstants.sectionContact,
      globalKey: sectionKey,
      child: Center(
        child: Text(
          'Contact Section',
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
