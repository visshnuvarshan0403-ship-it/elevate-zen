import 'package:flutter/material.dart';
import '../app/widgets/patient_navigation_bar.dart';

class PatientChatScreen extends StatefulWidget {
  const PatientChatScreen({super.key});

  @override
  State<PatientChatScreen> createState() => _PatientChatScreenState();
}

class _PatientChatScreenState extends State<PatientChatScreen> {
  final ScrollController _scrollController = ScrollController();

  final TextEditingController _chiefComplaintController =
      TextEditingController();
  final TextEditingController _onsetController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _qualityController = TextEditingController();
  final TextEditingController _timingController = TextEditingController();
  final TextEditingController _provocationController =
      TextEditingController();
  final TextEditingController _palliationController =
      TextEditingController();

  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _surgeryController = TextEditingController();
  final TextEditingController _medicationController =
      TextEditingController();
  final TextEditingController _familyHistoryController =
      TextEditingController();

  final TextEditingController _allergenController = TextEditingController();
  final TextEditingController _reactionController = TextEditingController();

  final TextEditingController _occupationController =
      TextEditingController();

  final List<String> _commonComplaints = [
    'Headache',
    'Chest pain',
    'Abdominal pain',
    'Shortness of breath',
    'Back pain',
    'Fever',
    'Cough',
    'Fatigue',
    'Dizziness',
    'Joint pain',
  ];

  final List<String> _associatedSymptoms = [
    'Nausea',
    'Vomiting',
    'Dizziness',
    'Fever',
    'Chills',
    'Sweating',
    'Weight loss',
    'Weight gain',
    'Insomnia',
    'Numbness',
    'Tingling',
    'Weakness',
    'Blurred vision',
    'Loss of appetite',
    'Constipation',
  ];

  final Map<String, List<String>> _systemSymptoms = {
    'Constitutional': [
      'Fatigue',
      'Fever',
      'Chills',
      'Weight loss',
      'Weight gain',
      'Night sweats',
    ],
    'HEENT': [
      'Headache',
      'Blurred vision',
      'Sore throat',
      'Nasal congestion',
      'Ear pain',
    ],
    'Cardiovascular': [
      'Chest pain',
      'Palpitations',
      'Leg swelling',
      'Fainting',
    ],
    'Respiratory': [
      'Cough',
      'Shortness of breath',
      'Wheezing',
      'Chest tightness',
    ],
    'Gastrointestinal': [
      'Abdominal pain',
      'Nausea',
      'Vomiting',
      'Constipation',
      'Diarrhea',
      'Loss of appetite',
    ],
    'Genitourinary': [
      'Painful urination',
      'Frequent urination',
      'Blood in urine',
    ],
    'Musculoskeletal': [
      'Joint pain',
      'Muscle pain',
      'Back pain',
      'Weakness',
    ],
    'Neurological': [
      'Dizziness',
      'Numbness',
      'Tingling',
      'Headache',
      'Weakness',
    ],
    'Psychiatric': [
      'Anxiety',
      'Low mood',
      'Sleep difficulty',
      'Difficulty concentrating',
    ],
    'Skin': [
      'Rash',
      'Itching',
      'Skin changes',
      'Swelling',
    ],
  };

  final List<String> _systemNames = [
    'Constitutional',
    'HEENT',
    'Cardiovascular',
    'Respiratory',
    'Gastrointestinal',
    'Genitourinary',
    'Musculoskeletal',
    'Neurological',
    'Psychiatric',
    'Skin',
  ];

  final List<String> _commonAllergens = [
    'Penicillin',
    'Sulfa drugs',
    'Aspirin',
    'Ibuprofen',
    'Latex',
    'Peanuts',
    'Shellfish',
    'Eggs',
    'Milk',
    'Soy',
    'Wheat',
    'Codeine',
    'Morphine',
    'Iodine',
    'Adhesive tape',
  ];

  final List<String> _conversation = [
    'Hello. I’ll guide you through your clinical intake one section at a time. You can answer using the fields or the quick options.',
  ];

