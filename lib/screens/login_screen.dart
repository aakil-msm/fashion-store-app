import 'package:flutter/material.dart';
import '../utils/auth_service.dart';
import 'main_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Separate controllers so switching tabs doesn't mix fields
  final loginEmailCtrl = TextEditingController();
  final loginPassCtrl = TextEditingController();

  final regNameCtrl = TextEditingController();
  final regEmailCtrl = TextEditingController();
  final regPassCtrl = TextEditingController();

  bool hidePassword = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    loginEmailCtrl.dispose();
    loginPassCtrl.dispose();
    regNameCtrl.dispose();
    regEmailCtrl.dispose();
    regPassCtrl.dispose();
    super.dispose();
  }

  void _goHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainNavScreen()),
      (route) => false,
    );
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // -------- REGISTER ACTION --------
  Future<void> _doRegister() async {
    final name = regNameCtrl.text.trim();
    final email = regEmailCtrl.text.trim();
    final password = regPassCtrl.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _showError('Please enter a valid email address.');
      return;
    }

    setState(() => _busy = true);
    try {
      await AuthService.register(
        name: name,
        email: email,
        password: password,
      );
      if (!mounted) return;
      _goHome();
    } catch (e) {
      _showError(AuthService.describeError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // -------- LOGIN ACTION --------
  Future<void> _doLogin() async {
    final email = loginEmailCtrl.text.trim();
    final password = loginPassCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter your email and password.');
      return;
    }

    setState(() => _busy = true);
    try {
      await AuthService.login(email: email, password: password);
      if (!mounted) return;
      _goHome();
    } catch (e) {
      _showError(AuthService.describeError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061A2D),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Logo
                  const Icon(Icons.shopping_bag_outlined,
                      size: 56, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text(
                    "F‑Dilu",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 40),

                  // Tabs
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    tabs: const [
                      Tab(text: "Register"),
                      Tab(text: "Login"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(child: registerForm()),
                        SingleChildScrollView(child: loginForm()),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Busy overlay
            if (_busy)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------- REGISTER ----------------

  Widget registerForm() {
    return Column(
      children: [
        neumorphicField(
          controller: regNameCtrl,
          hint: "Full Name",
          icon: Icons.person_outline,
        ),
        const SizedBox(height: 18),
        neumorphicField(
          controller: regEmailCtrl,
          hint: "Email",
          icon: Icons.mail_outline,
        ),
        const SizedBox(height: 18),
        neumorphicField(
          controller: regPassCtrl,
          hint: "Password",
          icon: Icons.lock_outline,
          obscure: hidePassword,
          suffix: IconButton(
            icon: Icon(
              hidePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () =>
                setState(() => hidePassword = !hidePassword),
          ),
        ),
        const SizedBox(height: 30),
        primaryButton("Create Account", _doRegister)
      ],
    );
  }

  // ---------------- LOGIN ----------------

  Widget loginForm() {
    return Column(
      children: [
        neumorphicField(
          controller: loginEmailCtrl,
          hint: "Email",
          icon: Icons.mail_outline,
        ),
        const SizedBox(height: 18),
        neumorphicField(
          controller: loginPassCtrl,
          hint: "Password",
          icon: Icons.lock_outline,
          obscure: hidePassword,
        ),
        const SizedBox(height: 30),
        primaryButton("Login", _doLogin)
      ],
    );
  }

  // ---------------- NEUMORPHIC FIELD ----------------

  Widget neumorphicField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A233F),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            offset: Offset(6, 6),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Colors.white10,
            offset: Offset(-6, -6),
            blurRadius: 12,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: suffix,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  // ---------------- BUTTON ----------------

  Widget primaryButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _busy ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E90FF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          elevation: 6,
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}