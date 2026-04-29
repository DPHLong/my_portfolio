import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_portfolio/core/constants/app_constants.dart';
import 'package:my_portfolio/core/responsive/responsive.dart';
import 'package:my_portfolio/core/widgets/section_wrapper.dart';
import 'package:my_portfolio/features/chat/chat_service.dart';

class ChatSection extends StatefulWidget {
  final GlobalKey sectionKey;

  const ChatSection({super.key, required this.sectionKey});

  @override
  State<ChatSection> createState() => _ChatSectionState();
}

class _ChatSectionState extends State<ChatSection> {
  final ChatService _chatService = ChatService();
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _chatService.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend() {
    final text = _inputController.text.trim();
    if (text.isEmpty || _chatService.isLoading) return;

    _inputController.clear();
    _chatService.sendMessage(text).then((_) => _scrollToBottom());
    _scrollToBottom();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionWrapper(
      sectionKey: AppConstants.sectionChat,
      globalKey: widget.sectionKey,
      child: Column(
        children: [
          _SectionHeading(theme: theme),
          const SizedBox(height: 48),
          _ChatContainer(
            chatService: _chatService,
            inputController: _inputController,
            scrollController: _scrollController,
            focusNode: _focusNode,
            onSend: _handleSend,
            theme: theme,
          ),
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
          'Chat with my AI Agent',
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
          'Ask my AI anything about my skills, projects, or experience!',
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

// ── Chat container ────────────────────────────────────────────────────

class _ChatContainer extends StatelessWidget {
  final ChatService chatService;
  final TextEditingController inputController;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final ThemeData theme;

  const _ChatContainer({
    required this.chatService,
    required this.inputController,
    required this.scrollController,
    required this.focusNode,
    required this.onSend,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 700),
        child:
            Container(
                  height: 520,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: theme.colorScheme.surface,
                    border: Border.all(color: onSurface.withAlpha(20)),
                  ),
                  child: Column(
                    children: [
                      // ── Header ──
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: primary.withAlpha(10),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          border: Border(
                            bottom: BorderSide(color: onSurface.withAlpha(15)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primary, primary.withAlpha(180)],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.smart_toy_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Long\'s AI Agent',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    'Powered by Gemini',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: onSurface.withAlpha(120),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListenableBuilder(
                              listenable: chatService,
                              builder: (context, _) {
                                if (chatService.messages.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return IconButton(
                                  icon: Icon(
                                    Icons.refresh_rounded,
                                    size: 20,
                                    color: onSurface.withAlpha(120),
                                  ),
                                  tooltip: 'Clear chat',
                                  onPressed: chatService.clearChat,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // ── Messages area ──
                      Expanded(
                        child: ListenableBuilder(
                          listenable: chatService,
                          builder: (context, _) {
                            if (chatService.messages.isEmpty) {
                              return _EmptyState(
                                theme: theme,
                                onTap: (text) {
                                  inputController.text = text;
                                  onSend();
                                },
                              );
                            }

                            return ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount:
                                  chatService.messages.length +
                                  (chatService.isLoading ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == chatService.messages.length) {
                                  return _TypingIndicator(theme: theme);
                                }
                                return _MessageBubble(
                                  message: chatService.messages[index],
                                  theme: theme,
                                );
                              },
                            );
                          },
                        ),
                      ),

                      // ── Input area ──
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: onSurface.withAlpha(15)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: inputController,
                                focusNode: focusNode,
                                style: theme.textTheme.bodyMedium,
                                maxLines: 1,
                                textInputAction: TextInputAction.send,
                                onSubmitted: (_) => onSend(),
                                decoration: InputDecoration(
                                  hintText: 'Ask about my skills, projects...',
                                  hintStyle: theme.textTheme.bodyMedium
                                      ?.copyWith(
                                        color: onSurface.withAlpha(80),
                                      ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: onSurface.withAlpha(30),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: onSurface.withAlpha(30),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: primary,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: theme.scaffoldBackgroundColor,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ListenableBuilder(
                              listenable: chatService,
                              builder: (context, _) {
                                return _SendButton(
                                  onPressed: onSend,
                                  isLoading: chatService.isLoading,
                                  theme: theme,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 600.ms),
      ),
    );
  }
}

// ── Empty state with suggested questions ──────────────────────────────

class _EmptyState extends StatelessWidget {
  final ThemeData theme;
  final void Function(String text) onTap;

  const _EmptyState({required this.theme, required this.onTap});

  static const _suggestions = [
    'What are your top Flutter projects?',
    'Do you have backend experience?',
    'What tech stack do you work with?',
    'Tell me about your AI engineering journey',
  ];

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 48,
            color: onSurface.withAlpha(50),
          ),
          const SizedBox(height: 16),
          Text(
            'Ask me anything!',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try one of these questions:',
            style: theme.textTheme.bodySmall?.copyWith(
              color: onSurface.withAlpha(120),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _suggestions
                .map(
                  (q) => _SuggestionChip(
                    text: q,
                    primary: primary,
                    onSurface: onSurface,
                    theme: theme,
                    onTap: () => onTap(q),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatefulWidget {
  final String text;
  final Color primary;
  final Color onSurface;
  final ThemeData theme;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.text,
    required this.primary,
    required this.onSurface,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_SuggestionChip> createState() => _SuggestionChipState();
}

class _SuggestionChipState extends State<_SuggestionChip> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _hovering
                ? widget.primary.withAlpha(15)
                : Colors.transparent,
            border: Border.all(
              color: _hovering
                  ? widget.primary.withAlpha(80)
                  : widget.onSurface.withAlpha(25),
            ),
          ),
          child: Text(
            widget.text,
            style: widget.theme.textTheme.bodySmall?.copyWith(
              color: _hovering
                  ? widget.primary
                  : widget.onSurface.withAlpha(150),
              fontWeight: _hovering ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Message bubble ────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ThemeData theme;

  const _MessageBubble({required this.message, required this.theme});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, primary.withAlpha(180)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? primary.withAlpha(20)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isUser ? 14 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 14),
                    ),
                    border: isUser
                        ? Border.all(color: primary.withAlpha(40))
                        : Border.all(color: onSurface.withAlpha(15)),
                  ),
                  child: SelectableText(
                    message.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: isUser ? primary : onSurface,
                    ),
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 8),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideX(begin: isUser ? 0.05 : -0.05, end: 0, duration: 300.ms);
  }
}

// ── Typing indicator ──────────────────────────────────────────────────

class _TypingIndicator extends StatelessWidget {
  final ThemeData theme;

  const _TypingIndicator({required this.theme});

  @override
  Widget build(BuildContext context) {
    final primary = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primary, primary.withAlpha(180)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: onSurface.withAlpha(15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                return Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: primary.withAlpha(100),
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .scaleXY(
                      begin: 0.6,
                      end: 1.0,
                      duration: 600.ms,
                      delay: Duration(milliseconds: i * 150),
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .scaleXY(
                      begin: 1.0,
                      end: 0.6,
                      duration: 600.ms,
                      curve: Curves.easeInOut,
                    );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Send button ───────────────────────────────────────────────────────

class _SendButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final ThemeData theme;

  const _SendButton({
    required this.onPressed,
    required this.isLoading,
    required this.theme,
  });

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final primary = widget.theme.colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: widget.isLoading
                ? primary.withAlpha(60)
                : _hovering
                ? primary
                : primary.withAlpha(200),
            borderRadius: BorderRadius.circular(12),
          ),
          child: widget.isLoading
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white.withAlpha(180),
                  ),
                )
              : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
