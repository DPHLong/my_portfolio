import 'package:flutter/material.dart';

class ScrollToTopButton extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  const ScrollToTopButton({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: visible ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: visible ? 1.0 : 0.0,
        child: FloatingActionButton.small(
          onPressed: visible ? onPressed : null,
          backgroundColor: primary,
          foregroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 4,
          tooltip: 'Scroll to top',
          child: const Icon(Icons.keyboard_arrow_up_rounded),
        ),
      ),
    );
  }
}
