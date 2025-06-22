import 'package:flutter/material.dart';
import '../../models/room.dart';

class RoomParticipants extends StatelessWidget {
  final Room room;
  final String currentUserId;
  final Function(String userId) onPromoteToPermanent;
  final Function(String userId) onDemotePermanent;
  final Function(String userId) onAddGuest;
  final Function(String userId) onRemoveGuest;

  const RoomParticipants({
    Key? key,
    required this.room,
    required this.currentUserId,
    required this.onPromoteToPermanent,
    required this.onDemotePermanent,
    required this.onAddGuest,
    required this.onRemoveGuest,
  }) : super(key: key);

  bool get isAdmin => room.isCaptain(currentUserId);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('Permanent Speakers',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...room.permanentSpeakers.map((p) => ListTile(
              leading: CircleAvatar(child: Text(p.username[0].toUpperCase())),
              title: Text(p.username),
              subtitle: Text('Permanent Speaker'),
              trailing: isAdmin
                  ? IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.red),
                      onPressed: () => onDemotePermanent(p.userId),
                    )
                  : null,
            )),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('Guest Speakers Queue',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...room.guestSpeakers.map((p) => ListTile(
              leading: CircleAvatar(child: Text(p.username[0].toUpperCase())),
              title: Text(p.username),
              subtitle: Text('Guest Speaker'),
              trailing: isAdmin
                  ? IconButton(
                      icon: const Icon(Icons.remove_circle_outline,
                          color: Colors.red),
                      onPressed: () => onRemoveGuest(p.userId),
                    )
                  : null,
            )),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('All Members',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ...room.members.map((p) => ListTile(
              leading: CircleAvatar(child: Text(p.username[0].toUpperCase())),
              title: Text(p.username),
              subtitle: Text('Member'),
              trailing: isAdmin
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (room.hasPermanentSpeakerSlot)
                          IconButton(
                            icon: const Icon(Icons.star, color: Colors.orange),
                            onPressed: () => onPromoteToPermanent(p.userId),
                          ),
                        IconButton(
                          icon: const Icon(Icons.queue, color: Colors.blue),
                          onPressed: () => onAddGuest(p.userId),
                        ),
                      ],
                    )
                  : null,
            )),
      ],
    );
  }
}
