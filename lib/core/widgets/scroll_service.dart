import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';

class ScrollService extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();

  final Map<String, GlobalKey> sectionKeys = {
    AppConstants.sectionHome: GlobalKey(),
    AppConstants.sectionAbout: GlobalKey(),
    AppConstants.sectionProjects: GlobalKey(),
    AppConstants.sectionSkills: GlobalKey(),
    AppConstants.sectionChat: GlobalKey(),
    AppConstants.sectionContact: GlobalKey(),
  };

  static const _sectionOrder = [
    AppConstants.sectionHome,
    AppConstants.sectionAbout,
    AppConstants.sectionProjects,
    AppConstants.sectionSkills,
    AppConstants.sectionChat,
    AppConstants.sectionContact,
  ];

  String _activeSection = AppConstants.sectionHome;
  String get activeSection => _activeSection;

  bool _showScrollToTop = false;
  bool get showScrollToTop => _showScrollToTop;

  ScrollService() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // ── Scroll-to-top button visibility ──
    final shouldShow = scrollController.offset > 400;
    if (shouldShow != _showScrollToTop) {
      _showScrollToTop = shouldShow;
      notifyListeners();
    }

    // ── Active section detection ──
    _updateActiveSection();
  }

  void _updateActiveSection() {
    String newActive = AppConstants.sectionHome;

    for (final key in _sectionOrder) {
      final globalKey = sectionKeys[key];
      if (globalKey?.currentContext == null) continue;

      final renderBox =
          globalKey!.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.attached) continue;

      final position = renderBox.localToGlobal(Offset.zero);
      // If the section top is above the center of the screen, it's active
      if (position.dy <= 200) {
        newActive = key;
      }
    }

    if (newActive != _activeSection) {
      _activeSection = newActive;
      notifyListeners();
    }
  }

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

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}
