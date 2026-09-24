import 'package:flutter/material.dart';
import '../app/widgets/patient_navigation_bar.dart';

class PatientDoctorChatScreen extends StatefulWidget {
  const PatientDoctorChatScreen({super.key});

  @override
  State<PatientDoctorChatScreen> createState() =>
      _PatientDoctorChatScreenState();
}

class _PatientDoctorChatScreenState
    extends State<PatientDoctorChatScreen> {
  final TextEditingController _messageController =
      TextEditingController();

  final List<_Message> _messages = [
    const _Message(
      text: 'Hello. I have reviewed your submitted clinical history.',
      isDoctor: true,
      time: '10:14 AM',
    ),
    const _Message(
      text: 'I also uploaded my previous lab report for review.',
      isDoctor: false,
      time: '10:16 AM',
    ),
    const _Message(
      text: 'Thank you. I will review the report before your consultation.',
      isDoctor: true,
      time: '10:17 AM',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        _Message(
          text: text,
          isDoctor: false,
          time: TimeOfDay.now().format(context),
        ),
      );
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 16,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: colorScheme.primaryContainer,
              foregroundColor: colorScheme.onPrimaryContainer,
              child: const Text(
                'DC',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dr. Chinmayi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    'Senior Cardiologist',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {},
              tooltip: 'More options',
              icon: const Icon(
                Icons.more_vert_rounded,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.medical_information_outlined,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This conversation is related to your current case.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                20,
              ),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _ChatBubble(
                  message: _messages[index],
                );
              },
            ),
          ),
          _MessageComposer(
            controller: _messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
      bottomNavigationBar: PatientNavigationBar(
        selectedIndex: 2,
        onSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                context,
                '/patient/home',
              );
              break;
            case 1:
              Navigator.pushReplacementNamed(
                context,
                '/patient/previous-records',
              );
              break;
            case 2:
              break;
            case 3:
              Navigator.pushReplacementNamed(
                context,
                '/patient/profile',
              );
              break;
          }
        },
      )
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _Message message;

  const _ChatBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = message.isDoctor
        ? colorScheme.surfaceContainerHighest
        : colorScheme.primaryContainer;

    final foregroundColor = message.isDoctor
        ? colorScheme.onSurface
        : colorScheme.onPrimaryContainer;

    return Align(
      alignment: message.isDoctor
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 330,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(
          16,
          12,
          16,
          9,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(
              message.isDoctor ? 5 : 20,
            ),
            bottomRight: Radius.circular(
              message.isDoctor ? 20 : 5,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                message.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      color: foregroundColor,
                      height: 1.4,
                    ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              message.time,
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(
                    color: foregroundColor.withValues(
                      alpha: 0.7,
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageComposer({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            12,
            8,
            12,
            12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                tooltip: 'Attach',
                icon: const Icon(
                  Icons.attach_file_rounded,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Message Dr. Chinmayi...',
                    filled: true,
                    fillColor:
                        colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                onPressed: onSend,
                tooltip: 'Send',
                icon: const Icon(
                  Icons.send_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isDoctor;
  final String time;

  const _Message({
    required this.text,
    required this.isDoctor,
    required this.time,
  });
}