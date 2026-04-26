import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';

class SectionWrapper extends StatelessWidget {
  final String sectionKey;
  final Widget child;
  final Color? backgroundColor;

  const SectionWrapper({
    super.key,
    required this.sectionKey,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(sectionKey),
      width: double.infinity,
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.sectionPaddingVertical,
        horizontal: AppConstants.sectionPaddingHorizontal,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}
