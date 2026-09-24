import 'package:flutter/material.dart';

class DoctorPatientScreen extends StatefulWidget {
  const DoctorPatientScreen({super.key});

  @override
  State<DoctorPatientScreen> createState() => _DoctorPatientScreenState();
}

class _DoctorPatientScreenState extends State<DoctorPatientScreen> {
  bool _verified = false;
  bool _editingSummary = false;

  final TextEditingController _summaryController = TextEditingController(
    text:
        'Patient reports persistent lower back pain for the past 2 weeks, worsening after prolonged sitting. Occasional sharp pain radiates to the left leg. Medical history includes hypertension and asthma.',
  );

  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _summaryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/doctor');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/doctor/patients');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/doctor/chat');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/doctor/profile');
        break;
    }
  }

  void _verifyCase() {
    setState(() {
      _verified = true;
      _editingSummary = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Case verified and ready for consultation.'),
      ),
    );
  }

  void _showDocument(String title, String type) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  type,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.description_outlined,
                    size: 64,
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Patient Review'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 21,
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.onPrimaryContainer,
              child: const Text(
                'C',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _PatientHeader(),
              const SizedBox(height: 24),
              _CaseStatusCard(verified: _verified),
              const SizedBox(height: 20),
              const _CurrentCaseCard(),
              const SizedBox(height: 20),
              _ClinicalSummaryCard(
                controller: _summaryController,
                editing: _editingSummary,
                onEdit: () {
                  setState(() {
                    _editingSummary = !_editingSummary;
                  });
                },
              ),
              const SizedBox(height: 20),
              const _MissingInformationCard(),
              const SizedBox(height: 20),
              const _PriorityCard(),
              const SizedBox(height: 20),
              _DocumentsCard(
                onDocumentTap: _showDocument,
              ),
              const SizedBox(height: 20),
              const _MedicalTimeline(),
              const SizedBox(height: 20),
              _DoctorNotesCard(
                controller: _notesController,
              ),
              const SizedBox(height: 28),
              _ReviewCard(
                verified: _verified,
                onVerify: _verifyCase,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) => _navigate(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt_rounded),
            label: 'Patients',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _PatientHeader extends StatelessWidget {
  const _PatientHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 38,
          backgroundColor: colors.primaryContainer,
          foregroundColor: colors.onPrimaryContainer,
          child: Text(
            'N',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nirunjhana',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                '45 yrs • Female • ID: NR-8902',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CaseStatusCard extends StatelessWidget {
  final bool verified;

  const _CaseStatusCard({
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: verified
            ? colors.primaryContainer
            : colors.secondaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            verified
                ? Icons.verified_outlined
                : Icons.rate_review_outlined,
            color: verified
                ? colors.onPrimaryContainer
                : colors.onSecondaryContainer,
            size: 27,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  verified ? 'Case Verified' : 'Case Needs Review',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: verified
                            ? colors.onPrimaryContainer
                            : colors.onSecondaryContainer,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  verified
                      ? 'The clinical information has been reviewed.'
                      : 'Review the AI-assisted information before consultation.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: verified
                            ? colors.onPrimaryContainer
                            : colors.onSecondaryContainer,
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

class _CurrentCaseCard extends StatelessWidget {
  const _CurrentCaseCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _SectionCard(
      title: 'Current Case',
      icon: Icons.assignment_outlined,
      child: Column(
        children: [
          const _ClinicalRow(
            label: 'Chief complaint',
            value: 'Persistent lower back pain',
          ),
          const _ClinicalRow(
            label: 'Duration',
            value: '2 weeks',
          ),
          const _ClinicalRow(
            label: 'Pattern',
            value: 'Worsens after prolonged sitting',
          ),
          const _ClinicalRow(
            label: 'Associated symptom',
            value: 'Occasional pain radiating to left leg',
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Source: Patient clinical history interview',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClinicalSummaryCard extends StatelessWidget {
  final TextEditingController controller;
  final bool editing;
  final VoidCallback onEdit;

  const _ClinicalSummaryCard({
    required this.controller,
    required this.editing,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _SectionCard(
      title: 'AI Clinical Summary',
      icon: Icons.auto_awesome_outlined,
      trailing: TextButton.icon(
        onPressed: onEdit,
        icon: Icon(
          editing ? Icons.check_outlined : Icons.edit_outlined,
          size: 18,
        ),
        label: Text(editing ? 'Done' : 'Edit'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.primaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.auto_awesome_outlined,
                  size: 20,
                  color: colors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'AI-assisted summary based only on information provided by the patient.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (editing)
            TextField(
              controller: controller,
              minLines: 5,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Clinical summary',
                alignLabelWithHint: true,
              ),
            )
          else
            Text(
              controller.text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.55,
                  ),
            ),
        ],
      ),
    );
  }
}

class _MissingInformationCard extends StatelessWidget {
  const _MissingInformationCard();

  @override
  Widget build(BuildContext context) {

    return _SectionCard(
      title: 'Missing Information',
      icon: Icons.help_outline_rounded,
      child: Column(
        children: const [
          _MissingItem(
            label: 'Pain severity',
            description: 'Patient has not provided a severity rating.',
          ),
          _MissingItem(
            label: 'Exact onset',
            description: 'The specific start date is not recorded.',
          ),
          _MissingItem(
            label: 'Previous treatment',
            description: 'No previous treatment details were provided.',
          ),
        ],
      ),
    );
  }
}

class _MissingItem extends StatelessWidget {
  final String label;
  final String description;

  const _MissingItem({
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colors.tertiaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.question_mark_rounded,
              size: 18,
              color: colors.onTertiaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
}

class _PriorityCard extends StatelessWidget {
  const _PriorityCard();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return _SectionCard(
      title: 'Priority Review',
      icon: Icons.flag_outlined,
      child: Container(
        width: double.infinity,
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
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No priority findings have been identified from the information currently captured. Review the patient information and clinical context before making decisions.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.45,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentsCard extends StatelessWidget {
  final void Function(String title, String type) onDocumentTap;

  const _DocumentsCard({
    required this.onDocumentTap,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Documents',
      icon: Icons.folder_open_outlined,
      child: Column(
        children: [
          _DocumentItem(
            icon: Icons.image_outlined,
            title: 'Previous Lumbar X-ray',
            subtitle: 'Uploaded during clinical history',
            onTap: () {
              onDocumentTap(
                'Previous Lumbar X-ray',
                'Medical image • Uploaded during clinical history',
              );
            },
          ),
          const SizedBox(height: 10),
          _DocumentItem(
            icon: Icons.description_outlined,
            title: 'Comprehensive Metabolic Panel',
            subtitle: 'Feb 14, 2026',
            onTap: () {
              onDocumentTap(
                'Comprehensive Metabolic Panel',
                'Laboratory report • Feb 14, 2026',
              );
            },
          ),
          const SizedBox(height: 10),
          _DocumentItem(
            icon: Icons.medication_outlined,
            title: 'Prescription',
            subtitle: 'Nov 03, 2025',
            onTap: () {
              onDocumentTap(
                'Prescription',
                'Prescription document • Nov 03, 2025',
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DocumentItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DocumentItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _MedicalTimeline extends StatelessWidget {
  const _MedicalTimeline();

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Medical Timeline',
      icon: Icons.timeline_outlined,
      child: Column(
        children: const [
          _TimelineEntry(
            year: '2026',
            icon: Icons.medical_services_outlined,
            title: 'Current Clinical Case',
            subtitle: 'Today • Cardiology Follow-up',
            description:
                'Lower back pain reported for 2 weeks with occasional radiation to the left leg.',
            current: true,
          ),
          _TimelineEntry(
            year: '2026',
            icon: Icons.water_drop_outlined,
            title: 'Comprehensive Metabolic Panel',
            subtitle: 'Feb 14, 2026 • Quest Diagnostics',
            description:
                'Total cholesterol: 240 mg/dL. Glucose: 95 mg/dL.',
          ),
          _TimelineEntry(
            year: '2025',
            icon: Icons.medication_outlined,
            title: 'Prescription Updated',
            subtitle: 'Nov 03, 2025 • Dr. Chinmayi',
            description:
                'Atorvastatin 20mg • 1 tablet daily at bedtime.',
          ),
          _TimelineEntry(
            year: '2024',
            icon: Icons.medical_information_outlined,
            title: 'Initial Diagnosis',
            subtitle: 'Jun 12, 2024 • General Hospital',
            description:
                'Essential (primary) hypertension • ICD-10: I10.',
          ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final String year;
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final bool current;

  const _TimelineEntry({
    required this.year,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    this.current = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: current
                  ? colors.primaryContainer
                  : colors.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 22,
              color: current
                  ? colors.onPrimaryContainer
                  : colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    Text(
                      year,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 7),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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

class _DoctorNotesCard extends StatelessWidget {
  final TextEditingController controller;

  const _DoctorNotesCard({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Doctor Notes',
      icon: Icons.edit_note_outlined,
      child: TextField(
        controller: controller,
        minLines: 3,
        maxLines: 6,
        decoration: const InputDecoration(
          hintText: 'Add notes for this case...',
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final bool verified;
  final VoidCallback onVerify;

  const _ReviewCard({
    required this.verified,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            verified ? 'Case Verified' : 'Review & Verify',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            verified
                ? 'You have verified the information currently available for this patient.'
                : 'Review the patient history, AI-assisted summary, documents and missing information before verification.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: verified ? null : onVerify,
              icon: Icon(
                verified
                    ? Icons.verified_rounded
                    : Icons.check_circle_outline_rounded,
              ),
              label: Text(
                verified ? 'Verified' : 'Verify Case',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Widget? trailing;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: colors.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 21,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

class _ClinicalRow extends StatelessWidget {
  final String label;
  final String value;

  const _ClinicalRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}