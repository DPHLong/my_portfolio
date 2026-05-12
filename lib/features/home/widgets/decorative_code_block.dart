// ── Decorative code block (visual flair) ──────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DecorativeCodeBlock extends StatelessWidget {
  final Color primary;
  final ThemeData theme;

  const DecorativeCodeBlock({required this.primary, required this.theme});

  @override
  Widget build(BuildContext context) {
    final surface = theme.colorScheme.surface;
    final onSurface = theme.colorScheme.onSurface;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: onSurface.withAlpha(20)),
            boxShadow: [
              BoxShadow(
                color: primary.withAlpha(15),
                blurRadius: 40,
                spreadRadius: 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Window dots ──
              Row(
                children: [
                  _dot(const Color(0xFFFF5F57)),
                  const SizedBox(width: 8),
                  _dot(const Color(0xFFFFBD2E)),
                  const SizedBox(width: 8),
                  _dot(const Color(0xFF28C840)),
                  const Spacer(),
                  Text(
                    'developer.dart',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onSurface.withAlpha(80),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Pseudo-code ──
              _codeLine('class', ' Developer ', '{', primary, onSurface, theme),
              _propertyLine('  name', '"Pham Hoang Long Dang"', primary, theme),
              _propertyLine('  role', '"Software Engineer"', primary, theme),
              _propertyLine('  focus', '"AI Engineering"', primary, theme),
              _propertyLine(
                '  passion',
                '"Building Smart Apps"',
                primary,
                theme,
              ),
              const SizedBox(height: 8),
              _codeLine(
                '  ',
                'createAwesome()',
                ' => true;',
                primary,
                onSurface,
                theme,
              ),
              const SizedBox(height: 4),
              Text(
                '}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onSurface.withAlpha(180),
                  fontSize: isMobile ? 13 : 14,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 500.ms, duration: 800.ms)
        .slideX(begin: 0.15, end: 0, duration: 800.ms);
  }

  Widget _dot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _codeLine(
    String keyword,
    String name,
    String rest,
    Color keywordColor,
    Color textColor,
    ThemeData theme,
  ) {
    return RichText(
      text: TextSpan(
        style: theme.textTheme.labelLarge?.copyWith(fontSize: 14),
        children: [
          TextSpan(
            text: keyword,
            style: TextStyle(color: keywordColor),
          ),
          TextSpan(
            text: name,
            style: TextStyle(color: textColor.withAlpha(220)),
          ),
          TextSpan(
            text: rest,
            style: TextStyle(color: textColor.withAlpha(120)),
          ),
        ],
      ),
    );
  }

  Widget _propertyLine(
    String key,
    String value,
    Color keyColor,
    ThemeData theme,
  ) {
    final green = theme.brightness == Brightness.dark
        ? const Color(0xFF7EE787)
        : const Color(0xFF1A7F37);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.labelLarge?.copyWith(fontSize: 14),
          children: [
            TextSpan(
              text: key,
              style: TextStyle(color: keyColor.withAlpha(180)),
            ),
            TextSpan(
              text: ': ',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(100),
              ),
            ),
            TextSpan(
              text: value,
              style: TextStyle(color: green),
            ),
            TextSpan(
              text: ';',
              style: TextStyle(
                color: theme.colorScheme.onSurface.withAlpha(80),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
