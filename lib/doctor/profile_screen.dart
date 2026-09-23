import 'package:flutter/material.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({super.key});

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool pushNotifications = true;

  void _showEditProfile() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              8,
              24,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Profile',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person_outline,
                      color:
                          colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: const Text('Edit profile information'),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        colorScheme.secondaryContainer,
                    child: Icon(
                      Icons.photo_camera_outlined,
                      color:
                          colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: const Text('Change profile photo'),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAvailability() {
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
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manage Availability',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 20),
                const ListTile(
                  leading: Icon(
                    Icons.calendar_today_outlined,
                  ),
                  title: Text('Monday – Friday'),
                  subtitle: Text('09:00 AM – 05:00 PM'),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.access_time_outlined,
                  ),
                  title: Text('Saturday'),
                  subtitle: Text('09:00 AM – 01:00 PM'),
                ),
                const ListTile(
                  leading: Icon(
                    Icons.event_busy_outlined,
                  ),
                  title: Text('Sunday'),
                  subtitle: Text('Unavailable'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _signOut() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.medical_information_outlined,
                color: colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Doctor Profile',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 21,
              backgroundColor: colorScheme.primary,
              child: Text(
                'C',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            34,
            24,
            32,
          ),
          child: Column(
            children: [
              _ProfileHero(
                onEdit: _showEditProfile,
              ),
              const SizedBox(height: 38),
              const _ProfessionalDetails(),
              const SizedBox(height: 20),
              const _ContactInformation(),
              const SizedBox(height: 20),
              _SettingsSection(
                pushNotifications: pushNotifications,
                onNotificationsChanged: (value) {
                  setState(() {
                    pushNotifications = value;
                  });
                },
                onAvailabilityTap: _showAvailability,
                onSignOut: _signOut,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final VoidCallback onEdit;

  const _ProfileHero({
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(
                      alpha: 0.16,
                    ),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'C',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: FloatingActionButton.small(
                onPressed: onEdit,
                elevation: 2,
                backgroundColor:
                    colorScheme.surfaceContainerHighest,
                foregroundColor:
                    colorScheme.onSurface,
                child: const Icon(
                  Icons.edit_outlined,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          'Dr. Chinmayi',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(
                fontWeight: FontWeight.w400,
                color: colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Senior Cardiologist',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 20),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            _StatusChip(
              icon: Icons.check_circle_outline,
              label: 'Available Today',
              backgroundColor:
                  colorScheme.primaryContainer,
              foregroundColor:
                  colorScheme.onPrimaryContainer,
            ),
            _StatusChip(
              label: 'MBBS, MD',
              backgroundColor:
                  colorScheme.secondaryContainer,
              foregroundColor:
                  colorScheme.onSecondaryContainer,
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const _StatusChip({
    this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: foregroundColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(
                  color: foregroundColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _ProfessionalDetails extends StatelessWidget {
  const _ProfessionalDetails();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _ProfileSection(
      title: 'Professional Details',
      children: [
        _InformationTile(
          icon: Icons.medical_services_outlined,
          iconBackground:
              colorScheme.primaryContainer,
          iconColor:
              colorScheme.onPrimaryContainer,
          label: 'Specialization',
          value: 'Cardiology',
        ),
        const SizedBox(height: 8),
        _InformationTile(
          icon: Icons.local_hospital_outlined,
          iconBackground:
              colorScheme.primaryContainer,
          iconColor:
              colorScheme.onPrimaryContainer,
          label: 'Primary Hospital',
          value: 'City Heart Institute',
        ),
        const SizedBox(height: 8),
        _InformationTile(
          icon: Icons.workspace_premium_outlined,
          iconBackground:
              colorScheme.primaryContainer,
          iconColor:
              colorScheme.onPrimaryContainer,
          label: 'Experience',
          value: '12 Years',
        ),
      ],
    );
  }
}

class _ContactInformation extends StatelessWidget {
  const _ContactInformation();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _ProfileSection(
      title: 'Contact Information',
      children: [
        _InformationTile(
          icon: Icons.email_outlined,
          iconBackground:
              colorScheme.surfaceContainerHighest,
          iconColor:
              colorScheme.onSurfaceVariant,
          label: 'Email',
          value: 'dr.chinmayi@cityheart.edu',
          trailing: const Icon(
            Icons.chevron_right_rounded,
          ),
        ),
        const SizedBox(height: 8),
        _InformationTile(
          icon: Icons.phone_outlined,
          iconBackground:
              colorScheme.surfaceContainerHighest,
          iconColor:
              colorScheme.onSurfaceVariant,
          label: 'Phone',
          value: '+91 98765 43210',
          trailing: const Icon(
            Icons.chevron_right_rounded,
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final bool pushNotifications;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onAvailabilityTap;
  final VoidCallback onSignOut;

  const _SettingsSection({
    required this.pushNotifications,
    required this.onNotificationsChanged,
    required this.onAvailabilityTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return _ProfileSection(
      title: 'Settings & Preferences',
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          child: Row(
            children: [
              _SettingIcon(
                icon: Icons.notifications_none_outlined,
                backgroundColor:
                    colorScheme.surfaceContainerHighest,
                foregroundColor:
                    colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  'Push Notifications',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                ),
              ),
              Switch(
                value: pushNotifications,
                onChanged: onNotificationsChanged,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onAvailabilityTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Row(
              children: [
                _SettingIcon(
                  icon: Icons.calendar_month_outlined,
                  backgroundColor:
                      colorScheme.surfaceContainerHighest,
                  foregroundColor:
                      colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    'Manage Availability',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onSignOut,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 10,
            ),
            child: Row(
              children: [
                _SettingIcon(
                  icon: Icons.logout_rounded,
                  backgroundColor:
                      colorScheme.errorContainer,
                  foregroundColor:
                      colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 18),
                Text(
                  'Sign Out',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SettingIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;

  const _SettingIcon({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: foregroundColor,
        size: 27,
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ProfileSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          22,
          22,
          22,
          20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8,
                bottom: 14,
              ),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InformationTile extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String label;
  final String value;
  final Widget? trailing;

  const _InformationTile({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 26,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            IconTheme(
              data: IconThemeData(
                color: colorScheme.onSurfaceVariant,
                size: 28,
              ),
              child: trailing!,
            ),
        ],
      ),
    );
  }
}