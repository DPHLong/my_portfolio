import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_portfolio/theme/theme_notifier.dart';
import '../widgets/chat_widget.dart';

class ResponsiveLayout extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final Widget child;

  const ResponsiveLayout({
    super.key,
    required this.child,
    required this.themeNotifier,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isMobile(context)
          ? AppBar(
              title: Text(
                'PHAM HOANG LONG DANG',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            )
          : null,
      drawer: isMobile(context) ? const MobileDrawer() : null,
      body: Stack(
        children: [
          Column(
            children: [
              if (isDesktop(context))
                DesktopNavBar(themeNotifier: themeNotifier),
              Expanded(child: child),
            ],
          ),
          const ChatWidget(),
        ],
      ),
    );
  }
}

class DesktopNavBar extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  const DesktopNavBar({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 64),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'PHAM HOANG LONG DANG',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const _NavBarItem(title: 'Home', route: '/'),
              const _NavBarItem(title: 'About', route: '/about'),
              const _NavBarItem(title: 'Experience', route: '/experience'),
              const _NavBarItem(title: 'Projects', route: '/projects'),
              const _NavBarItem(title: 'Contact', route: '/contact'),
              _ThemeToggle(themeNotifier: themeNotifier),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String title;
  final String route;

  const _NavBarItem({required this.title, required this.route});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextButton(
        onPressed: () {
          context.go(route);
        },
        child: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
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

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Text(
              'Menu',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              context.go('/');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('About'),
            onTap: () {
              context.go('/about');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Experience'),
            onTap: () {
              context.go('/experience');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Projects'),
            onTap: () {
              context.go('/projects');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Contact'),
            onTap: () {
              context.go('/contact');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
