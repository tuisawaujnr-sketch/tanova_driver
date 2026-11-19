import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// ==========================================
// MAIN APPLICATION
// ==========================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tanova Partner Driver',
      home: TanovaApp(),
    );
  }
}

// ==========================================
// MAIN APP NAVIGATION
// ==========================================

class TanovaApp extends StatefulWidget {
  const TanovaApp({super.key});

  @override
  State<TanovaApp> createState() => _TanovaAppState();
}

class _TanovaAppState extends State<TanovaApp> {
  // 0 = Welcome, 1 = Login, 2 = Dashboard
  int currentScreen = 0;
  int selectedIndex = 0;
  DriverInfo driver = const DriverInfo(name: '', phone: '', company: '');

  void showWelcome() {
    setState(() {
      currentScreen = 0;
      selectedIndex = 0;
    });
  }

  void showLogin() {
    setState(() {
      currentScreen = 1;
    });
  }

  void showDashboard(DriverInfo info) {
    setState(() {
      driver = info;
      currentScreen = 2;
      selectedIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ======================================
      // FIJI BACKGROUND IMAGE
      // ======================================
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/assets/images/driver_app_background.png'),
          fit: BoxFit.cover,
        ),
      ),

      child: Stack(
        fit: StackFit.expand,
        children: [
          // ======================================
          // MAIN SCAFFOLD
          // ======================================
          Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            extendBodyBehindAppBar: true,

            // ======================================
            // SCREEN CONTENT
            // ======================================
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: currentScreen == 2 && selectedIndex == 0 ? 0 : 65,
                ),
                child: IndexedStack(
                  index: currentScreen,
                  children: [
                    WelcomeScreen(onSignIn: showLogin),

                    LoginScreen(onBack: showWelcome, onSignIn: showDashboard),

                    DriverDashboard(
                      selectedIndex: selectedIndex,
                      driver: driver,
                      onSignOut: showWelcome,
                      onOpenTrips: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // BOTTOM NAVIGATION
            bottomNavigationBar: currentScreen == 2
                ? GlassBottomBar(
                    selectedIndex: selectedIndex,
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

// ==========================================
// WELCOME SCREEN - NO LOGO
// ==========================================

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onSignIn;

  const WelcomeScreen({super.key, required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 25),
      child: Column(
        children: [
          const Spacer(),

          // WELCOME TEXT
          const Text(
            'WELCOME TO TANOVA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'PARTNER DRIVER',
            style: TextStyle(
              color: Color(0xFF00D8FF),
              fontSize: 16,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'Your Island | Your Journey',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),

          const Spacer(),

          // SIGN IN BUTTON
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: onSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BCEB),
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: Colors.cyan,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'SIGN IN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            'For registered Tanova drivers only',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ==========================================
// DRIVER LOGIN SCREEN
// ==========================================

class DriverInfo {
  final String name;
  final String phone;
  final String company;

  const DriverInfo({
    required this.name,
    required this.phone,
    required this.company,
  });
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<DriverInfo> onSignIn;

  const LoginScreen({super.key, required this.onBack, required this.onSignIn});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final companyController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    companyController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        companyController.text.trim().isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter your name, phone number, company and password.',
          ),
        ),
      );
      return;
    }

    // DEMO ONLY - FIREBASE WILL BE CONNECTED LATER
    widget.onSignIn(
      DriverInfo(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        company: companyController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
      child: Column(
        children: [
          const SizedBox(height: 25),

          // LOGIN HEADING - NO LOGO
          const Text(
            'Driver Sign In',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Access your Tanova driver dashboard',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 35),

          // ======================================
          // GLASS LOGIN CONTAINER
          // ======================================
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: const Color(0xFF061B30).withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration(
                        'Enter your full name',
                        Icons.badge_rounded,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Phone Number',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration(
                        'Enter your phone number',
                        Icons.phone_rounded,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Company',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: companyController,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(color: Colors.white),
                      decoration: inputDecoration(
                        'Enter your company name',
                        Icons.business_rounded,
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          inputDecoration(
                            'Enter your password',
                            Icons.lock_rounded,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                hidePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                            ),
                          ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: signIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00BCEB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'SIGN IN',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          TextButton(
            onPressed: widget.onBack,
            child: const Text(
              'Back to Welcome',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: const Color(0xFF00D8FF)),
      filled: true,
      fillColor: const Color(0xFF102B42).withValues(alpha: 0.85),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}

// ==========================================
// DRIVER DASHBOARD
// ==========================================

class DriverDashboard extends StatelessWidget {
  final int selectedIndex;
  final DriverInfo driver;
  final VoidCallback onSignOut;
  final VoidCallback onOpenTrips;

  const DriverDashboard({
    super.key,
    required this.selectedIndex,
    required this.driver,
    required this.onSignOut,
    required this.onOpenTrips,
  });

  @override
  Widget build(BuildContext context) {
    final pages = [
      // HOME PAGE - FROM home.dart
      DriverHome(onOpenTrips: onOpenTrips),

      // TRIPS PAGE
      const Center(
        child: Text(
          'My Trips',
          style: TextStyle(color: Colors.white, fontSize: 28),
        ),
      ),

      // PROFILE PAGE
      DriverProfile(driver: driver, onSignOut: onSignOut),
    ];

    return pages[selectedIndex];
  }
}

class DriverProfile extends StatelessWidget {
  final DriverInfo driver;
  final VoidCallback onSignOut;

  const DriverProfile({
    super.key,
    required this.driver,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Your driver account details',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 22),
          _ProfileGlassCard(
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00D8FF), Color(0xFF0065FF)],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.55),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 37,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driver.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Partner driver',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'PERSONAL DETAILS',
            style: TextStyle(
              color: Color(0xFF65DFFF),
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          _ProfileGlassCard(
            child: Column(
              children: [
                _ProfileDetailRow(
                  icon: Icons.badge_outlined,
                  label: 'Full name',
                  value: driver.name,
                ),
                const Divider(color: Colors.white24, height: 24),
                _ProfileDetailRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone number',
                  value: driver.phone,
                ),
                const Divider(color: Colors.white24, height: 24),
                _ProfileDetailRow(
                  icon: Icons.directions_car_outlined,
                  label: 'Company driver',
                  value: driver.company,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: onSignOut,
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Sign Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.55)),
                backgroundColor: const Color(0xFF061B30).withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileGlassCard extends StatelessWidget {
  final Widget child;

  const _ProfileGlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.22),
                const Color(0xFF3A8DBD).withValues(alpha: 0.15),
                const Color(0xFF061B30).withValues(alpha: 0.3),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.32),
              width: 1.1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF65DFFF), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// LIQUID GLASS BOTTOM NAVIGATION BAR
// ==========================================

class GlassBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const GlassBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.home_rounded,
      Icons.access_time_rounded,
      Icons.person_outline_rounded,
    ];

    final labels = ['Home', 'Trips', 'Profile'];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),

                // LIQUID GLASS BACKGROUND
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.22),
                    const Color(0xFF3A8DBD).withValues(alpha: 0.16),
                    const Color(0xFF061B30).withValues(alpha: 0.25),
                  ],
                ),

                // REFLECTIVE GLASS BORDER
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.38),
                  width: 1.2,
                ),
              ),

              child: Row(
                children: List.generate(icons.length, (index) {
                  final active = selectedIndex == index;

                  return Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () => onTap(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        margin: const EdgeInsets.all(5),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),

                          // SELECTED BUTTON GRADIENT
                          gradient: active
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF00D8FF)
                                        .withValues(alpha: 0.75),
                                    const Color(0xFF0065FF)
                                        .withValues(alpha: 0.55),
                                  ],
                                )
                              : null,

                          // SELECTED BUTTON GLOW
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                    color: Colors.cyan.withValues(alpha: 0.22),
                                    blurRadius: 18,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : [],

                          // SELECTED BUTTON BORDER
                          border: active
                              ? Border.all(
                                  color: Colors.white.withValues(alpha: 0.40),
                                  width: 1,
                                )
                              : null,
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icons[index], color: Colors.white, size: 25),

                            const SizedBox(height: 4),

                            Text(
                              labels[index],
                              style: TextStyle(
                                color: active ? Colors.white : Colors.white70,
                                fontSize: 10,
                                fontWeight: active
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
