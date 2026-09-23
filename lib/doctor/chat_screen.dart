import 'package:flutter/material.dart';
import '../app/widgets/doctor_navigation_bar.dart';

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({super.key});

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final TextEditingController searchController =
      TextEditingController();

  final List<_Conversation> conversations = const [
    _Conversation(
      name: 'Nirunjhana',
      message: 'I have completed my clinical history...',
      time: '2m',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      unread: true,
      online: true,
    ),
    _Conversation(
      name: 'Anita Rao',
      message: 'I uploaded my latest lab report.',
      time: '1h',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      unread: false,
      online: true,
    ),
    _Conversation(
      name: 'Sanjay Joshi',
      message: 'Thank you doctor.',
      time: 'Yesterday',
      initials: 'SJ',
      unread: false,
      online: false,
    ),
  ];

  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.trim().toLowerCase();
    });
  }

  List<_Conversation> get filteredConversations {
    if (searchQuery.isEmpty) {
      return conversations;
    }

    return conversations
        .where(
          (conversation) =>
              conversation.name.toLowerCase().contains(searchQuery) ||
              conversation.message
                  .toLowerCase()
                  .contains(searchQuery),
        )
        .toList();
  }

  void _navigate(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          '/doctor',
        );
        break;
      case 1:
        Navigator.pushReplacementNamed(
          context,
          '/doctor/patients',
        );
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(
          context,
          '/doctor/profile',
        );
        break;
    }
  }

  void _openConversation(_Conversation conversation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorConversationScreen(
          conversation: conversation,
        ),
      ),
    );
  }

  void _newMessage() {
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
              28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Message',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Patient name',
                    prefixIcon: const Icon(
                      Icons.person_search_outlined,
                    ),
                    filled: true,
                    fillColor:
                        colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chat_outlined,
                    ),
                    label: const Text(
                      'Start conversation',
                    ),
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
    final colorScheme = Theme.of(context).colorScheme;
    final items = filteredConversations;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
              'Doctor Chat',
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
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: CircleAvatar(
              radius: 21,
              backgroundColor:
                  colorScheme.primaryContainer,
              child: Text(
                'AS',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      color:
                          colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                12,
              ),
              child: TextField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor:
                      colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(28),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? _EmptySearchState(
                      query: searchQuery,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        24,
                        8,
                        24,
                        100,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final conversation = items[index];

                        return _ConversationTile(
                          conversation: conversation,
                          onTap: () =>
                              _openConversation(
                            conversation,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newMessage,
        tooltip: 'New message',
        child: const Icon(
          Icons.edit_outlined,
        ),
      ),
      bottomNavigationBar: DoctorNavigationBar(
        selectedIndex: 2,
        onSelected: _navigate,
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final _Conversation conversation;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: conversation.unread
          ? colorScheme.surfaceContainerLow
          : colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            children: [
              _ConversationAvatar(
                conversation: conversation,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.name,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color:
                                      colorScheme.onSurface,
                                  fontWeight:
                                      conversation.unread
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          conversation.time,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: conversation.unread
                                    ? colorScheme.primary
                                    : colorScheme
                                        .onSurfaceVariant,
                                fontWeight:
                                    conversation.unread
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.message,
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: colorScheme
                                      .onSurfaceVariant,
                                  fontWeight:
                                      conversation.unread
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                ),
                          ),
                        ),
                        if (conversation.unread) ...[
                          const SizedBox(width: 10),
                          Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
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

class _ConversationAvatar extends StatelessWidget {
  final _Conversation conversation;

  const _ConversationAvatar({
    required this.conversation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: conversation.avatarUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(
                    conversation.avatarUrl!,
                  ),
                )
              : CircleAvatar(
                  backgroundColor:
                      colorScheme.primaryContainer,
                  child: Text(
                    conversation.initials ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          color:
                              colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
        ),
        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: conversation.online
                  ? colorScheme.primary
                  : colorScheme.outline,
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.surface,
                width: 3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptySearchState extends StatelessWidget {
  final String query;

  const _EmptySearchState({
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 56,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No conversations found',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 6),
            Text(
              'No messages match "$query".',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorConversationScreen extends StatefulWidget {
  final _Conversation conversation;

  const DoctorConversationScreen({
    super.key,
    required this.conversation,
  });

  @override
  State<DoctorConversationScreen> createState() =>
      _DoctorConversationScreenState();
}

class _DoctorConversationScreenState
    extends State<DoctorConversationScreen> {
  final TextEditingController messageController =
      TextEditingController();

  final List<_ChatMessage> messages = [
    const _ChatMessage(
      text:
      'Hello Doctor. I have completed the clinical history in Elevate Zen.',
      isDoctor: false,
      time: '10:12 AM',
    ),
    const _ChatMessage(
      text:
      'I can see your submitted information. I will review it before your consultation.',
      isDoctor: true,
      time: '10:14 AM',
    ),
    const _ChatMessage(
      text: 'I also uploaded my previous lumbar X-ray for review.',
      isDoctor: false,
      time: '10:16 AM',
    ),
  ];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      messages.add(
        _ChatMessage(
          text: text,
          isDoctor: true,
          time: _currentTime(),
        ),
      );
      messageController.clear();
    });
  }

  String _currentTime() {
    final now = TimeOfDay.now();
    return now.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        titleSpacing: 8,
        title: Row(
          children: [
            _ConversationAvatar(
              conversation: widget.conversation,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.name,
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
                    widget.conversation.online
                        ? 'Online'
                        : 'Offline',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                          color: widget.conversation.online
                              ? colorScheme.primary
                              : colorScheme
                                  .onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'More options',
            icon: const Icon(
              Icons.more_vert_rounded,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                20,
              ),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];

                return _ChatBubble(
                  message: message,
                );
              },
            ),
          ),
          _MessageComposer(
            controller: messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;

  const _ChatBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final backgroundColor = message.isDoctor
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;

    final foregroundColor = message.isDoctor
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;

    return Align(
      alignment: message.isDoctor
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 330,
        ),
        margin: const EdgeInsets.only(
          bottom: 12,
        ),
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
              message.isDoctor ? 20 : 5,
            ),
            bottomRight: Radius.circular(
              message.isDoctor ? 5 : 20,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.end,
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
            crossAxisAlignment:
                CrossAxisAlignment.end,
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
                  textInputAction:
                      TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Message patient about their case...',
                    filled: true,
                    fillColor:
                        colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(24),
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

class _Conversation {
  final String name;
  final String message;
  final String time;
  final String? avatarUrl;
  final String? initials;
  final bool unread;
  final bool online;

  const _Conversation({
    required this.name,
    required this.message,
    required this.time,
    this.avatarUrl,
    this.initials,
    required this.unread,
    required this.online,
  });
}

class _ChatMessage {
  final String text;
  final bool isDoctor;
  final String time;

  const _ChatMessage({
    required this.text,
    required this.isDoctor,
    required this.time,
  });
}