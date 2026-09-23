import 'package:flutter/material.dart';
import '../app/widgets/patient_navigation_bar.dart';

enum _InputMethod {
  speech,
  text,
  document,
}

class PatientCaseScreen extends StatefulWidget {
  const PatientCaseScreen({super.key});

  @override
  State<PatientCaseScreen> createState() => _PatientCaseScreenState();
}

class _PatientCaseScreenState extends State<PatientCaseScreen> {
  _InputMethod? _selectedInput;

  bool _isProcessing = false;
  bool _isListening = false;
  bool _isReviewed = false;
  bool _interviewStarted = false;

  String _extractedText =
      'Persistent lower back pain for the past 2 weeks, worsening after prolonged sitting. Occasional sharp pain radiating to the left leg.';

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController.text = _extractedText;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // INPUT HANDLING
  // ------------------------------------------------------------

  void _selectInput(_InputMethod method) {
    setState(() {
      _selectedInput = method;
      _isListening = false;
      _isProcessing = false;
    });

    if (method == _InputMethod.speech) {
      _startSpeech();
    }

    if (method == _InputMethod.document) {
      _processDocument();
    }
  }

  Future<void> _startSpeech() async {
    setState(() {
      _isListening = true;
      _isProcessing = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isListening = false;
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      _extractedText =
          'Persistent lower back pain for the past 2 weeks, worsening after prolonged sitting. Occasional sharp pain radiating to the left leg.';
      _textController.text = _extractedText;
    });
  }

  Future<void> _processDocument() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      _extractedText =
          'Previous report indicates persistent lower back pain with occasional radiation to the left leg. Previous lumbar X-ray was attached for review.';
      _textController.text = _extractedText;
    });
  }

  void _openTextInput() {
    setState(() {
      _selectedInput = _InputMethod.text;
      _isListening = false;
      _isProcessing = false;
    });

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        final colors = Theme.of(sheetContext).colorScheme;

        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 8,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us what brings you in',
                style: Theme.of(sheetContext).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Describe your symptoms or concern in your own words.',
                style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _textController,
                maxLines: 6,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText:
                      'For example: I have been having back pain for two weeks...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    final value = _textController.text.trim();

                    if (value.isNotEmpty) {
                      setState(() {
                        _extractedText = value;
                      });
                    }

                    Navigator.pop(sheetContext);
                  },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Continue'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------------------------
  // INTERVIEW
  // ------------------------------------------------------------

  void _startInterview() {
    setState(() {
      _interviewStarted = true;
    });

    Navigator.pushNamed(
      context,
      '/patient/chat',
    );
  }

  void _editInformation() {
    _openTextInput();
  }

  void _toggleReview() {
    setState(() {
      _isReviewed = !_isReviewed;
    });
  }

  void _submitHistory() {
    if (!_isReviewed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please review your information before submitting.',
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Your case has been submitted for doctor review.',
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // NAVIGATION
  // ------------------------------------------------------------

  void _navigate(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          '/patient',
        );
        break;

      case 1:
        break;

      case 2:
        Navigator.pushReplacementNamed(
          context,
          '/patient/chat',
        );
        break;

      case 3:
        Navigator.pushReplacementNamed(
          context,
          '/patient/records',
        );
        break;
    }
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,

      // --------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------

      appBar: AppBar(
        titleSpacing: 28,
        title: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.medical_information_outlined,
                color: colors.onPrimaryContainer,
                size: 28,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              'Patient Case',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 28),
            child: IconButton(
              tooltip: 'Profile',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/patient/profile',
                );
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 50,
                minHeight: 50,
              ),
              icon: CircleAvatar(
                backgroundColor: colors.primaryContainer,
                foregroundColor: colors.onPrimaryContainer,
                child: Text(
                  'N',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),

      // --------------------------------------------------------
      // BODY
      // --------------------------------------------------------

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          28,
          28,
          28,
          32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Title(),

            const SizedBox(height: 24),

            // --------------------------------------------------
            // MAIN AI INTAKE CARD
            // --------------------------------------------------

            _StartConsultationCard(
              onStart: _startInterview,
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // ALTERNATIVE INPUTS
            // --------------------------------------------------

            _InputMethodsCard(
              selectedInput: _selectedInput,
              isListening: _isListening,
              isProcessing: _isProcessing,
              onSpeech: () => _selectInput(
                _InputMethod.speech,
              ),
              onText: _openTextInput,
              onDocument: () => _selectInput(
                _InputMethod.document,
              ),
            ),

            if (_isListening) ...[
              const SizedBox(height: 18),
              const _ListeningCard(),
            ],

            if (_isProcessing) ...[
              const SizedBox(height: 18),
              const _ProcessingCard(),
            ],

            const SizedBox(height: 18),

            // --------------------------------------------------
            // PROGRESS
            // --------------------------------------------------

            const _ProgressCard(),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // CLINICAL INFORMATION
            // --------------------------------------------------

            _ClinicalInformationCard(
              text: _extractedText,
              source: _selectedInput,
              onEdit: _editInformation,
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // MISSING INFORMATION
            // --------------------------------------------------

            const _MissingInformationCard(),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // REVIEW
            // --------------------------------------------------

            _ReviewStatusCard(
              reviewed: _isReviewed,
              onReview: _toggleReview,
            ),

            const SizedBox(height: 18),

            // --------------------------------------------------
            // NEXT STEP
            // --------------------------------------------------

            _NextStepCard(
              interviewStarted: _interviewStarted,
              reviewed: _isReviewed,
              onContinue: _startInterview,
              onSubmit: _submitHistory,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),

      // --------------------------------------------------------
      // NAVIGATION BAR
      // --------------------------------------------------------

      bottomNavigationBar: PatientNavigationBar(
        selectedIndex: 1,
        onSelected: _navigate,
      ),
    );
  }
}

