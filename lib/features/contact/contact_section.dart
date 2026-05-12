import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final GlobalKey sectionKey;

  const ContactSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWrapper(
      sectionKey: AppConstants.sectionContact,
      globalKey: sectionKey,
      child: Column(
        children: [
          _SectionHeading(theme: theme),
          const SizedBox(height: 48),
          _ContactBody(theme: theme),
        ],
      ),
    );
  }
}

// ── Section heading ───────────────────────────────────────────────────

class _SectionHeading extends StatelessWidget {
  final ThemeData theme;

  const _SectionHeading({required this.theme});

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;

    return Column(
      children: [
        Text(
          'Get In Touch',
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Container(
          width: 60,
          height: 4,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Have a project in mind or want to connect? Let\'s talk!',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

// ── Contact body: form + info side-by-side ────────────────────────────

class _ContactBody extends StatelessWidget {
  final ThemeData theme;

  const _ContactBody({required this.theme});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _ContactForm(theme: theme)),
          const SizedBox(width: 48),
          Expanded(flex: 2, child: _ContactInfo(theme: theme)),
        ],
      );
    }

    return Column(
      children: [
        _ContactInfo(theme: theme),
        const SizedBox(height: 40),
        _ContactForm(theme: theme),
      ],
    );
  }
}

// ── Contact form ──────────────────────────────────────────────────────

class _ContactForm extends StatefulWidget {
  final ThemeData theme;

  const _ContactForm({required this.theme});

  @override
  State<_ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<_ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sending = false;
  bool _sent = false;

  // ── Anti-spam: client-side cooldown ──
  static const _cooldownDuration = Duration(seconds: 60);
  DateTime? _lastSentAt;
  int _cooldownRemaining = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  bool get _onCooldown => _cooldownRemaining > 0;

  void _startCooldown() {
    _lastSentAt = DateTime.now();
    _cooldownRemaining = _cooldownDuration.inSeconds;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      final elapsed = DateTime.now().difference(_lastSentAt!).inSeconds;
      final remaining = _cooldownDuration.inSeconds - elapsed;
      setState(() {
        _cooldownRemaining = remaining > 0 ? remaining : 0;
      });
      if (remaining <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surface,
            border: Border.all(color: onSurface.withAlpha(20)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Send me a message', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 24),

                // ── Name field ──
                _buildField(
                  controller: _nameController,
                  label: 'Your Name',
                  icon: Icons.person_outline_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter your name'
                      : null,
                  theme: theme,
                ),
                const SizedBox(height: 16),

                // ── Email field ──
                _buildField(
                  controller: _emailController,
                  label: 'Your Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  theme: theme,
                ),
                const SizedBox(height: 16),

                // ── Message field ──
                _buildField(
                  controller: _messageController,
                  label: 'Your Message',
                  icon: Icons.message_outlined,
                  maxLines: 5,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Please enter a message'
                      : null,
                  theme: theme,
                ),
                const SizedBox(height: 24),

                // ── Submit button ──
                SizedBox(
                  width: double.infinity,
                  child: _sent
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF28C840).withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF28C840).withAlpha(60),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Color(0xFF28C840),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Message sent! I\'ll get back to you soon.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF28C840),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: _sending || _onCooldown
                              ? null
                              : _handleSubmit,
                          icon: _sending
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: primary,
                                  ),
                                )
                              : const Icon(Icons.send_rounded, size: 18),
                          label: Text(
                            _sending
                                ? 'Sending...'
                                : _onCooldown
                                ? 'Wait ${_cooldownRemaining}s'
                                : 'Send Message',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                          ),
                        ),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 200.ms, duration: 600.ms)
        .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 600.ms);
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    required ThemeData theme,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final onSurface = theme.colorScheme.onSurface;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: theme.textTheme.bodyMedium?.copyWith(color: onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: theme.textTheme.bodyMedium,
        prefixIcon: maxLines == 1
            ? Icon(icon, size: 20, color: onSurface.withAlpha(120))
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurface.withAlpha(30)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: onSurface.withAlpha(30)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _sending = true);

    try {
      await FirebaseFirestore.instance.collection('contact_messages').add({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'message': _messageController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() {
        _sending = false;
        _sent = true;
      });

      _nameController.clear();
      _emailController.clear();
      _messageController.clear();

      _startCooldown();

      // Reset success banner after a delay
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) setState(() => _sent = false);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message. Please try again. ($e)'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// ── Contact info sidebar ──────────────────────────────────────────────

class _ContactInfo extends StatelessWidget {
  final ThemeData theme;

  const _ContactInfo({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: Responsive.isMobile(context)
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text('Let\'s connect', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(
              'I\'m currently open to new opportunities and always happy '
              'to discuss interesting projects, collaborations, or ideas.',
              style: theme.textTheme.bodyLarge,
              textAlign: Responsive.isMobile(context)
                  ? TextAlign.center
                  : TextAlign.start,
            ),
            const SizedBox(height: 32),

            // ── Contact items ──
            _ContactItem(
              icon: Icons.email_rounded,
              label: 'Email',
              value: AppConstants.email,
              url: 'mailto:${AppConstants.email}',
              theme: theme,
            ),
            const SizedBox(height: 16),
            _ContactItem(
              icon: Icons.location_on_rounded,
              label: 'Location',
              value: AppConstants.location,
              theme: theme,
            ),
            const SizedBox(height: 32),

            // ── Social links ──
            Text(
              'Find me on',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _SocialButton(
                  icon: FontAwesomeIcons.github,
                  label: 'GitHub',
                  url: AppConstants.githubUrl,
                  theme: theme,
                ),
                _SocialButton(
                  icon: FontAwesomeIcons.linkedin,
                  label: 'LinkedIn',
                  url: AppConstants.linkedInUrl,
                  theme: theme,
                ),
              ],
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 300.ms, duration: 600.ms)
        .slideY(begin: 0.1, end: 0, delay: 300.ms, duration: 600.ms);
  }
}

// ── Contact item row ──────────────────────────────────────────────────

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? url;
  final ThemeData theme;

  const _ContactItem({
    required this.icon,
    required this.label,
    required this.value,
    this.url,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: url != null
          ? () async {
              final uri = Uri.parse(url!);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            }
          : null,
      child: MouseRegion(
        cursor: url != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: primary, size: 18),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onSurface.withAlpha(120),
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: url != null ? primary : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Social button ─────────────────────────────────────────────────────

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;
  final ThemeData theme;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.theme,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final primary = widget.theme.colorScheme.primary;
    final onSurface = widget.theme.colorScheme.onSurface;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _hovering ? primary.withAlpha(15) : Colors.transparent,
            border: Border.all(
              color: _hovering
                  ? primary.withAlpha(60)
                  : onSurface.withAlpha(25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon,
                size: 18,
                color: _hovering ? primary : onSurface.withAlpha(150),
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: widget.theme.textTheme.titleMedium?.copyWith(
                  color: _hovering ? primary : onSurface,
                  fontWeight: _hovering ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
