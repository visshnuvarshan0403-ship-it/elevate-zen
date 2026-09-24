import 'package:flutter/material.dart';

import '../app/widgets/veterinary_navigation_bar.dart';

class VeterinaryChatScreen extends StatefulWidget {
  const VeterinaryChatScreen({super.key});

  @override
  State<VeterinaryChatScreen> createState() => _VeterinaryChatScreenState();
}

class _VeterinaryChatScreenState extends State<VeterinaryChatScreen> {
  int _questionIndex = 0;
  int _selectedNavIndex = 2;

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text:
          "Hi! I'm Elevate Zen's AI Veterinary Intake Assistant. "
          "I'll ask a few questions about Bruno and organize the information "
          "for your veterinarian.",
      isAi: true,
    ),
    const _ChatMessage(
      text: "What symptoms have you noticed in Bruno?",
      isAi: true,
    ),
  ];

  final Map<String, String> _answers = {};

  final List<_Question> _questions = [
    _Question(
      key: 'symptom',
      question: 'What symptoms have you noticed in Bruno?',
      options: [
        'Vomiting',
        'Diarrhea',
        'Loss of appetite',
        'Lethargy',
        'Coughing',
        'Something else',
      ],
    ),
    _Question(
      key: 'duration',
      question: 'When did Bruno first start vomiting?',
      options: [
        'Today',
        'Yesterday',
        '2–3 days ago',
        'More than 3 days ago',
        "I'm not sure",
      ],
    ),
    _Question(
      key: 'frequency',
      question: 'How many times has Bruno vomited?',
      options: [
        'Once',
        '2–3 times',
        '4–5 times',
        'More than 5 times',
        "I'm not sure",
      ],
    ),
    _Question(
      key: 'appetite',
      question: 'Has Bruno been eating normally?',
      options: [
        'Yes',
        'Less than usual',
        'Not eating',
        "I'm not sure",
      ],
    ),
    _Question(
      key: 'water',
      question: 'Is Bruno drinking water normally?',
      options: [
        'Yes',
        'More than usual',
        'Less than usual',
        "I'm not sure",
      ],
    ),
    _Question(
      key: 'stool',
      question: 'Have you noticed any changes in Bruno\'s stool?',
      options: [
        'No changes',
        'Diarrhea',
        'Constipation',
        'Blood noticed',
        "I'm not sure",
      ],
    ),
    _Question(
      key: 'energy',
      question: 'How is Bruno\'s energy level?',
      options: [
        'Normal',
        'Slightly reduced',
        'Very low',
        "I'm not sure",
      ],
    ),
    _Question(
      key: 'history',
      question: 'Has Bruno had a similar problem before?',
      options: [
        'Yes',
        'No',
        "I'm not sure",
      ],
    ),
  ];

  _Question get _currentQuestion => _questions[_questionIndex];

  double get _progress {
    return (_questionIndex + 1) / _questions.length;
  }

  void _selectAnswer(String answer) {
    final question = _currentQuestion;

    setState(() {
      _answers[question.key] = answer;

      _messages.add(
        _ChatMessage(
          text: answer,
          isAi: false,
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;

      if (_questionIndex < _questions.length - 1) {
        setState(() {
          _questionIndex++;

          _messages.add(
            _ChatMessage(
              text: _currentQuestion.question,
              isAi: true,
            ),
          );
        });
      } else {
        setState(() {
          _messages.add(
            const _ChatMessage(
              text:
                  "Thank you. I have enough information to prepare "
                  "a structured intake summary for the veterinarian.",
              isAi: true,
            ),
          );
        });
      }
    });
  }

  void _generateSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VeterinarySummaryScreen(
          answers: _answers,
        ),
      ),
    );
  }

  void _onNavigationSelected(int index) {
    setState(() {
      _selectedNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/veterinary');
        break;

      case 1:
        Navigator.pop(context);
        break;

      case 2:
        break;

      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veterinary records coming next.'),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final completed = _questionIndex >= _questions.length - 1;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Veterinary Intake',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Bruno • Labrador Retriever',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 14,
                  color: colors.onSecondaryContainer,
                ),
                const SizedBox(width: 5),
                Text(
                  'AI Assist',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildPetHeader(colors),
            _buildProgress(colors),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  20,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(
                    _messages[index],
                    colors,
                  );
                },
              ),
            ),
            if (!completed)
              _buildOptions(colors)
            else
              _buildCompleteCard(colors),
          ],
        ),
      ),
      bottomNavigationBar: VeterinaryNavigationBar(
        selectedIndex: _selectedNavIndex,
        onSelected: _onNavigationSelected,
      ),
    );
  }

  Widget _buildPetHeader(ColorScheme colors) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 27,
            backgroundColor: colors.primaryContainer,
            child: Icon(
              Icons.pets_rounded,
              color: colors.onPrimaryContainer,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bruno',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Dog • Labrador Retriever • 4 yrs • Male',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.verified_rounded,
            color: colors.primary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildProgress(ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'INTAKE PROGRESS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: colors.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${_questionIndex + 1} of ${_questions.length}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 7,
              backgroundColor: colors.surfaceContainerHighest,
              color: colors.primary,
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
    return Align(
      alignment:
          message.isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 330),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: message.isAi
              ? colors.surfaceContainerHighest
              : colors.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(
              message.isAi ? 4 : 18,
            ),
            bottomRight: Radius.circular(
              message.isAi ? 18 : 4,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.isAi) ...[
              Icon(
                Icons.auto_awesome_rounded,
                size: 17,
                color: colors.primary,
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: message.isAi
                      ? colors.onSurface
                      : colors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose an answer',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _currentQuestion.options.map((option) {
              return ActionChip(
                label: Text(option),
                avatar: const Icon(
                  Icons.add_rounded,
                  size: 17,
                ),
                onPressed: () => _selectAnswer(option),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteCard(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.outlineVariant,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: colors.primary,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'AI intake complete. Your responses are ready for review.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: _generateSummary,
              icon: const Icon(Icons.description_rounded),
              label: const Text(
                'Generate Case Summary',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
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

class _Question {
  final String key;
  final String question;
  final List<String> options;

  const _Question({
    required this.key,
    required this.question,
    required this.options,
  });
}

// -----------------------------------------------------------------------------
// VETERINARY SUMMARY SCREEN
// -----------------------------------------------------------------------------

class VeterinarySummaryScreen extends StatelessWidget {
  final Map<String, String> answers;

  const VeterinarySummaryScreen({
    super.key,
    required this.answers,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Veterinary Case Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'AI-generated • Review before sharing',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPatientCard(colors),
          const SizedBox(height: 14),
          _buildAiNotice(colors),
          const SizedBox(height: 14),
          _buildSummarySection(
            colors,
            title: 'Chief Complaint',
            icon: Icons.medical_information_outlined,
            child: _value(
              answers['symptom'],
              'Not provided',
            ),
          ),
          _buildSummarySection(
            colors,
            title: 'Symptom Timeline',
            icon: Icons.schedule_rounded,
            child: Column(
              children: [
                _summaryRow(
                  'Onset',
                  answers['duration'],
                ),
                _summaryRow(
                  'Frequency',
                  answers['frequency'],
                ),
              ],
            ),
          ),
          _buildSummarySection(
            colors,
            title: 'Associated Information',
            icon: Icons.fact_check_outlined,
            child: Column(
              children: [
                _summaryRow(
                  'Appetite',
                  answers['appetite'],
                ),
                _summaryRow(
                  'Water intake',
                  answers['water'],
                ),
                _summaryRow(
                  'Stool',
                  answers['stool'],
                ),
                _summaryRow(
                  'Energy',
                  answers['energy'],
                ),
              ],
            ),
          ),
          _buildSummarySection(
            colors,
            title: 'Relevant History',
            icon: Icons.history_rounded,
            child: _value(
              answers['history'],
              'Not provided',
            ),
          ),
          _buildMissingInformation(colors),
          const SizedBox(height: 10),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Case prepared for veterinarian review.',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.send_rounded),
              label: const Text(
                'Send for Veterinarian Review',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Edit Intake'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPatientCard(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            child: Icon(
              Icons.pets_rounded,
              size: 28,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bruno',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Dog • Labrador Retriever • 4 yrs • Male',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiNotice(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: colors.onPrimaryContainer,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'AI has organized the information provided during intake. '
              'This summary does not make a veterinary diagnosis.',
              style: TextStyle(
                color: colors.onPrimaryContainer,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(
    ColorScheme colors, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 19,
                color: colors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value ?? 'Not provided',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _value(String? value, String fallback) {
    return Text(
      value?.isNotEmpty == true ? value! : fallback,
      style: const TextStyle(
        fontSize: 13,
        height: 1.4,
      ),
    );
  }

  Widget _buildMissingInformation(ColorScheme colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: colors.primary,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Information to verify',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Any details not provided during intake should '
                  'be verified by the veterinarian.',
                  style: TextStyle(
                    fontSize: 12,
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
}