  final Set<String> _selectedAssociatedSymptoms = {};
  final Set<String> _selectedSystemSymptoms = {};
  final Set<String> _selectedCommonComplaints = {};
  final List<_RecordedItem> _conditions = [];
  final List<_RecordedItem> _surgeries = [];
  final List<_RecordedItem> _medications = [];
  final List<_RecordedItem> _familyHistory = [];
  final List<_AllergyItem> _allergies = [];

  int _currentStep = 0;
  int _severity = 5;
  String _selectedSystem = 'Constitutional';
  String _smokingStatus = 'Never smoker';
  String _alcoholUse = 'None';
  String _exerciseLevel = 'Sedentary (no regular exercise)';
  String _allergyType = 'Allergy (immune response)';
  String _allergySeverity = 'Mild';
  bool _noKnownAllergies = true;
  bool _isSubmitting = false;

  final List<String> _stepTitles = [
    'Chief Complaint',
    'History of Present Illness',
    'Review of Systems',
    'Medical History',
    'Allergies & Adverse Reactions',
    'Social History',
    'Review & Submit',
  ];

  final List<String> _stepShortTitles = [
    'Chief Complaint',
    'History of Present Illness',
    'Review of Systems',
    'Medical History',
    'Allergies',
    'Social History',
    'Review',
  ];

