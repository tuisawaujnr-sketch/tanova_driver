import 'dart:ui';

import 'package:flutter/material.dart';

class AppNotification {
  final IconData icon;
  final String title;
  final String message;
  final String time;
  bool unread;

  AppNotification({
    required this.icon,
    required this.title,
    required this.message,
    required this.time,
    this.unread = true,
  });
}

class Contact {
  final String name;
  final String role;
  final String phone;

  const Contact(this.name, this.role, this.phone);
}

const _accent = Color(0xFF65DFFF);

Widget _glassPanel({required Widget child, BorderRadius? radius}) {
  final r = radius ?? BorderRadius.circular(22);
  return ClipRRect(
    borderRadius: r,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: r,
          color: const Color(0xFF061B30).withValues(alpha: 0.85),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: child,
      ),
    ),
  );
}

// ==========================================
// NOTIFICATIONS PANEL
// ==========================================

Future<void> showNotificationsPanel(
  BuildContext context,
  List<AppNotification> notifications,
) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _NotificationsPanel(notifications: notifications),
  );
}

class _NotificationsPanel extends StatefulWidget {
  final List<AppNotification> notifications;

  const _NotificationsPanel({required this.notifications});

  @override
  State<_NotificationsPanel> createState() => _NotificationsPanelState();
}

class _NotificationsPanelState extends State<_NotificationsPanel> {
  @override
  Widget build(BuildContext context) {
    final items = widget.notifications;

    return FractionallySizedBox(
      heightFactor: 0.7,
      child: _glassPanel(
        radius: const BorderRadius.vertical(top: Radius.circular(26)),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 12, 6),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (items.isNotEmpty)
                    TextButton(
                      onPressed: () => setState(items.clear),
                      child: const Text('Clear all'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? const Center(
                      child: Text(
                        'No notifications yet',
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final n = items[i];
                        return Dismissible(
                          key: ObjectKey(n),
                          onDismissed: (_) => setState(() => items.remove(n)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => setState(() => n.unread = false),
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white.withValues(
                                  alpha: n.unread ? 0.16 : 0.07,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(n.icon, color: _accent),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          n.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          n.message,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          n.time,
                                          style: const TextStyle(
                                            color: Colors.white38,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (n.unread)
                                    Container(
                                      width: 9,
                                      height: 9,
                                      margin: const EdgeInsets.only(top: 4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF00D8FF),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// MENU (CONTACTS ONLY)
// ==========================================

Future<void> showMenuPanel(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: _glassPanel(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 4),
                child: Row(
                  children: [
                    Icon(Icons.contacts_rounded, color: _accent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'CONTACTS',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              for (final c in mainContacts)
                ListTile(
                  dense: true,
                  leading: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Color(0xFF0065FF),
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    c.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${c.role} • ${c.phone}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: const Icon(Icons.phone_rounded, color: _accent),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: _glassPanel(
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ABOUT TANOVA',
                          style: TextStyle(
                            color: _accent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.4,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'This is the driver app connecting cab drivers to their bases '
                          'on the Tanova Express platform. Go online to receive ride '
                          'requests from your own company, manage your trips and stay connected with '
                          'dispatch and support.',
                          style: TextStyle(color: Colors.white70, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

const mainContacts = [
  Contact('Company contact', 'Dispatch', '+679 000 0001'),
  Contact('Tanova Support', 'Driver support', '+679 000 0002'),
  Contact('Emergency', 'Emergency line', '911'),
];
