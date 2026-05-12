import 'package:flutter/material.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileCard extends StatelessWidget {
  final ThemeData theme;

  const ProfileCard({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final isMobile = Responsive.isMobile(context);

    return Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? 280 : double.infinity,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: onSurface.withAlpha(20)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary.withAlpha(8), primary.withAlpha(20)],
            ),
          ),
          child: Column(
            children: [
              // ── Avatar placeholder ──
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withAlpha(25),
                  border: Border.all(color: primary.withAlpha(60), width: 3),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(AppConstants.profileImage),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppConstants.name,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Software Developer',
                style: theme.textTheme.bodyMedium?.copyWith(color: primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: onSurface.withAlpha(120),
                  ),
                  const SizedBox(width: 4),
                  Text(AppConstants.location, style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .slideY(begin: 0.15, end: 0, duration: 600.ms);
  }
}
