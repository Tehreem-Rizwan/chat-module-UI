import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../models/event.dart';
import '../../models/room.dart';
import '../../providers/room_provider.dart';
import '../../widgets/room/room_card.dart';
import 'room_detail_screen.dart';

class RoomListScreen extends StatefulWidget {
  final Event? event;
  final bool isSavedRooms;

  const RoomListScreen({
    Key? key,
    this.event,
    required this.isSavedRooms,
  }) : super(key: key);

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    setState(() {
      _isLoading = true;
    });

    final roomProvider = Provider.of<RoomProvider>(context, listen: false);

    if (widget.isSavedRooms) {
      // Load saved rooms from API or fallback to mock data
      await roomProvider.fetchSavedRooms();
    } else if (widget.event != null) {
      // Load rooms for the selected event from API or fallback to mock data
      await roomProvider.fetchRoomsForEvent(widget.event!.id);
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshRooms() async {
    await _loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton:
          widget.event != null ? _buildCreateRoomButton() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        widget.isSavedRooms
            ? 'Saved Rooms'
            : widget.event != null
                ? widget.event!.title
                : 'Rooms',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 0,
      backgroundColor: widget.isSavedRooms
          ? Theme.of(context).scaffoldBackgroundColor
          : AppTheme.primaryColor,
      foregroundColor:
          widget.isSavedRooms ? AppTheme.textLightPrimary : Colors.white,
      centerTitle: true,
      actions: [
        if (!widget.isSavedRooms && widget.event != null)
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showEventDetails(context, widget.event!),
          ),
      ],
    );
  }

  Widget _buildBody() {
    return Consumer<RoomProvider>(
      builder: (context, roomProvider, child) {
        List<Room> rooms = widget.isSavedRooms
            ? roomProvider.savedRooms
            : roomProvider.eventRooms;

        if (_isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (roomProvider.error != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: ${roomProvider.error}',
                  style: const TextStyle(color: AppTheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _refreshRooms,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (rooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 64,
                  color: AppTheme.textLightSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.isSavedRooms
                      ? 'You haven\'t saved any rooms yet'
                      : 'No rooms available for this event',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textLightSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                if (!widget.isSavedRooms && widget.event != null)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create a Room'),
                    onPressed: () => _createRoom(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshRooms,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: RoomCard(
                  room: rooms[index],
                  event: widget.event,
                  onTap: () => _navigateToRoomDetail(rooms[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCreateRoomButton() {
    return FloatingActionButton(
      onPressed: () => _createRoom(context),
      backgroundColor: AppTheme.accentColor,
      child: const Icon(Icons.add),
    );
  }

  void _navigateToRoomDetail(Room room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RoomDetailScreen(room: room, event: widget.event),
      ),
    );
  }

  void _createRoom(BuildContext context) {
    if (widget.event == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CreateRoomBottomSheet(eventId: widget.event!.id),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure we have data loaded when the screen is shown
    if (!_isLoading && (widget.event != null || widget.isSavedRooms)) {
      _loadRooms();
    }
  }

  void _showEventDetails(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EventDetailsBottomSheet(event: event),
    );
  }
}

class _CreateRoomBottomSheet extends StatefulWidget {
  final String eventId;

  const _CreateRoomBottomSheet({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  __CreateRoomBottomSheetState createState() => __CreateRoomBottomSheetState();
}

class __CreateRoomBottomSheetState extends State<_CreateRoomBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isCreating = true;
      });

      final roomProvider = Provider.of<RoomProvider>(context, listen: false);

      // For demo purposes, simulate room creation
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock success and close the sheet
      Navigator.pop(context);

      // Refresh room list with mock data
      roomProvider.setMockRoomsForEvent(widget.eventId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create a Room',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Room Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                if (value.length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textLightSecondary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : _createRoom,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isCreating
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Create'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EventDetailsBottomSheet extends StatelessWidget {
  final Event event;

  const _EventDetailsBottomSheet({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;

    switch (event.status) {
      case EventStatus.live:
        statusText = 'LIVE NOW';
        statusColor = Colors.red;
        break;
      case EventStatus.upcoming:
        statusText = 'UPCOMING';
        statusColor = AppTheme.primaryColor;
        break;
      case EventStatus.completed:
        statusText = 'COMPLETED';
        statusColor = Colors.grey;
        break;
    }

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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Event image with gradient overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  event.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.category,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Event details
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        icon: Icons.trending_up,
                        value: event.trendscore.toString(),
                        label: 'Trending',
                      ),
                      _buildStatItem(
                        icon: Icons.chat,
                        value: event.roomCount.toString(),
                        label: 'Rooms',
                      ),
                      _buildStatItem(
                        icon: Icons.people,
                        value: event.participantCount.toString(),
                        label: 'Participants',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  const Text(
                    'About',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: const TextStyle(
                      color: AppTheme.textLightSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Time
                  const Text(
                    'Time',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: AppTheme.textLightSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_formatDate(event.startTime)} - ${event.endTime != null ? _formatDate(event.endTime!) : 'TBD'}',
                        style: const TextStyle(
                          color: AppTheme.textLightSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: AppTheme.textLightSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_formatTime(event.startTime)} - ${event.endTime != null ? _formatTime(event.endTime!) : 'TBD'}',
                        style: const TextStyle(
                          color: AppTheme.textLightSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textLightSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
