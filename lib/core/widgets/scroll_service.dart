import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';

class ScrollService {
  final ScrollController scrollController = ScrollController();

  final Map<String, GlobalKey> sectionKeys = {
    AppConstants.sectionHome: GlobalKey(),
    AppConstants.sectionAbout: GlobalKey(),
    AppConstants.sectionProjects: GlobalKey(),
    AppConstants.sectionSkills: GlobalKey(),
    AppConstants.sectionContact: GlobalKey(),
  };

  void scrollToSection(String sectionKey) {
    final key = sectionKeys[sectionKey];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void dispose() {
    scrollController.dispose();
  }
}