  @override
  void dispose() {
    _chiefComplaintController.dispose();
    _onsetController.dispose();
    _regionController.dispose();
    _durationController.dispose();
    _qualityController.dispose();
    _timingController.dispose();
    _provocationController.dispose();
    _palliationController.dispose();
    _conditionController.dispose();
    _surgeryController.dispose();
    _medicationController.dispose();
    _familyHistoryController.dispose();
    _allergenController.dispose();
    _reactionController.dispose();
    _occupationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  double get _progress => (_currentStep + 1) / _stepTitles.length;

  void _nextStep() {
    if (!_validateCurrentStep()) {
      return;
    }

    if (_currentStep == _stepTitles.length - 1) {
      _submitIntake();
      return;
    }

    setState(() {
      _conversation.add(_stepResponse());
      _currentStep++;
      _conversation.add(_stepPrompt());
    });

    _scrollToTop();
  }

  void _previousStep() {
    if (_currentStep == 0) {
      Navigator.maybePop(context);
      return;
    }

    setState(() {
      _currentStep--;
      if (_conversation.length > 1) {
        _conversation.removeLast();
        _conversation.removeLast();
      }
    });

    _scrollToTop();
  }

  bool _validateCurrentStep() {
    if (_currentStep == 0 &&
        _chiefComplaintController.text.trim().isEmpty &&
        _selectedCommonComplaints.isEmpty) {
      _showMessage('Please enter or select the main reason for your visit.');
      return false;
    }

    if (_currentStep == 1) {
      if (_onsetController.text.trim().isEmpty ||
          _regionController.text.trim().isEmpty ||
          _durationController.text.trim().isEmpty ||
          _qualityController.text.trim().isEmpty) {
        _showMessage('Please complete the required symptom details.');
        return false;
      }
    }

    return true;
  }

  String _stepPrompt() {
    switch (_currentStep) {
      case 0:
        return 'What is the main reason for your visit today?';
      case 1:
        return 'Now let’s document the details of your current symptoms.';
      case 2:
        return 'Are you experiencing any other symptoms across these body systems?';
      case 3:
        return 'Tell us about your previous medical history and current medicines.';
      case 4:
        return 'Do you have any known allergies or adverse reactions?';
      case 5:
        return 'A few lifestyle details can help complete your clinical history.';
      case 6:
        return 'Review the information below before submitting your intake.';
      default:
        return '';
    }
  }

  String _stepResponse() {
    switch (_currentStep) {
      case 0:
        if (_chiefComplaintController.text.trim().isNotEmpty) {
          return _chiefComplaintController.text.trim();
        }
        return _selectedCommonComplaints.join(', ');
      case 1:
        return 'Symptom details recorded.';
      case 2:
        if (_selectedSystemSymptoms.isEmpty) {
          return 'No additional symptoms selected.';
        }
        return '${_selectedSystemSymptoms.length} additional symptom(s) recorded.';
      case 3:
        return 'Medical history recorded.';
      case 4:
        if (_noKnownAllergies) {
          return 'No known allergies reported.';
        }
        return '${_allergies.length} allergy record(s) added.';
      case 5:
        return 'Social history recorded.';
      case 6:
        return 'Clinical intake reviewed.';
      default:
        return '';
    }
  }

  void _submitIntake() {
    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Clinical intake submitted for doctor review.'),
        ),
      );
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }

      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 250),
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

  void _selectComplaint(String complaint) {
    setState(() {
      if (_selectedCommonComplaints.contains(complaint)) {
        _selectedCommonComplaints.remove(complaint);
      } else {
        _selectedCommonComplaints.add(complaint);
      }

      if (_selectedCommonComplaints.length == 1 &&
          _chiefComplaintController.text.trim().isEmpty) {
        _chiefComplaintController.text = complaint;
      }
    });
  }

  void _selectAssociatedSymptom(String symptom) {
    setState(() {
      if (_selectedAssociatedSymptoms.contains(symptom)) {
        _selectedAssociatedSymptoms.remove(symptom);
      } else {
        _selectedAssociatedSymptoms.add(symptom);
      }
    });
  }

  void _selectSystemSymptom(String symptom) {
    setState(() {
      if (_selectedSystemSymptoms.contains(symptom)) {
        _selectedSystemSymptoms.remove(symptom);
      } else {
        _selectedSystemSymptoms.add(symptom);
      }
    });
  }

  void _addCondition() {
    final value = _conditionController.text.trim();

    if (value.isEmpty) {
      return;
    }

    setState(() {
      _conditions.add(_RecordedItem(value));
      _conditionController.clear();
    });
  }

  void _addSurgery() {
    final value = _surgeryController.text.trim();

    if (value.isEmpty) {
      return;
    }

    setState(() {
      _surgeries.add(_RecordedItem(value));
      _surgeryController.clear();
    });
  }

  void _addMedication() {
    final value = _medicationController.text.trim();

    if (value.isEmpty) {
      return;
    }

    setState(() {
      _medications.add(_RecordedItem(value));
      _medicationController.clear();
    });
  }

  void _addFamilyHistory() {
    final value = _familyHistoryController.text.trim();

    if (value.isEmpty) {
      return;
    }

    setState(() {
      _familyHistory.add(_RecordedItem(value));
      _familyHistoryController.clear();
    });
  }

  void _addAllergy() {
    final allergen = _allergenController.text.trim();
    final reaction = _reactionController.text.trim();

    if (allergen.isEmpty || reaction.isEmpty) {
      _showMessage('Please enter the allergen and reaction.');
      return;
    }

    setState(() {
      _noKnownAllergies = false;
      _allergies.add(
        _AllergyItem(
          allergen: allergen,
          reaction: reaction,
          type: _allergyType,
          severity: _allergySeverity,
        ),
      );
      _allergenController.clear();
      _reactionController.clear();
    });
  }

  void _selectQuickAllergen(String allergen) {
    setState(() {
      _allergenController.text = allergen;
      _noKnownAllergies = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      body: Column(
        children: [
          _buildProgressHeader(colorScheme),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
              children: [
                _buildConversation(colorScheme),
                const SizedBox(height: 20),
                _buildStepContent(colorScheme),
                const SizedBox(height: 24),
                _buildNavigationButtons(colorScheme),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: PatientNavigationBar(
        selectedIndex: 2,
        onSelected: _navigate,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ColorScheme colorScheme) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        tooltip: 'Back',
        onPressed: _previousStep,
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.assignment_outlined,
              color: colorScheme.onPrimaryContainer,
              size: 21,
            ),
          ),
          const SizedBox(width: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patient Intake',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                'Clinical history',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Step ${_currentStep + 1} of ${_stepTitles.length}: ${_stepShortTitles[_currentStep]}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              Text(
                '${(_progress * 100).round()}%',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              _stepTitles.length,
              (index) {
                final active = index <= _currentStep;

                return Expanded(
                  child: Container(
                    height: 5,
                    margin: EdgeInsets.only(
                      right: index == _stepTitles.length - 1 ? 0 : 5,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversation(ColorScheme colorScheme) {
    final visibleMessages = _conversation.length > 3
        ? _conversation.sublist(_conversation.length - 3)
        : _conversation;

    return Column(
      children: [
        for (int index = 0; index < visibleMessages.length; index++)
          _buildConversationBubble(
            visibleMessages[index],
            index == visibleMessages.length - 1,
            colorScheme,
          ),
      ],
    );
  }

  Widget _buildConversationBubble(
    String message,
    bool current,
    ColorScheme colorScheme,
  ) {
    final isPatientResponse =
        !message.contains('What is') &&
        !message.contains('Now let') &&
        !message.contains('Are you') &&
        !message.contains('Tell us') &&
        !message.contains('Do you') &&
        !message.contains('A few lifestyle') &&
        !message.contains('Review the information') &&
        !message.contains('Hello.');

    if (isPatientResponse) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(17),
          ),
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.chat_outlined,
              size: 19,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.4,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(ColorScheme colorScheme) {
    switch (_currentStep) {
      case 0:
        return _buildChiefComplaint(colorScheme);
      case 1:
        return _buildHistoryOfPresentIllness(colorScheme);
      case 2:
        return _buildReviewOfSystems(colorScheme);
      case 3:
        return _buildMedicalHistory(colorScheme);
      case 4:
        return _buildAllergies(colorScheme);
      case 5:
        return _buildSocialHistory(colorScheme);
      case 6:
        return _buildReview(colorScheme);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSectionCard(
    ColorScheme colorScheme, {
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 26),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildChiefComplaint(ColorScheme colorScheme) {
    return _buildSectionCard(
      colorScheme,
      title: 'Chief Complaint',
      subtitle:
          'What is the main reason for your visit today? Please describe your primary concern.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Primary Reason for Visit', required: true),
          const SizedBox(height: 7),
          TextField(
            controller: _chiefComplaintController,
            minLines: 4,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText:
                  'Describe your main concern, when it started, where it hurts, and what it feels like.',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be as specific as possible. The information will be organized for clinical review.',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          _fieldLabel('Common Chief Complaints'),
          const SizedBox(height: 10),
          _buildChoiceWrap(
            _commonComplaints,
            _selectedCommonComplaints,
            _selectComplaint,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryOfPresentIllness(ColorScheme colorScheme) {
    return _buildSectionCard(
      colorScheme,
      title: 'History of Present Illness',
      subtitle:
          'Provide details about the current symptom using the OPQRST format.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Pain / Symptom Severity', required: true),
          const SizedBox(height: 7),
          Row(
            children: [
              Text(
                '1 (Mild)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Expanded(
                child: Slider(
                  value: _severity.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: '$_severity',
                  onChanged: (value) {
                    setState(() {
                      _severity = value.round();
                    });
                  },
                ),
              ),
              Text(
                '10 (Severe)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 10),
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$_severity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimaryContainer,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _onsetController,
                  label: 'Onset - When did it start?',
                  hint: 'e.g. 3 days ago, last Tuesday morning',
                  required: true,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _buildTextField(
                  controller: _regionController,
                  label: 'Region - Where is it located?',
                  hint: 'e.g. right side of head',
                  required: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _durationController,
                  label: 'Duration - How long does it last?',
                  hint: 'e.g. constant, 2-3 hours at a time',
                  required: true,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _buildTextField(
                  controller: _qualityController,
                  label: 'Quality - What does it feel like?',
                  hint: 'e.g. sharp, throbbing, dull, burning',
                  required: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _timingController,
                  label: 'Timing - When does it occur?',
                  hint: 'e.g. worse in the morning',
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _buildTextField(
                  controller: _provocationController,
                  label: 'Provocation - What makes it worse?',
                  hint: 'e.g. movement, light, meals',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildTextField(
            controller: _palliationController,
            label: 'Palliation - What makes it better?',
            hint: 'e.g. rest, medication, ice pack',
          ),
          const SizedBox(height: 24),
          _fieldLabel('Associated Symptoms'),
          const SizedBox(height: 10),
          _buildChoiceWrap(
            _associatedSymptoms,
            _selectedAssociatedSymptoms,
            _selectAssociatedSymptom,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewOfSystems(ColorScheme colorScheme) {
    return _buildSectionCard(
      colorScheme,
      title: 'Review of Systems',
      subtitle:
          'Select a body system to view symptoms and record anything you are currently experiencing.',
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 255,
                child: Column(
                  children: [
                    for (final system in _systemNames)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedSystem = system;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              backgroundColor: _selectedSystem == system
                                  ? colorScheme.primaryContainer
                                  : null,
                              foregroundColor: _selectedSystem == system
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurface,
                              side: BorderSide(
                                color: _selectedSystem == system
                                    ? colorScheme.primary
                                    : colorScheme.outlineVariant,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(system),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(minHeight: 430),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedSystem,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 14),
                      _buildChoiceWrap(
                        _systemSymptoms[_selectedSystem] ?? [],
                        _selectedSystemSymptoms,
                        _selectSystemSymptom,
                        colorScheme,
                      ),
                      if (_selectedSystemSymptoms.isEmpty) ...[
                        const SizedBox(height: 30),
                        Center(
                          child: Text(
                            'Select any symptoms that apply.',
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalHistory(ColorScheme colorScheme) {
    return _buildSectionCard(
      colorScheme,
      title: 'Medical History',
      subtitle:
          'Document past medical conditions, surgeries, current medications, and family history.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHistoryInput(
            controller: _conditionController,
            hint: 'Condition name, e.g. Hypertension',
            buttonLabel: 'Add',
            onAdd: _addCondition,
            items: _conditions,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 22),
          _buildHistoryInput(
            controller: _surgeryController,
            hint: 'Previous surgery or procedure',
            buttonLabel: 'Add',
            onAdd: _addSurgery,
            items: _surgeries,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 22),
          _buildHistoryInput(
            controller: _medicationController,
            hint: 'Medication name and dose',
            buttonLabel: 'Add',
            onAdd: _addMedication,
            items: _medications,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 22),
          _buildHistoryInput(
            controller: _familyHistoryController,
            hint: 'Family condition or relevant history',
            buttonLabel: 'Add',
            onAdd: _addFamilyHistory,
            items: _familyHistory,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryInput({
    required TextEditingController controller,
    required String hint,
    required String buttonLabel,
    required VoidCallback onAdd,
    required List<_RecordedItem> items,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 84,
              height: 56,
              child: FilledButton(
                onPressed: onAdd,
                child: Text(buttonLabel),
              ),
            ),
          ],
        ),
        if (items.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int index = 0; index < items.length; index++)
                InputChip(
                  label: Text(items[index].value),
                  onDeleted: () {
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAllergies(ColorScheme colorScheme) {
    return _buildSectionCard(
      colorScheme,
      title: 'Allergies & Adverse Reactions',
      subtitle:
          'This is important safety information. List known allergies and adverse reactions.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('No known allergies'),
            subtitle: const Text(
              'Select this only if you have no known allergies or adverse reactions.',
            ),
            value: _noKnownAllergies,
            onChanged: (value) {
              setState(() {
                _noKnownAllergies = value;
              });
            },
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _allergenController,
                  label: 'Allergen / Substance',
                  hint: 'e.g. Penicillin, peanuts',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _reactionController,
                  label: 'Reaction',
                  hint: 'e.g. rash, swelling',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _allergyType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Allergy (immune response)',
                      child: Text('Allergy (immune response)'),
                    ),
                    DropdownMenuItem(
                      value: 'Adverse drug reaction',
                      child: Text('Adverse drug reaction'),
                    ),
                    DropdownMenuItem(
                      value: 'Intolerance',
                      child: Text('Intolerance'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _allergyType = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _allergySeverity,
                  decoration: const InputDecoration(
                    labelText: 'Severity',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Mild',
                      child: Text('Mild'),
                    ),
                    DropdownMenuItem(
                      value: 'Moderate',
                      child: Text('Moderate'),
                    ),
                    DropdownMenuItem(
                      value: 'Severe',
                      child: Text('Severe'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      _allergySeverity = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _addAllergy,
            child: const Text('Add Allergy'),
          ),
          const SizedBox(height: 22),
          _fieldLabel('Quick Add Common Allergens'),
          const SizedBox(height: 10),
          _buildChoiceWrap(
            _commonAllergens,
            <String>{
              if (_allergenController.text.isNotEmpty)
                _allergenController.text,
            },
            _selectQuickAllergen,
            colorScheme,
          ),
          const SizedBox(height: 20),
          if (_allergies.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.medical_information_outlined,
                    size: 28,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _noKnownAllergies
                        ? 'No allergies documented'
                        : 'No allergies added yet',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _noKnownAllergies
                        ? 'Continue if you have no known allergies.'
                        : 'Add an allergy above if applicable.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                for (final allergy in _allergies)
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.warning_amber_outlined),
                      title: Text(allergy.allergen),
                      subtitle: Text(
                        '${allergy.reaction} • ${allergy.severity}',
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _allergies.remove(allergy);
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSocialHistory(ColorScheme colorScheme) {
    return _buildSectionCard(
      colorScheme,
      title: 'Social History',
      subtitle:
          'Lifestyle factors that may affect health and treatment can be recorded here.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Tobacco / Smoking Status'),
          const SizedBox(height: 10),
          _buildSelectionGrid(
            [
              'Never smoker',
              'Former smoker (quit within 1 year)',
              'Former smoker (quit more than 1 year ago)',
              'Current smoker (< 1 pack/day)',
              'Current smoker (1+ pack/day)',
              'Occasional/social smoker',
            ],
            _smokingStatus,
            (value) {
              setState(() {
                _smokingStatus = value;
              });
            },
            colorScheme,
          ),
          const SizedBox(height: 24),
          _fieldLabel('Alcohol Use'),
          const SizedBox(height: 10),
          _buildSelectionGrid(
            [
              'None',
              'Occasional',
              'Moderate',
              'Heavy',
              'Very heavy',
              'Former drinker',
            ],
            _alcoholUse,
            (value) {
              setState(() {
                _alcoholUse = value;
              });
            },
            colorScheme,
          ),
          const SizedBox(height: 24),
          _fieldLabel('Exercise / Physical Activity'),
          const SizedBox(height: 10),
          _buildSelectionGrid(
            [
              'Sedentary (no regular exercise)',
              'Light (1-2 days/week)',
              'Moderate (3-4 days/week)',
              'Active (5-6 days/week)',
              'Very active (daily intense exercise)',
            ],
            _exerciseLevel,
            (value) {
              setState(() {
                _exerciseLevel = value;
              });
            },
            colorScheme,
          ),
          const SizedBox(height: 24),
          _buildTextField(
            controller: _occupationController,
            label: 'Occupation',
            hint: 'e.g. Office worker, teacher, student',
          ),
        ],
      ),
    );
  }

  Widget _buildReview(ColorScheme colorScheme) {
    return _buildSectionCard(
      colorScheme,
      title: 'Review Clinical Intake',
      subtitle:
          'Review the information before it is submitted for doctor review.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReviewGroup(
            colorScheme,
            'Chief Complaint',
            _chiefComplaintController.text.trim().isNotEmpty
                ? _chiefComplaintController.text.trim()
                : _selectedCommonComplaints.join(', '),
          ),
          _buildReviewGroup(
            colorScheme,
            'Current Symptoms',
            '${_severity}/10 severity • ${_regionController.text.trim()} • ${_durationController.text.trim()}',
          ),
          _buildReviewGroup(
            colorScheme,
            'Associated Symptoms',
            _selectedAssociatedSymptoms.isEmpty
                ? 'None selected'
                : _selectedAssociatedSymptoms.join(', '),
          ),
          _buildReviewGroup(
            colorScheme,
            'Review of Systems',
            _selectedSystemSymptoms.isEmpty
                ? 'No additional symptoms selected'
                : _selectedSystemSymptoms.join(', '),
          ),
          _buildReviewGroup(
            colorScheme,
            'Medical History',
            _conditions.isEmpty &&
                    _surgeries.isEmpty &&
                    _medications.isEmpty &&
                    _familyHistory.isEmpty
                ? 'No information added'
                : _medicalHistorySummary(),
          ),
          _buildReviewGroup(
            colorScheme,
            'Allergies',
            _noKnownAllergies
                ? 'No known allergies'
                : _allergies.map((item) => item.allergen).join(', '),
          ),
          _buildReviewGroup(
            colorScheme,
            'Social History',
            '$_smokingStatus • $_alcoholUse • $_exerciseLevel',
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: colorScheme.onSecondaryContainer,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This information is organized from your responses and is submitted for clinician review. It does not replace the final medical record.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          height: 1.4,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _medicalHistorySummary() {
    final sections = <String>[];

    if (_conditions.isNotEmpty) {
      sections.add('Conditions: ${_conditions.map((e) => e.value).join(', ')}');
    }

    if (_surgeries.isNotEmpty) {
      sections.add('Surgeries: ${_surgeries.map((e) => e.value).join(', ')}');
    }

    if (_medications.isNotEmpty) {
      sections.add(
        'Medications: ${_medications.map((e) => e.value).join(', ')}',
      );
    }

    if (_familyHistory.isNotEmpty) {
      sections.add(
        'Family history: ${_familyHistory.map((e) => e.value).join(', ')}',
      );
    }

    return sections.join('\n');
  }

  Widget _buildReviewGroup(
    ColorScheme colorScheme,
    String title,
    String value,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            value.isEmpty ? 'Not provided' : value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(ColorScheme colorScheme) {
    return Row(
      children: [
        OutlinedButton(
          onPressed: _previousStep,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(105, 50),
          ),
          child: const Text('Previous'),
        ),
        const Spacer(),
        FilledButton(
          onPressed: _isSubmitting ? null : _nextStep,
          style: FilledButton.styleFrom(
            minimumSize: const Size(105, 50),
          ),
          child: _isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  _currentStep == _stepTitles.length - 1
                      ? 'Submit'
                      : 'Next',
                ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label, required: required),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(
    String text, {
    bool required = false,
  }) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }

  Widget _buildChoiceWrap(
    List<String> choices,
    Set<String> selected,
    ValueChanged<String> onSelected,
    ColorScheme colorScheme,
  ) {
    return Wrap(
      spacing: 8,
      runSpacing: 9,
      children: [
        for (final choice in choices)
          FilterChip(
            label: Text(choice),
            selected: selected.contains(choice),
            onSelected: (_) => onSelected(choice),
            showCheckmark: true,
          ),
      ],
    );
  }

  Widget _buildSelectionGrid(
    List<String> choices,
    String selected,
    ValueChanged<String> onSelected,
    ColorScheme colorScheme,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth > 600;
        final width = twoColumns
            ? (constraints.maxWidth - 10) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final choice in choices)
              SizedBox(
                width: width,
                child: OutlinedButton(
                  onPressed: () => onSelected(choice),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    backgroundColor:
                        selected == choice ? colorScheme.primaryContainer : null,
                    foregroundColor: selected == choice
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurface,
                    side: BorderSide(
                      color: selected == choice
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(choice),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RecordedItem {
  final String value;

  const _RecordedItem(this.value);
}

class _AllergyItem {
  final String allergen;
  final String reaction;
  final String type;
  final String severity;

  const _AllergyItem({
    required this.allergen,
    required this.reaction,
    required this.type,
    required this.severity,
  });
}