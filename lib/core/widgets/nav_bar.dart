import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/core/theme/theme_notifier.dart';

class NavItem {
  final String label;
  final String sectionKey;

  const NavItem({required this.label, required this.sectionKey});
}

const _navItems = [
  NavItem(label: 'Home', sectionKey: AppConstants.sectionHome),
  NavItem(label: 'About', sectionKey: AppConstants.sectionAbout),
  NavItem(label: 'Projects', sectionKey: AppConstants.sectionProjects),
  NavItem(label: 'Skills', sectionKey: AppConstants.sectionSkills),
  NavItem(label: 'Contact', sectionKey: AppConstants.sectionContact),
];

class NavBar extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final void Function(String sectionKey) onNavTap;
  final String activeSection;

  const NavBar({
    super.key,
    required this.themeNotifier,
    required this.onNavTap,
    required this.activeSection,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withAlpha(230),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withAlpha(30),
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppConstants.maxContentWidth,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ── Logo / Name ──
              GestureDetector(
                onTap: () => onNavTap(AppConstants.sectionHome),
                child: Text(
                  AppConstants.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              // ── Nav Links (desktop) or Menu Button (mobile) ──
              if (isMobile)
                _MobileMenuButton(
                  themeNotifier: themeNotifier,
                  onNavTap: onNavTap,
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final item in _navItems)
                      _DesktopNavLink(
                        label: item.label,
                        isActive: item.sectionKey == activeSection,
                        onTap: () => onNavTap(item.sectionKey),
                      ),
                    const SizedBox(width: 8),
                    _ThemeToggle(themeNotifier: themeNotifier),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Desktop nav link ──────────────────────────────────────────────────

class _DesktopNavLink extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _DesktopNavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_DesktopNavLink> createState() => _DesktopNavLinkState();
}

class _DesktopNavLinkState extends State<_DesktopNavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isHighlighted = _hovering || widget.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: isHighlighted ? primary : onSurface,
                  fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(widget.label),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 2,
                width: widget.isActive ? 20 : 0,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Mobile menu button + drawer trigger ───────────────────────────────

class _MobileMenuButton extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final void Function(String sectionKey) onNavTap;

  const _MobileMenuButton({
    required this.themeNotifier,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu_rounded),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _MobileNavSheet(
            themeNotifier: themeNotifier,
            onNavTap: (key) {
              Navigator.of(context).pop();
              onNavTap(key);
            },
          ),
        );
      },
    );
  }
}

class _MobileNavSheet extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final void Function(String sectionKey) onNavTap;

  const _MobileNavSheet({required this.themeNotifier, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final item in _navItems)
              ListTile(
                title: Text(
                  item.label,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                onTap: () => onNavTap(item.sectionKey),
              ),
            const Divider(),
            ListenableBuilder(
              listenable: themeNotifier,
              builder: (context, _) {
                return ListTile(
                  leading: Icon(
                    themeNotifier.isDark
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                  ),
                  title: Text(
                    themeNotifier.isDark ? 'Light Mode' : 'Dark Mode',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  onTap: () {
                    themeNotifier.toggle();
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Theme toggle button ───────────────────────────────────────────────

class _ThemeToggle extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  const _ThemeToggle({required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) =>
                RotationTransition(turns: animation, child: child),
            child: Icon(
              themeNotifier.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
              key: ValueKey(themeNotifier.isDark),
            ),
          ),
          onPressed: themeNotifier.toggle,
          tooltip: themeNotifier.isDark
              ? 'Switch to Light Mode'
              : 'Switch to Dark Mode',
        );
      },
    );
  }
}
