import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../../models/event.dart';
import '../../models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final Event? event;
  final VoidCallback onTap;

  const RoomCard({
    Key? key,
    required this.room,
    this.event,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Room header with status indicator
            _buildRoomHeader(),
            // Room details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Room title and participant count
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          room.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildParticipantCount(),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Room description
                  Text(
                    room.description,
                    style: const TextStyle(
                      color: AppTheme.textLightSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Room stats
                  Row(
                    children: [
                      _buildCaptainChip(),
                      const Spacer(),
                      _buildRoomStats(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomHeader() {
    Color statusColor;
    String statusText;

    switch (room.status) {
      case RoomStatus.active:
        statusColor = AppTheme.success;
        statusText = 'Active';
        break;
      case RoomStatus.inactive:
        statusColor = AppTheme.warning;
        statusText = 'Inactive';
        break;
      case RoomStatus.archived:
        statusColor = Colors.grey;
        statusText = 'Archived';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          // Status indicator
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          // Event name
          if (event != null)
            Text(
              event!.title,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildParticipantCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.people,
            color: AppTheme.primaryColor,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${room.participants.length}',
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptainChip() {
    // Find captain
    final captain = room.participants.firstWhere(
      (p) => p.userId == room.captainId,
      orElse: () => Participant(
        userId: 'unknown',
        username: 'Unknown',
        tier: ParticipantTier.captain,
        joinedAt: DateTime.now(),
      ),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          captain.username,
          style: const TextStyle(
            color: AppTheme.textLightSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildRoomStats() {
    String activityText = 'No activity yet';
    
    if (room.lastActivityAt != null) {
      final now = DateTime.now();
      final difference = now.difference(room.lastActivityAt!);
      
      if (difference.inSeconds < 60) {
        activityText = 'Just now';
      } else if (difference.inMinutes < 60) {
        activityText = '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        activityText = '${difference.inHours}h ago';
      } else {
        activityText = '${difference.inDays}d ago';
      }
    }
    
    return Row(
      children: [
        const Icon(
          Icons.access_time,
          color: AppTheme.textLightSecondary,
          size: 14,
        ),
        const SizedBox(width: 4),
        Text(
          activityText,
          style: const TextStyle(
            color: AppTheme.textLightSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