// ============================================================================
// TITLE
// ============================================================================

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start your consultation',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: colors.onSurface,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Share what you are experiencing. Elevate Zen will guide you through a few questions.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
        ),
      ],
    );
  }
}

// ============================================================================
// START CONSULTATION CARD
// ============================================================================

class _StartConsultationCard extends StatelessWidget {
  final VoidCallback onStart;

  const _StartConsultationCard({
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: colors.onPrimary,
                    size: 27,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'AI-assisted clinical interview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Tell us what is happening in your own words. Elevate Zen will organize the information and ask relevant follow-up questions.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.onPrimaryContainer,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onStart,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.surface,
                  foregroundColor: colors.primary,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
                icon: const Icon(
                  Icons.play_arrow_rounded,
                ),
                label: const Text(
                  'Start interview',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// INPUT METHODS
// ============================================================================

class _InputMethodsCard extends StatelessWidget {
  final _InputMethod? selectedInput;
  final bool isListening;
  final bool isProcessing;
  final VoidCallback onSpeech;
  final VoidCallback onText;
  final VoidCallback onDocument;

  const _InputMethodsCard({
    required this.selectedInput,
    required this.isListening,
    required this.isProcessing,
    required this.onSpeech,
    required this.onText,
    required this.onDocument,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: colors.surfaceContainerLow,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Other ways to provide information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Use speech, text, or previous medical documents.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 650;

                final children = [
                  _InputMethodTile(
                    icon: Icons.mic_none_rounded,
                    title: 'Speak',
                    subtitle: 'Describe your concern',
                    selected: selectedInput == _InputMethod.speech,
                    active: isListening,
                    onTap: onSpeech,
                  ),
                  _InputMethodTile(
                    icon: Icons.edit_outlined,
                    title: 'Type',
                    subtitle: 'Enter information',
                    selected: selectedInput == _InputMethod.text,
                    onTap: onText,
                  ),
                  _InputMethodTile(
                    icon: Icons.upload_file_outlined,
                    title: 'Add document',
                    subtitle: 'Report or prescription',
                    selected: selectedInput == _InputMethod.document,
                    active: isProcessing &&
                        selectedInput == _InputMethod.document,
                    onTap: onDocument,
                  ),
                ];

                if (compact) {
                  return Column(
                    children: [
                      children[0],
                      const SizedBox(height: 12),
                      children[1],
                      const SizedBox(height: 12),
                      children[2],
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: children[0]),
                    const SizedBox(width: 12),
                    Expanded(child: children[1]),
                    const SizedBox(width: 12),
                    Expanded(child: children[2]),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// INPUT METHOD TILE
// ============================================================================

class _InputMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final bool active;
  final VoidCallback onTap;

  const _InputMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? colors.secondaryContainer
          : colors.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? colors.primary
                  : colors.outlineVariant,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: selected
                      ? colors.primary
                      : colors.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: active
                    ? Padding(
                        padding: const EdgeInsets.all(14),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: selected
                              ? colors.onPrimary
                              : colors.primary,
                        ),
                      )
                    : Icon(
                        icon,
                        color: selected
                            ? colors.onPrimary
                            : colors.onPrimaryContainer,
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? colors.onSecondaryContainer
                                    : colors.onSurface,
                              ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style:
                          Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: selected
                                    ? colors.onSecondaryContainer
                                    : colors.onSurfaceVariant,
                              ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: colors.primary,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LISTENING CARD
// ============================================================================

class _ListeningCard extends StatelessWidget {
  const _ListeningCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: colors.primaryContainer,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mic_rounded,
                color: colors.onPrimary,
                size: 27,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Listening...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Speak naturally about your symptoms or medical history.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// PROCESSING CARD
// ============================================================================

class _ProcessingCard extends StatelessWidget {
  const _ProcessingCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: colors.secondaryContainer,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Organizing information...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onSecondaryContainer,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const _ProcessingStep(
              icon: Icons.text_fields_rounded,
              label: 'Converting input to text',
              completed: true,
            ),
            const SizedBox(height: 8),
            const _ProcessingStep(
              icon: Icons.psychology_outlined,
              label: 'Identifying clinical information',
              completed: true,
            ),
            const SizedBox(height: 8),
            const _ProcessingStep(
              icon: Icons.account_tree_outlined,
              label: 'Organizing patient history',
              completed: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProcessingStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool completed;

  const _ProcessingStep({
    required this.icon,
    required this.label,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          completed
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 20,
          color: completed
              ? colors.primary
              : colors.onSecondaryContainer.withValues(
                  alpha: 0.6,
                ),
        ),
        const SizedBox(width: 10),
        Icon(
          icon,
          size: 19,
          color: colors.onSecondaryContainer,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSecondaryContainer,
                ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// PROGRESS
// ============================================================================

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.route_outlined,
                  color: colors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Clinical history',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Text(
                  'Step 1 of 4',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: 0.25,
                minHeight: 8,
                backgroundColor: colors.surfaceContainerHighest,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Symptoms → History → Medications → Review',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CLINICAL INFORMATION
// ============================================================================

class _ClinicalInformationCard extends StatelessWidget {
  final String text;
  final _InputMethod? source;
  final VoidCallback onEdit;

  const _ClinicalInformationCard({
    required this.text,
    required this.source,
    required this.onEdit,
  });

  String get _sourceLabel {
    switch (source) {
      case _InputMethod.speech:
        return 'Speech';
      case _InputMethod.text:
        return 'Manual entry';
      case _InputMethod.document:
        return 'Medical document';
      case null:
        return 'Existing information';
    }
  }

  IconData get _sourceIcon {
    switch (source) {
      case _InputMethod.speech:
        return Icons.mic_none_rounded;
      case _InputMethod.text:
        return Icons.edit_outlined;
      case _InputMethod.document:
        return Icons.description_outlined;
      case null:
        return Icons.medical_information_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: colors.surfaceContainerLow,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: colors.tertiaryContainer,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.auto_awesome_outlined,
                    color: colors.onTertiaryContainer,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clinical information',
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            _sourceIcon,
                            size: 15,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              'Organized from $_sourceLabel',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEdit,
                  tooltip: 'Edit information',
                  style: IconButton.styleFrom(
                    backgroundColor: colors.surfaceContainerHighest,
                  ),
                  icon: Icon(
                    Icons.edit_outlined,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.onSurface,
                    height: 1.6,
                  ),
            ),
            const SizedBox(height: 20),
            Divider(
              color: colors.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'Structured information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 14),
            const _ExtractedItem(
              icon: Icons.sick_outlined,
              title: 'Symptoms',
              value:
                  'Lower back pain, occasional pain radiating to left leg',
            ),
            const SizedBox(height: 10),
            const _ExtractedItem(
              icon: Icons.schedule_outlined,
              title: 'Duration',
              value: '2 weeks',
            ),
            const SizedBox(height: 10),
            const _ExtractedItem(
              icon: Icons.warning_amber_outlined,
              title: 'Pattern',
              value: 'Worsens after prolonged sitting',
            ),
          ],
        ),
      ),
    );
  }
}

class _ExtractedItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ExtractedItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 21,
            color: colors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w500,
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

// ============================================================================
// MISSING INFORMATION
// ============================================================================

class _MissingInformationCard extends StatelessWidget {
  const _MissingInformationCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              color: colors.onTertiaryContainer,
              size: 26,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Information still needed',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.onTertiaryContainer,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The interview has not yet collected pain severity, exact onset, or relevant previous treatment.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.onTertiaryContainer,
                          height: 1.45,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Continue the interview to complete the case.',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.onTertiaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// REVIEW
// ============================================================================

class _ReviewStatusCard extends StatelessWidget {
  final bool reviewed;
  final VoidCallback onReview;

  const _ReviewStatusCard({
    required this.reviewed,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      color: reviewed
          ? colors.primaryContainer
          : colors.surfaceContainerLow,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            Icon(
              reviewed
                  ? Icons.check_circle_rounded
                  : Icons.fact_check_outlined,
              size: 30,
              color: reviewed
                  ? colors.onPrimaryContainer
                  : colors.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reviewed
                        ? 'Information reviewed'
                        : 'Review before sending',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: reviewed
                              ? colors.onPrimaryContainer
                              : colors.onSurface,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reviewed
                        ? 'You confirmed that the information reflects what you provided.'
                        : 'Check the information before sending your case to the doctor.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: reviewed
                              ? colors.onPrimaryContainer
                              : colors.onSurfaceVariant,
                          height: 1.4,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Switch(
              value: reviewed,
              onChanged: (_) => onReview(),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// NEXT STEP
// ============================================================================

class _NextStepCard extends StatelessWidget {
  final bool interviewStarted;
  final bool reviewed;
  final VoidCallback onContinue;
  final VoidCallback onSubmit;

  const _NextStepCard({
    required this.interviewStarted,
    required this.reviewed,
    required this.onContinue,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              reviewed
                  ? 'Your case is ready'
                  : 'Complete your clinical history',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              reviewed
                  ? 'You can now submit the information for doctor review.'
                  : 'Continue the interview to collect the remaining information.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 16),
            if (!reviewed)
              FilledButton.icon(
                onPressed: onContinue,
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                ),
                label: Text(
                  interviewStarted
                      ? 'Continue Interview'
                      : 'Start Interview',
                ),
              )
            else
              FilledButton.icon(
                onPressed: onSubmit,
                icon: const Icon(
                  Icons.send_outlined,
                ),
                label: const Text(
                  'Submit to Doctor',
                ),
              ),
          ],
        ),
      ),
    );
  }
}