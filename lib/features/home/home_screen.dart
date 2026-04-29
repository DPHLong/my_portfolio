import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HELLO, WORLD!',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 3.0,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'I build cross platform apps and intelligent systems.',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 32),
              Text(
                'Experienced Software Developer specializing in Flutter, Firebase, Java, and C#. Currently expanding my horizons into AI Engineering to build the next generation of smart applications.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 48),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  ElevatedButton(
                    onPressed: () => context.go('/projects'),
                    child: const Text('VIEW PROJECTS'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.go('/about'),
                    child: const Text('ABOUT ME'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
