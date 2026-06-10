import 'package:flutter/material.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/features/contact/widgets/contact_form.dart';
import 'package:my_portfolio/features/contact/widgets/contact_info.dart';

class ContactBody extends StatefulWidget {
  final ThemeData theme;

  const ContactBody({super.key, required this.theme});

  @override
  State<ContactBody> createState() => _ContactBodyState();
}

class _ContactBodyState extends State<ContactBody> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: ContactForm(theme: widget.theme)),
          const SizedBox(width: 48),
          Expanded(flex: 2, child: ContactInfo(theme: widget.theme)),
        ],
      );
    }

    return Column(
      children: [
        ContactInfo(theme: widget.theme),
        const SizedBox(height: 40),
        ContactForm(theme: widget.theme),
      ],
    );
  }
}
