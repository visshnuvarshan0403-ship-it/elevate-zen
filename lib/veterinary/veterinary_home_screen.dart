import 'package:flutter/material.dart';
import '../app/widgets/veterinary_navigation_bar.dart';

class VeterinaryHomeScreen extends StatefulWidget {
  const VeterinaryHomeScreen({super.key});

  @override
  State<VeterinaryHomeScreen> createState() => _VeterinaryHomeScreenState();
}

class _VeterinaryHomeScreenState extends State<VeterinaryHomeScreen> {
  final List<_Pet> _pets = const [
    _Pet(
      name: 'Bruno',
      species: 'Dog',
      breed: 'Labrador Retriever',
      age: '4 years',
      sex: 'Male',
      weight: '24 kg',
      emoji: '🐕',
      status: 'Intake in progress',
    ),
    _Pet(
      name: 'Milo',
      species: 'Cat',
      breed: 'Persian',
      age: '2 years',
      sex: 'Female',
      weight: '4.2 kg',
      emoji: '🐈',
      status: 'Healthy • Vaccines Up to Date',
    ),
  ];

  int _selectedPetIndex = 0;

  _Pet get selectedPet => _pets[_selectedPetIndex];

  void _selectPet(int index) {
    setState(() {
      _selectedPetIndex = index;
    });
  }

  void _resumeIntake() {
    _showActiveIntakeSheet();
  }

  void _startIntake() {
    Navigator.pushNamed(
        context,
      '/veterinary/intake',
    );
  }

  void _viewPetProfile() {
    _showPetProfileSheet();
  }

  void _addPet() {
    _showComingSoon(
      'Add Pet',
      'Pet profile creation will be connected here.',
    );
  }

  void _openRecords() {
    _showComingSoon(
      'Veterinary Records',
      'Your pet health timeline will appear here.',
    );
  }

  void _showComingSoon(String title, String message) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.4,
                      ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Got it'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showActiveIntakeSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: colors.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Bruno's Active Intake",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            'AI Veterinary Intake',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Case completeness',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      '65%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const LinearProgressIndicator(
                    value: 0.65,
                    minHeight: 9,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Information collected',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),

                const SizedBox(height: 10),

                const _ChecklistItem(
                  label: 'Main complaint',
                  completed: true,
                ),
                const _ChecklistItem(
                  label: 'Duration',
                  completed: true,
                ),
                const _ChecklistItem(
                  label: 'Vomiting frequency',
                  completed: true,
                ),

                const SizedBox(height: 12),

                Text(
                  'Still needed',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),

                const SizedBox(height: 10),

                const _ChecklistItem(
                  label: 'Appetite',
                  completed: false,
                ),
                const _ChecklistItem(
                  label: 'Current medication',
                  completed: false,
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: colors.primary,
                        size: 22,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Last AI question: '
                          '"How many times has Bruno vomited since yesterday?"',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    height: 1.4,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.pushNamed(
                        context,
                        '/veterinary/intake',
                      );
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Resume Intake'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPetProfileSheet() {
    final pet = selectedPet;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        pet.emoji,
                        style: const TextStyle(fontSize: 36),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.name,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Text(
                            '${pet.species} • ${pet.breed}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _PetInfoTile(
                        label: 'Age',
                        value: pet.age,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PetInfoTile(
                        label: 'Sex',
                        value: pet.sex,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _PetInfoTile(
                        label: 'Weight',
                        value: pet.weight,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _startIntake();
                    },
                    icon: const Icon(Icons.chat_rounded),
                    label: Text('Start Intake for ${pet.name}'),
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
        automaticallyImplyLeading: true,
        backgroundColor: colors.surface,
        surfaceTintColor: colors.surfaceTint,
        elevation: 0,
        titleSpacing: 20,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ELEVATE ZEN • VET CARE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.7,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Vet Home',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              _showComingSoon(
                'Notifications',
                'Veterinary notifications will appear here.',
              );
            },
            icon: const Icon(Icons.notifications_none_rounded),
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
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompanionChip(context),

              const SizedBox(height: 12),

              Text(
                'Care for your pets',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
              ),

              const SizedBox(height: 6),

              Text(
                'AI-assisted veterinary intake & case preparation',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                      height: 1.35,
                    ),
              ),

              const SizedBox(height: 22),

              _buildAiHero(context),

              const SizedBox(height: 26),

              _buildPetsHeader(context),

