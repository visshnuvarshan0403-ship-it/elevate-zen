import 'package:flutter/material.dart';
import '../app/widgets/doctor_navigation_bar.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int selectedFilter = 0;

  final patients = const [
    _Patient(
      name: 'Nirunjhana',
      details: '45F • ID: RK-8902',
      time: '09:30 AM',
      status: 'Summary Ready',
      statusType: _PatientStatus.ready,
      initials: 'N',
    ),
    _Patient(
      name: 'Anita Rao',
      details: '32F • ID: AR-4419',
      time: '10:15 AM',
      status: 'Needs Review',
      statusType: _PatientStatus.review,
      initials: 'AR',
    ),
    _Patient(
      name: 'Sanjay Joshi',
      details: '58M • ID: SJ-1104',
      time: '11:00 AM',
      status: 'Processing Scan',
      statusType: _PatientStatus.processing,
      initials: 'SJ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  24,
                  28,
                  24,
                  120,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Greeting(),
                    const SizedBox(height: 36),
                    const _Statistics(),
                    const SizedBox(height: 36),
                    _PatientsHeader(
                      onViewAll: () {
                        Navigator.pushNamed(
                          context,
                          '/doctor/patients',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    _FilterBar(
                      selectedIndex: selectedFilter,
                      onSelected: (index) {
                        setState(() {
                          selectedFilter = index;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    ...patients.map(
                      (patient) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _PatientCard(
                          patient: patient,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/doctor/patient',
                              arguments: patient.initials,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DoctorNavigationBar(
        selectedIndex: 0,
        onSelected: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushReplacementNamed(
                context,
                '/doctor/patients',
              );
              break;
            case 2:
              Navigator.pushReplacementNamed(
                context,
                '/doctor/chat',
              );
              break;
          }
        },
      ),
    );
  }
}

enum _PatientStatus {
  ready,
  review,
  processing,
}

class _Patient {
  final String name;
  final String details;
  final String time;
  final String status;
  final _PatientStatus statusType;
  final String initials;

  const _Patient({
    required this.name,
    required this.details,
    required this.time,
    required this.status,
    required this.statusType,
    required this.initials,
  });
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.medical_information_outlined,
              color: colorScheme.onPrimaryContainer,
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            'Doctor Home',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/doctor/profile');
              },
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: colorScheme.primaryContainer,
                  child: Text(
                    'C',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, Dr. Chinmayi',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
                height: 1.15,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 27,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 9),
            Text(
              'General Medicine',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Statistics extends StatelessWidget {
  const _Statistics();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _StatisticCard(
            title: "TODAY'S PATIENTS",
            value: '24',
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            icon: Icons.person_outline,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatisticCard(
            title: 'PENDING REVIEWS',
            value: '6',
            backgroundColor: colorScheme.primaryContainer,
            foregroundColor: colorScheme.onPrimaryContainer,
            icon: Icons.description_outlined,
          ),
        ),
      ],
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  const _StatisticCard({
    required this.title,
    required this.value,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      padding: const EdgeInsets.fromLTRB(
        24,
        26,
        20,
        20,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      letterSpacing: 0.5,
                      color: foregroundColor.withValues(
                        alpha: 0.85,
                      ),
                    ),
              ),
              const Spacer(),
              Text(
                value,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w300,
                      color: foregroundColor,
                      height: 0.95,
                    ),
              ),
            ],
          ),
          Positioned(
            right: -5,
            top: -5,
            child: Icon(
              icon,
              size: 90,
              color: foregroundColor.withValues(
                alpha: 0.12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PatientsHeader extends StatelessWidget {
  final VoidCallback onViewAll;

  const _PatientsHeader({
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            "Today's Patients",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
          ),
        ),
        TextButton.icon(
          onPressed: onViewAll,
          icon: const Text('View All'),
          label: const Icon(
            Icons.chevron_right_rounded,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class _FilterBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _FilterBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const labels = [
      'All',
      'Ready',
      'Needs Review',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          labels.length,
          (index) {
            final selected = selectedIndex == index;

            return Padding(
              padding: EdgeInsets.only(
                right: index == labels.length - 1 ? 0 : 10,
              ),
              child: FilterChip(
                selected: selected,
                onSelected: (_) => onSelected(index),
                label: Text(labels[index]),
                avatar: index == 2
                    ? Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
                backgroundColor:
                    colorScheme.surfaceContainerHighest,
                selectedColor:
                    colorScheme.secondaryContainer,
                checkmarkColor:
                    colorScheme.onSecondaryContainer,
                labelStyle: TextStyle(
                  color: selected
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final _Patient patient;
  final VoidCallback onTap;

  const _PatientCard({
    required this.patient,
    required this.onTap,
  });

  Color _statusBackground(
    ColorScheme colorScheme,
  ) {
    switch (patient.statusType) {
      case _PatientStatus.ready:
        return colorScheme.primaryContainer;
      case _PatientStatus.review:
        return colorScheme.errorContainer;
      case _PatientStatus.processing:
        return colorScheme.surfaceContainerHighest;
    }
  }

  Color _statusForeground(
    ColorScheme colorScheme,
  ) {
    switch (patient.statusType) {
      case _PatientStatus.ready:
        return colorScheme.onPrimaryContainer;
      case _PatientStatus.review:
        return colorScheme.onErrorContainer;
      case _PatientStatus.processing:
        return colorScheme.onSurfaceVariant;
    }
  }

  IconData _statusIcon() {
    switch (patient.statusType) {
      case _PatientStatus.ready:
        return Icons.verified_outlined;
      case _PatientStatus.review:
        return Icons.error_outline;
      case _PatientStatus.processing:
        return Icons.more_horiz;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusBackground = _statusBackground(colorScheme);
    final statusForeground = _statusForeground(colorScheme);

    return Card(
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            18,
            18,
            14,
            18,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  _PatientAvatar(patient: patient),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          patient.details,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color:
                                    colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    patient.time,
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                          color: patient.statusType ==
                                  _PatientStatus.review
                              ? colorScheme.error
                              : colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: statusBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _statusIcon(),
                          size: 19,
                          color: statusForeground,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          patient.status,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                color: statusForeground,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (_) {},
                    icon: Icon(
                      Icons.more_vert,
                      color: colorScheme.onSurfaceVariant,
                      size: 27,
                    ),
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'view',
                        child: Text('View patient'),
                      ),
                      PopupMenuItem(
                        value: 'review',
                        child: Text('Review records'),
                      ),
                    ],
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

class _PatientAvatar extends StatelessWidget {
  final _Patient patient;

  const _PatientAvatar({
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: 38,
      backgroundColor: colorScheme.secondaryContainer,
      foregroundColor: colorScheme.onSecondaryContainer,
      child: Text(
          patient.initials,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
}