import 'dart:ui';

import 'package:flutter/material.dart';

import 'panels.dart';

// ==========================================
// TANOVA PARTNER DRIVER HOME SCREEN
// ==========================================

class DriverHome extends StatefulWidget {
  final VoidCallback onOpenTrips;

  const DriverHome({super.key, required this.onOpenTrips});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  bool isLoading = false;

  // Demo data - replace with real incoming notifications later
  final List<AppNotification> notifications = [
    AppNotification(
      icon: Icons.local_taxi_rounded,
      title: 'New request',
      message: 'A new ride request is waiting for you.',
      time: 'Just now',
    ),
    AppNotification(
      icon: Icons.info_outline_rounded,
      title: 'Welcome to Tanova',
      message: 'Go online to start receiving requests.',
      time: 'Today',
    ),
  ];

  Future<void> goOnline() async {
    setState(() {
      isLoading = true;
    });

    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    widget.onOpenTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),

      child: Column(
        children: [
          // ======================================
          // TOP MENU BAR
          // ======================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // MENU ICON - LEFT
              IconButton(
                onPressed: () => showMenuPanel(context),

                icon: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),

              // PARTNERSHIP PLATFORM - CENTRE
              const Expanded(
                child: Text(
                  'PARTNERSHIP PLATFORM',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // NOTIFICATION ICON - RIGHT
              IconButton(
                onPressed: () async {
                  await showNotificationsPanel(context, notifications);
                  if (mounted) setState(() {});
                },

                icon: Icon(
                  notifications.any((n) => n.unread)
                      ? Icons.notifications_active_rounded
                      : Icons.notifications_none_rounded,
                  color: const Color(0xFFB4DEFF),
                  size: 28,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ======================================
          // TANOVA EXPRESS HEADING
          // ======================================
          const Text(
            'TANOVA EXPRESS',
            textAlign: TextAlign.center,

            style: TextStyle(
              color: Color(0xFF65DFFF),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
            ),
          ),

          const SizedBox(height: 5),

          // ======================================
          // DRIVER PAGE TITLE
          // ======================================
          const Text(
            'Partner Driver',
            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 0,
            ),
          ),

          const SizedBox(height: 8),

          // ======================================
          // SUBTITLE
          // ======================================
          const Text(
            'Accept Trips • Pick Up • Drop Off',
            textAlign: TextAlign.center,

            style: TextStyle(color: Colors.white, fontSize: 16),
          ),

          const SizedBox(height: 35),

          // ======================================
          // DRIVER STATUS CARD
          // ======================================
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 23,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.24),
                      const Color(0xFF3A8DBD).withValues(alpha: 0.16),
                      const Color(0xFF061B30).withValues(alpha: 0.25),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.38),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C8FF).withValues(alpha: 0.16),
                      blurRadius: 25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // ==================================
                    // TAXI STATUS ICON
                    // ==================================
                    Stack(
                      clipBehavior: Clip.none,

                      children: [
                        const Icon(
                          Icons.local_taxi_rounded,
                          color: Colors.white,
                          size: 43,
                        ),

                        // BLUE CHECK MARK
                        Positioned(
                          right: -5,
                          bottom: 0,

                          child: Container(
                            padding: const EdgeInsets.all(3),

                            decoration: const BoxDecoration(
                              color: Color(0xFF00C8FF),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 17),

                    // ==================================
                    // DRIVER STATUS TEXT
                    // ==================================
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Ready for Trips',

                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          SizedBox(height: 6),

                          Text(
                            'Awaiting your next trip request',

                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: 230,
            height: 58,
            child: ElevatedButton(
              onPressed: isLoading ? null : goOnline,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00C8FF),
                disabledBackgroundColor: const Color(0xFF00C8FF)
                    .withValues(alpha: 0.7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Connecting...',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.power_settings_new_rounded),
                        SizedBox(width: 10),
                        Text(
                          'Go Online',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          // ======================================
          // EMPTY SPACE BELOW CARD
          // ======================================
          const Spacer(),

          const Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: Text(
              'Note: all fares are calculated according to own company taxi meters.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromARGB(179, 254, 251, 251), fontSize: 19),
            ),
          ),
        ],
      ),
    );
  }
}