              const SizedBox(height: 12),

              _buildPetList(context),

              const SizedBox(height: 18),

              _buildAssignedVetAndNextSlot(context),

              const SizedBox(height: 30),

              _buildRecentActivityHeader(context),

              const SizedBox(height: 12),

              _buildRecentActivity(context),

              const SizedBox(height: 18),

              _buildIntakeTip(context),
            ],
          ),
        ),
      ),

      bottomNavigationBar: VeterinaryNavigationBar(
        selectedIndex: 0,
        onSelected: (index) {
          switch (index) {
            case 0:
              break;

            case 1:
              // Veterinary Pets
              break;

            case 2:
               Navigator.pushNamed(
                context,
                '/veterinary/intake',
              );
              break;

            case 3:
               Navigator.pushReplacementNamed(
                context,
                '/veterinary/records',
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildCompanionChip(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 16,
            color: colors.onPrimaryContainer,
          ),
          const SizedBox(width: 7),
          Text(
            'Elevate Zen Companion',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiHero(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: colors.onPrimary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 16,
                      color: colors.onPrimary,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'Smart AI Intake',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Icon(
                Icons.shield_outlined,
                color: colors.onPrimary.withValues(alpha: 0.85),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            'AI Veterinary Intake',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colors.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),

          const SizedBox(height: 8),

          Text(
            'Describe what is happening with your pet. '
            'Elevate Zen helps organize symptoms and vital context '
            'before the veterinary consultation.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.92),
                  height: 1.45,
                ),
          ),

          const SizedBox(height: 18),

          InkWell(
            onTap: _resumeIntake,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: colors.onPrimary.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors.onPrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      'Active intake · ${selectedPet.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  Text(
                    '65%',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colors.onPrimary.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Vomiting • 1 day • 2 details needed',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.82),
                ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              onPressed: _resumeIntake,
              style: FilledButton.styleFrom(
                backgroundColor: colors.surface,
                foregroundColor: colors.primary,
              ),
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text(
                'Resume AI Intake',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: TextButton.icon(
              onPressed: _viewPetProfile,
              style: TextButton.styleFrom(
                foregroundColor: colors.onPrimary,
              ),
              icon: const Icon(
                Icons.badge_outlined,
                size: 19,
              ),
              label: const Text('View Pet Profile'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsHeader(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(
          'Your Pets',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_pets.length}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: _addPet,
          icon: const Icon(
            Icons.add_rounded,
            size: 18,
          ),
          label: const Text('Add Pet'),
        ),
      ],
    );
  }

  Widget _buildPetList(BuildContext context) {
    return Column(
      children: List.generate(
        _pets.length,
        (index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == _pets.length - 1 ? 0 : 12,
            ),
            child: _buildPetCard(
              context,
              pet: _pets[index],
              index: index,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPetCard(
    BuildContext context, {
    required _Pet pet,
    required int index,
  }) {
    final colors = Theme.of(context).colorScheme;
    final selected = index == _selectedPetIndex;

    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () => _selectPet(index),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Text(
                  pet.emoji,
                  style: const TextStyle(fontSize: 42),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pet.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        if (selected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Selected',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: colors.onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          )
                        else
                          Icon(
                            Icons.radio_button_unchecked_rounded,
                            size: 21,
                            color: colors.onSurfaceVariant,
                          ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '${pet.species} • ${pet.breed}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 2),

                    Text(
                      '${pet.age} • ${pet.sex} • ${pet.weight}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                    ),

                    const SizedBox(height: 9),

                    if (pet.status == 'Intake in progress')
                      _buildIntakeStatus(context)
                    else
                      _buildHealthyStatus(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntakeStatus(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.medical_information_outlined,
            size: 16,
            color: colors.primary,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              'Intake in progress',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const LinearProgressIndicator(
                value: 0.65,
                minHeight: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthyStatus(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_outlined,
            size: 16,
            color: colors.onSecondaryContainer,
          ),
          const SizedBox(width: 7),
          Text(
            'Healthy • Vaccines Up to Date',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSecondaryContainer,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignedVetAndNextSlot(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: _SmallInfoCard(
            icon: Icons.medical_services_outlined,
            title: 'Assigned Vet',
            value: 'Dr. Sarah ...',
            onTap: () {
              _showComingSoon(
                'Assigned Veterinarian',
                'Veterinarian details will appear here.',
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SmallInfoCard(
            icon: Icons.calendar_today_outlined,
            title: 'Next Slot',
            value: 'Today • 3:30 PM',
            onTap: () {
              _showComingSoon(
                'Next Appointment',
                'Appointment details will appear here.',
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivityHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const Spacer(),
        TextButton(
          onPressed: _openRecords,
          child: const Text('View all'),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      children: [
        _ActivityCard(
          icon: Icons.psychology_alt_outlined,
          title: 'AI Intake in Progress',
          subtitle: 'Bruno • Vomiting • 1 day',
          trailing: '10 mins ago',
          status: 'Needs follow-up',
          statusType: _ActivityStatus.warning,
          action: 'Resume',
          onTap: _resumeIntake,
        ),
        const SizedBox(height: 10),
        _ActivityCard(
          icon: Icons.medical_services_outlined,
          title: 'Veterinary Consultation',
          subtitle: 'Bruno • Routine Checkup & Weight Review',
          trailing: '14 Aug 2026',
          status: 'Completed',
          statusType: _ActivityStatus.completed,
          action: 'Summary',
          onTap: () {
            _showComingSoon(
              'Consultation Summary',
              'The verified veterinary consultation summary will appear here.',
            );
          },
        ),
        const SizedBox(height: 10),
        _ActivityCard(
          icon: Icons.vaccines_outlined,
          title: 'Vaccination Recorded',
          subtitle: 'Milo • Rabies Booster (Annual)',
          trailing: '02 Jul 2026',
          status: 'Verified',
          statusType: _ActivityStatus.verified,
          action: 'Certificate',
          onTap: () {
            _showComingSoon(
              'Vaccination Certificate',
              'The vaccination certificate will appear here.',
            );
          },
        ),
      ],
    );
  }

  Widget _buildIntakeTip(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
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
              Icons.spa_outlined,
              color: colors.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Intake Tip',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Accurate duration and symptom information helps your veterinarian review the case faster.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            break;

          case 1:
            _showComingSoon(
              'Pets',
              'Pet management will open here.',
            );
            break;

          case 2:
            _resumeIntake();
            break;

          case 3:
            _openRecords();
            break;
        }
      },
      height: 80,
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      indicatorColor: Theme.of(context).colorScheme.primaryContainer,
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      animationDuration: const Duration(milliseconds: 300),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.pets_outlined),
          selectedIcon: Icon(Icons.pets_rounded),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline_rounded),
          selectedIcon: Icon(Icons.person_rounded),
          label: 'Pets',
        ),
        NavigationDestination(
          icon: Icon(Icons.psychology_alt_outlined),
          selectedIcon: Icon(Icons.psychology_alt_rounded),
          label: 'Intake',
        ),
        NavigationDestination(
          icon: Icon(Icons.description_outlined),
          selectedIcon: Icon(Icons.description_rounded),
          label: 'Records',
        ),
      ],
    );
  }
}

class _Pet {
  final String name;
  final String species;
  final String breed;
  final String age;
  final String sex;
  final String weight;
  final String emoji;
  final String status;

  const _Pet({
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.sex,
    required this.weight,
    required this.emoji,
    required this.status,
  });
}

class _ChecklistItem extends StatelessWidget {
  final String label;
  final bool completed;

  const _ChecklistItem({
    required this.label,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 21,
            color: completed
                ? colors.primary
                : colors.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _PetInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _PetInfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _SmallInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SmallInfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 21,
                  color: colors.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ActivityStatus {
  warning,
  completed,
  verified,
}

class _ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;
  final String status;
  final _ActivityStatus statusType;
  final String action;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.status,
    required this.statusType,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    Color statusBackground;
    Color statusForeground;

    switch (statusType) {
      case _ActivityStatus.warning:
        statusBackground = colors.errorContainer;
        statusForeground = colors.onErrorContainer;
        break;

      case _ActivityStatus.completed:
        statusBackground = colors.primaryContainer;
        statusForeground = colors.onPrimaryContainer;
        break;

      case _ActivityStatus.verified:
        statusBackground = colors.surfaceContainerHighest;
        statusForeground = colors.onSurfaceVariant;
        break;
    }

    return Material(
      color: colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(width: 8),
                        Text(
                          trailing,
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(height: 9),

                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusBackground,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: statusForeground,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),

                        const Spacer(),

                        TextButton(
                          onPressed: onTap,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(action),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}