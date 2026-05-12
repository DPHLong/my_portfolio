import 'dart:async';
import 'package:flutter/material.dart';

class TypingAnimation extends StatefulWidget {
  final List<String> texts;
  final TextStyle? style;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration pauseDuration;

  const TypingAnimation({
    super.key,
    required this.texts,
    this.style,
    this.typingSpeed = const Duration(milliseconds: 80),
    this.deletingSpeed = const Duration(milliseconds: 40),
    this.pauseDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation> {
  int _textIndex = 0;
  int _charIndex = 0;
  bool _isDeleting = false;
  Timer? _timer;
  String _displayedText = '';

  @override
  void initState() {
    super.initState();
    _tick();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    final currentFullText = widget.texts[_textIndex];

    Duration delay;

    if (!_isDeleting) {
      // Typing forward
      _charIndex++;
      _displayedText = currentFullText.substring(0, _charIndex);

      if (_charIndex >= currentFullText.length) {
        // Finished typing, pause before deleting
        _isDeleting = true;
        delay = widget.pauseDuration;
      } else {
        delay = widget.typingSpeed;
      }
    } else {
      // Deleting
      _charIndex--;
      _displayedText = currentFullText.substring(0, _charIndex);

      if (_charIndex <= 0) {
        // Finished deleting, move to next text
        _isDeleting = false;
        _textIndex = (_textIndex + 1) % widget.texts.length;
        delay = const Duration(milliseconds: 300);
      } else {
        delay = widget.deletingSpeed;
      }
    }

    if (mounted) setState(() {});

    _timer = Timer(delay, _tick);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            _displayedText,
            style: widget.style,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Blinking cursor
        _BlinkingCursor(color: primary),
      ],
    );
  }
}

class _BlinkingCursor extends StatefulWidget {
  final Color color;

  const _BlinkingCursor({required this.color});

  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 3,
        height: 28,
        margin: const EdgeInsets.only(left: 2),
        color: widget.color,
      ),
    );
  }
}
