import 'dart:async';

import 'package:flutter/material.dart';
import '../app/widgets/patient_navigation_bar.dart';

class PatientChatScreen extends StatefulWidget {
  const PatientChatScreen({super.key});

  @override
  State<PatientChatScreen> createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          "Hello! I'm Elevate Zen AI. I'll help collect information about your symptoms before your consultation.",
      isAi: true,
    ),
    const _ChatMessage(
      text:
          "What is the main reason for your visit today?",
      isAi: true,
    ),
  ];

  final Map<String, String> _extractedData = {};

  bool _isTyping = false;
  bool _showSummary = false;

  int _questionIndex = 0;

  final List<String> _questions = [
    'When did the headache start?',
    'Where exactly do you feel the headache?',
    'How would you describe the pain — throbbing, sharp, dull, or pressure-like?',
    'How severe is the headache on a scale of 1 to 10?',
    'Does anything make the headache better or worse?',
    'Are you experiencing any other symptoms such as nausea, dizziness, fever, or blurred vision?',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? quickReply]) {
    final text = (quickReply ?? _messageController.text).trim();

    if (text.isEmpty || _isTyping) {
      return;
    }

    _messageController.clear();

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          isAi: false,
        ),
      );
      _isTyping = true;
    });

    _extractInformation(text);

    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }

      _generateAiResponse();
    });
  }

  void _extractInformation(String text) {
    final lower = text.toLowerCase();

    if (_questionIndex == 0) {
      _extractedData['Chief complaint'] = text;
    } else if (_questionIndex == 1) {
      _extractedData['Onset'] = text;
    } else if (_questionIndex == 2) {
      _extractedData['Location'] = text;
    } else if (_questionIndex == 3) {
      _extractedData['Pain quality'] = text;
    } else if (_questionIndex == 4) {
      _extractedData['Severity'] = text;
    } else if (_questionIndex == 5) {
      _extractedData['Aggravating / relieving factors'] = text;
    }

    if (lower.contains('nausea') ||
        lower.contains('dizziness') ||
        lower.contains('fever') ||
        lower.contains('vomiting') ||
        lower.contains('blurred')) {
      _extractedData['Associated symptoms'] = text;
    }
  }

  void _generateAiResponse() {
    String response;

    if (_questionIndex < _questions.length) {
      response = _questions[_questionIndex];
      _questionIndex++;
    } else {
      response =
          "Thank you. I have collected the information needed for the initial clinical intake.";
    }

    setState(() {
      _messages.add(
        _ChatMessage(
          text: response,
          isAi: true,
        ),
      );
      _isTyping = false;
    });

    _scrollToBottom();
  }

  void _generateSummary() {
    setState(() {
      _showSummary = true;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _navigate(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/patient');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/patient/case');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/patient/records');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Elevate Zen AI',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Clinical Intake Assistant',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Information',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Elevate Zen AI'),
                    content: const Text(
                      'The AI assistant collects information from your responses and organizes it for clinician review. It does not provide a diagnosis.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.info_outline_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildAiStatus(colors),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              children: [
                _buildIntroCard(colors),
                const SizedBox(height: 20),
                ..._messages.map(
                  (message) => _buildMessage(
                    message,
                    colors,
                  ),
                ),
                if (_isTyping) _buildTypingIndicator(colors),
                if (_showSummary) ...[
                  const SizedBox(height: 16),
                  _buildSummary(colors),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
          _buildQuickReplies(colors),
          _buildInputArea(colors),
        ],
      ),
      bottomNavigationBar: PatientNavigationBar(
        selectedIndex: 2,
        onSelected: _navigate,
      ),
    );
  }

  Widget _buildAiStatus(ColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer.withValues(alpha: 0.45),
        border: Border(
          bottom: BorderSide(
            color: colors.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 18,
            color: colors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Your responses are organized for clinical review',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ),
          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.psychology_alt_outlined,
              color: colors.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI-assisted intake',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'The assistant asks targeted questions and organizes your answers into a structured clinical history.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(
    _ChatMessage message,
    ColorScheme colors,
  ) {
    if (message.isAi) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: 19,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                    border: Border.all(
                      color: colors.outlineVariant,
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 1.45,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: Text(
            message.text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onPrimary,
                  height: 1.4,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(ColorScheme colors) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 19,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: colors.outlineVariant,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dot(colors),
                  const SizedBox(width: 4),
                  _dot(colors),
                  const SizedBox(width: 4),
                  _dot(colors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot(ColorScheme colors) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: colors.primary,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildQuickReplies(ColorScheme colors) {
    final replies = [
      'Headache',
      'Chest pain',
      'Fever',
      'Cough',
      'Abdominal pain',
    ];

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(replies[index]),
            onPressed: _isTyping
                ? null
                : () => _sendMessage(replies[index]),
            avatar: const Icon(
              Icons.add_rounded,
              size: 17,
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea(ColorScheme colors) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(
              color: colors.outlineVariant,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Tell the AI about your symptoms...',
                  prefixIcon: const Icon(
                    Icons.chat_outlined,
                  ),
                  suffixIcon: IconButton(
                    tooltip: 'Voice input',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Voice input prototype',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.mic_none_rounded,
                    ),
                  ),
                  filled: true,
                  fillColor: colors.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _isTyping ? null : () => _sendMessage(),
              icon: const Icon(
                Icons.arrow_upward_rounded,
              ),
              tooltip: 'Send',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(ColorScheme colors) {
    final missing = <String>[];

    if (!_extractedData.containsKey('Severity')) {
      missing.add('Pain severity');
    }

    if (!_extractedData.containsKey('Associated symptoms')) {
      missing.add('Associated symptoms');
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.summarize_outlined,
                  color: colors.onSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AI Clinical Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.onSecondaryContainer,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _summaryItem(
            colors,
            'Chief complaint',
            _extractedData['Chief complaint'] ?? 'Headache',
          ),
          _summaryItem(
            colors,
            'Onset',
            _extractedData['Onset'] ?? 'Not provided',
          ),
          _summaryItem(
            colors,
            'Location',
            _extractedData['Location'] ?? 'Not provided',
          ),
          _summaryItem(
            colors,
            'Pain quality',
            _extractedData['Pain quality'] ?? 'Not provided',
          ),
          _summaryItem(
            colors,
            'Severity',
            _extractedData['Severity'] ?? 'Not provided',
          ),
          const SizedBox(height: 8),
          Text(
            'Missing information',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSecondaryContainer,
                ),
          ),
          const SizedBox(height: 8),
          if (missing.isEmpty)
            Text(
              'No obvious missing fields identified.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSecondaryContainer,
                  ),
            )
          else
            ...missing.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 17,
                      color: colors.onSecondaryContainer,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.onSecondaryContainer,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 19,
                  color: colors.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'AI-generated information should be verified by the clinician before becoming part of the final medical record.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSecondaryContainer,
                          height: 1.35,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Clinical intake sent for doctor review.',
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.send_rounded,
              ),
              label: const Text(
                'Send for Doctor Review',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(
    ColorScheme colors,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colors.onSecondaryContainer.withValues(
                      alpha: 0.75,
                    ),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colors.onSecondaryContainer,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isAi;

  const _ChatMessage({
    required this.text,
    required this.isAi,
  });
}