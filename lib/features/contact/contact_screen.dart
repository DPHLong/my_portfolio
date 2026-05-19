import 'package:flutter/material.dart';
import 'package:my_portfolio/features/contact/widgets/contact_body.dart';
import 'package:my_portfolio/features/contact/widgets/section_heading.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeading(theme: theme),
              const SizedBox(height: 48),
              ContactBody(theme: theme),
            ],
          ),
        ),
      ),
    );
  }
}
