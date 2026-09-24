import 'package:flutter/material.dart';

import '../app/widgets/veterinary_navigation_bar.dart';

class VeterinaryRecordsScreen extends StatefulWidget {
  const VeterinaryRecordsScreen({super.key});

  @override
  State<VeterinaryRecordsScreen> createState() =>
      _VeterinaryRecordsScreenState();
}

class _VeterinaryRecordsScreenState
    extends State<VeterinaryRecordsScreen> {
  int _selectedTab = 0;

  void _onNavigationSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/veterinary');
        break;

      case 1:
        Navigator.pop(context);
        break;

      case 2:
        Navigator.pushNamed(
          context,
          '/veterinary/intake',
        );
        break;

      case 3:
        break;
    }
  }

  void _addRecord() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              30,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Health Record',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                _recordOption(
                  context,
                  Icons.description_outlined,
                  'Clinical Record',
                  'Add a consultation or medical record.',
                ),
                _recordOption(
                  context,
                  Icons.vaccines_outlined,
                  'Vaccination',
                  'Add vaccination information.',
                ),
                _recordOption(
                  context,
                  Icons.upload_file_outlined,
                  'Upload Document',
                  'Attach a veterinary document.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _recordOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: colors.primaryContainer,
        child: Icon(
          icon,
          color: colors.onPrimaryContainer,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.pop(context);

        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            content: Text('$title will be added here.'),
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
        backgroundColor: colors.surface,
        surfaceTintColor: colors.surfaceTint,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ELEVATE ZEN • VET CARE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.7,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Vet Records',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 17,
              backgroundColor: colors.primary,
              child: Icon(
                Icons.person_outline_rounded,
                color: colors.onPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            28,
          ),
          child: Column(
            children: [
              _buildPetHeader(colors),

              const SizedBox(height: 14),

              _buildTabs(colors),

              const SizedBox(height: 20),

              _buildStats(colors),

              const SizedBox(height: 18),

              _buildAddRecord(colors),

              const SizedBox(height: 22),

              _buildTimeline(colors),

              const SizedBox(height: 18),

              _buildSyncCard(colors),
            ],
          ),
        ),
      ),

      bottomNavigationBar: VeterinaryNavigationBar(
        selectedIndex: 3,
        onSelected: _onNavigationSelected,
      ),
    );
  }

  Widget _buildPetHeader(ColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        14,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🐕',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bruno's Health Records",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Verified clinical history & timeline',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(ColorScheme colors) {
    final tabs = [
      (
        Icons.show_chart_rounded,
        'Timeline',
      ),
      (
        Icons.vaccines_outlined,
        'Vaccines',
      ),
      (
        Icons.folder_outlined,
        'Documents',
      ),
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = _selectedTab == index;

          return FilledButton.icon(
            onPressed: () {
              setState(() {
                _selectedTab = index;
              });
            },
            style: FilledButton.styleFrom(
              backgroundColor: selected
                  ? colors.primary
                  : colors.surfaceContainerHighest,
              foregroundColor: selected
                  ? colors.onPrimary
                  : colors.onSurface,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            icon: Icon(
              tabs[index].$1,
              size: 17,
            ),
            label: Text(tabs[index].$2),
          );
        },
      ),
    );
  }

  Widget _buildStats(ColorScheme colors) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Weight',
            value: '24.2 kg',
            subtitle: 'Healthy',
            icon: Icons.monitor_weight_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: 'Vaccine',
            value: 'Current',
            subtitle: 'Nov 2026',
            icon: Icons.verified_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: 'Next Exam',
            value: 'In 3 Mo',
            subtitle: 'Routine',
            icon: Icons.calendar_month_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildAddRecord(ColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            Icons.menu_book_outlined,
            color: colors.onPrimaryContainer,
          ),

          const SizedBox(width: 10),

          const Expanded(
            child: Text(
              'Have an external record?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          FilledButton.icon(
            onPressed: _addRecord,
            icon: const Icon(
              Icons.add_rounded,
              size: 19,
            ),
            label: const Text('Add Record'),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(ColorScheme colors) {
    return Column(
      children: [
        _TimelineEntry(
          date: 'SEP 24, 2026',
          status: 'Veterinarian Verified',
          title: 'Acute Vomiting Episode',
          doctor: 'Dr. Rajesh Rao • Paws & Claws Veterinary Care',
          description:
              'AI Intake structured 3–5 vomiting episodes. '
              'Dog presented with mild acute gastrointestinal '
              'symptoms. Clinical information prepared for '
              'veterinary review.',
          tags: const [
            'AI Intake',
            'Veterinarian Verified',
          ],
          icon: Icons.medical_services_outlined,
          iconColor: colors.primary,
          buttonText: 'View Verified Case File',
          onPressed: () {},
        ),

        _TimelineEntry(
          date: 'AUG 14, 2026',
          status: 'Completed',
          title: 'Routine Wellness Consultation & Stool Screen',
          doctor: 'Paws & Claws Veterinary Care',
          description:
              'Annual physical examination and stool screening '
              'recorded. Weight maintained at 24.2 kg.',
          tags: const [
            'Wellness',
            'Stool Screen',
          ],
          icon: Icons.shield_outlined,
          iconColor: colors.primary,
        ),

        _TimelineEntry(
          date: 'JUL 02, 2026',
          status: 'Recorded & Certified',
          title: 'Annual Rabies & DHPP Booster',
          doctor: 'Batch #RB-2026-992',
          description:
              'Vaccination record added to Bruno’s health timeline. '
              'Next review scheduled according to the vaccination record.',
          tags: const [
            'Rabies',
            'DHPP',
          ],
          icon: Icons.vaccines_outlined,
          iconColor: colors.primary,
          buttonText: 'Certificate PDF',
          onPressed: () {},
        ),

        _TimelineEntry(
          date: 'MAY 12, 2024',
          status: 'Resolved',
          title: 'Benign Histiocytoma Resolution',
          doctor: 'Cytology Confirmed',
          description:
              'Previous skin condition recorded as resolved. '
              'Full remission was confirmed in the historical record.',
          tags: const [
            'Resolved',
          ],
          icon: Icons.biotech_outlined,
          iconColor: colors.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _buildSyncCard(ColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cloud_done_outlined,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All 4 entries synchronized',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Encrypted medical ledger with veterinary records',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 105,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(
                icon,
                size: 16,
                color: colors.primary,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: colors.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineEntry extends StatelessWidget {
  final String date;
  final String status;
  final String title;
  final String doctor;
  final String description;
  final List<String> tags;
  final IconData icon;
  final Color iconColor;
  final String? buttonText;
  final VoidCallback? onPressed;

  const _TimelineEntry({
    required this.date,
    required this.status,
    required this.title,
    required this.doctor,
    required this.description,
    required this.tags,
    required this.icon,
    required this.iconColor,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: iconColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: colors.outlineVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          date,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            status,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: colors.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    doctor,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: colors.onSurfaceVariant,
                    ),
                  ),

                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 7,
                      runSpacing: 6,
                      children: tags.map(
                        (tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ],

                  if (buttonText != null) ...[
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 42,
                      child: FilledButton.icon(
                        onPressed: onPressed,
                        icon: const Icon(
                          Icons.verified_outlined,
                          size: 18,
                        ),
                        label: Text(buttonText!),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}