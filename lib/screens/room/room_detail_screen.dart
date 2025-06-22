import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../models/event.dart';
import '../../models/message.dart';
import '../../models/room.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/room_provider.dart';
import '../../widgets/chat/chat_bubble.dart';
import '../../widgets/chat/chat_input.dart';

class RoomDetailScreen extends StatefulWidget {
  final Room room;
  final Event? event;

  const RoomDetailScreen({
    Key? key,
    required this.room,
    this.event,
  }) : super(key: key);

  @override
  _RoomDetailScreenState createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  bool _isJoining = false;
  bool _isRoomJoined = false;
  bool _isSaved = false;
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _joinRoom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    _typingTimer?.cancel();
    _leaveRoom();
    super.dispose();
  }

  Future<void> _joinRoom() async {
    setState(() {
      _isJoining = true;
    });

    // final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // // Set token for room provider if not already set
    // if (authProvider.isAuthenticated) {
    //   roomProvider.setToken(authProvider.token!);

    //   // Attempt to join the room via API and connect to WebSocket
    //   final success =
    //       await roomProvider.joinRoom(widget.room.id, authProvider.token!);

    //   if (!success && mounted) {
    //     // If API/WebSocket connection fails, fallback to using mock data for demo
    //     roomProvider.setMockMessagesForRoom();

    //     // Show error snackbar
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(
    //             'Could not connect to chat: ${roomProvider.error ?? "Unknown error"}'),
    //         backgroundColor: Colors.orange,
    //         duration: const Duration(seconds: 3),
    //       ),
    //     );
    //   }
    // } else {
    //   // Not authenticated, use mock data for demo
    //   roomProvider.setMockMessagesForRoom();
    // }

    // if (mounted) {
    setState(() {
      _isJoining = false;
      _isRoomJoined = true;
    });
    // }

    // Check if room is saved
    // User? user = authProvider.user;
    // if (user != null && mounted) {
    //   setState(() {
    //     _isSaved = user.favoriteRooms.contains(widget.room.id);
    //   });
    // }

    // Scroll to bottom of chat after a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _leaveRoom() {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    // Disconnect from WebSocket and clear room data
    if (roomProvider.isConnected) {
      roomProvider.leaveRoom(widget.room.id).then((_) {
        roomProvider.clearSelectedRoom();
      }).catchError((error) {
        // Just disconnect from WebSocket if API call fails
        roomProvider.webSocketService.disconnect();
        roomProvider.clearSelectedRoom();
      });
    } else {
      roomProvider.clearSelectedRoom();
    }
  }

  void _toggleSavedStatus() async {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    setState(() {
      _isSaved = !_isSaved;
    });

    // In a real app, this would call the API
    if (_isSaved) {
      await roomProvider.saveRoom(widget.room.id);
    } else {
      await roomProvider.unsaveRoom(widget.room.id);
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final roomProvider = Provider.of<RoomProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final User? user = authProvider.user;
    print("user: $user");

    if (user == null) return;

    // Using WebSocket to send the message
    // just for testing change the values of check !
    if (!roomProvider.isConnected) {
      // This will send via WebSocket
      roomProvider.sendMessage(text);

      // The WebSocketService will handle receiving the message back from the server
      // and adding it to the messages list via the messageStream
    } else {
      // Fallback for demo/offline mode - add the message directly
      final newMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        roomId: widget.room.id,
        senderId: user.id,
        senderUsername: user.username,
        senderProfileImageUrl: user.profileImageUrl,
        content: text,
        type: MessageType.text,
        timestamp: DateTime.now(),
        readBy: [user.id],
      );

      roomProvider.messages.add(newMessage);
      roomProvider.notifyListeners();

      // Show offline indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'You are offline. Messages will be queued until reconnected.'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
    }

    // Scroll to bottom - do this regardless of connection status
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleTyping(bool isTyping) {
    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    if (_isTyping != isTyping) {
      _isTyping = isTyping;
      roomProvider.sendTypingStatus(isTyping);
    }

    // Reset typing timer
    _typingTimer?.cancel();
    if (isTyping) {
      _typingTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          roomProvider.sendTypingStatus(false);
          _isTyping = false;
        }
      });
    }
  }

  void _showParticipants() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ParticipantsBottomSheet(
        participants: widget.room.participants,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.room.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (widget.event != null)
              Text(
                widget.event!.title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? AppTheme.accentColor : null,
            ),
            onPressed: _toggleSavedStatus,
          ),
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: _showParticipants,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: const Color.fromARGB(255, 251, 251, 251),
          unselectedLabelColor: const Color.fromARGB(255, 190, 188, 242),
          tabs: const [
            Tab(text: 'Chat'),
            Tab(text: 'About'),
          ],
        ),
      ),
      body: _isJoining
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Chat tab
                _buildChatTab(),

                // About tab
                _buildAboutTab(),
              ],
            ),
    );
  }

  Widget _buildChatTab() {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) {
        print("from room detail screen: ${roomProvider.messages.length}");
        final messages = roomProvider.messages;
        final isConnected = roomProvider.isConnected;
        final typingUsers = roomProvider.typingUsers;

        return Column(
          children: [
            // Connection status banner
            if (!isConnected)
              Container(
                padding: const EdgeInsets.all(8),
                color: AppTheme.warning.withOpacity(0.2),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Connecting to chat...',
                        style: TextStyle(
                          color: AppTheme.warning,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppTheme.warning),
                      ),
                    ),
                  ],
                ),
              ),

            // Typing indicator
            if (typingUsers.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                alignment: Alignment.centerLeft,
                child: Text(
                  '${typingUsers.keys.join(", ")} ${typingUsers.length == 1 ? "is" : "are"} typing...',
                  style: const TextStyle(
                    color: AppTheme.textLightSecondary,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),

            // Chat messages
            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text(
                        'No messages yet. Start the conversation!',
                        style: TextStyle(
                          color: AppTheme.textLightSecondary,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        final isCurrentUser =
                            authProvider.user?.id == message.senderId;

                        // Show date separator for first message or when date changes
                        final bool showDateSeparator = index == 0 ||
                            !_isSameDay(messages[index - 1].timestamp,
                                message.timestamp);

                        return Column(
                          children: [
                            if (showDateSeparator)
                              _buildDateSeparator(message.timestamp),
                            ChatBubble(
                              message: message,
                              isCurrentUser: isCurrentUser,
                            ),
                          ],
                        );
                      },
                    ),
            ),

            // Chat input
            ChatInput(
              onSend: _sendMessage,
              onTyping: _handleTyping,
              enabled: isConnected,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room details card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Room Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.title,
                    title: 'Name',
                    value: widget.room.title,
                  ),
                  _buildDetailRow(
                    icon: Icons.people,
                    title: 'Participants',
                    value: '${widget.room.participants.length}',
                  ),
                  _buildDetailRow(
                    icon: Icons.chat,
                    title: 'Messages',
                    value: '${widget.room.messageCount}',
                  ),
                  _buildDetailRow(
                    icon: Icons.access_time,
                    title: 'Created',
                    value: _formatDate(widget.room.createdAt),
                  ),
                  if (widget.room.lastActivityAt != null)
                    _buildDetailRow(
                      icon: Icons.update,
                      title: 'Last Activity',
                      value: _formatRelativeTime(widget.room.lastActivityAt!),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.room.description,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textLightSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Room captain card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Room Captain',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCaptainInfo(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.fork_right),
                  label: const Text('Fork Room'),
                  onPressed: () {
                    // Show fork room dialog (not implemented for demo)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fork Room feature coming soon!'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('Leave Room'),
                  onPressed: () {
                    _leaveRoom();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: AppTheme.textLightPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCaptainInfo() {
    // Find captain in participants list
    final captain = widget.room.participants.firstWhere(
      (p) => p.userId == widget.room.captainId,
      orElse: () => Participant(
        userId: 'unknown',
        username: 'Unknown Captain',
        tier: ParticipantTier.captain,
        joinedAt: DateTime.now(),
      ),
    );

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          radius: 24,
          child: captain.profileImageUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    captain.profileImageUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                )
              : Text(
                  captain.username.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                captain.username,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Captain',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Since ${_formatDate(captain.joinedAt)}',
                    style: const TextStyle(
                      color: AppTheme.textLightSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 12),
          Text(
            '$title:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppTheme.textLightSecondary,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSeparator(DateTime date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Expanded(
            child: Divider(thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              _formatMessageDate(date),
              style: const TextStyle(
                color: AppTheme.textLightSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(
            child: Divider(thickness: 1),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatMessageDate(DateTime date) {
    final now = DateTime.now();

    if (_isSameDay(date, now)) {
      return 'Today';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return _formatDate(date);
    }
  }
}

class _ParticipantsBottomSheet extends StatelessWidget {
  final List<Participant> participants;

  const _ParticipantsBottomSheet({
    Key? key,
    required this.participants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort participants by tier
    final sortedParticipants = [...participants];
    sortedParticipants.sort((a, b) {
      return a.tier.index.compareTo(b.tier.index);
    });

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Participants',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${participants.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(
            child: ListView.builder(
              itemCount: sortedParticipants.length,
              itemBuilder: (context, index) {
                final participant = sortedParticipants[index];
                return _buildParticipantTile(participant);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantTile(Participant participant) {
    String tierLabel;
    Color tierColor;

    switch (participant.tier) {
      case ParticipantTier.captain:
        tierLabel = 'Captain';
        tierColor = AppTheme.primaryColor;
        break;
      case ParticipantTier.permanentSpeaker:
        tierLabel = 'Permanent Speaker';
        tierColor = AppTheme.accentColor;
        break;
      case ParticipantTier.guestSpeaker:
        tierLabel = 'Guest Speaker';
        tierColor = Colors.grey;
        break;
      case ParticipantTier.member:
        tierLabel = 'Member';
        tierColor = Colors.green;
        break;
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: tierColor.withOpacity(0.8),
        radius: 20,
        child: participant.profileImageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  participant.profileImageUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              )
            : Text(
                participant.username.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      title: Row(
        children: [
          Text(
            participant.username,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: tierColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              tierLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        'Joined ${_formatJoinTime(participant.joinedAt)}',
        style: const TextStyle(
          fontSize: 12,
          color: AppTheme.textLightSecondary,
        ),
      ),
    );
  }

  String _formatJoinTime(DateTime joinTime) {
    final now = DateTime.now();
    final difference = now.difference(joinTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${joinTime.day}/${joinTime.month}/${joinTime.year}';
    }
  }
}
