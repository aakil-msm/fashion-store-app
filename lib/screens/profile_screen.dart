import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../utils/auth_service.dart';
import '../utils/user_service.dart';
import 'login_screen.dart';
import 'my_orders_screen.dart';
import 'wishlist_screen.dart';
import 'saved_address_screen.dart';
import 'payment_methods_screen.dart';
import 'help_support_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsOn = true;
  bool _darkModeOn = false;
  Map<String, dynamic>? _profile;
  int _orderCount = 0;
  bool _loadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await UserService.fetchProfile();
    final count  = await UserService.fetchOrderCount();
    if (mounted) {
      setState(() {
        _profile = profile;
        _orderCount = count;
        _loadingProfile = false;
      });
    }
  }

  void _showEditSheet() {
    final nameCtrl    = TextEditingController(text: _profile?['name']    ?? '');
    final phoneCtrl   = TextEditingController(text: _profile?['phone']   ?? '');
    final addressCtrl = TextEditingController(text: _profile?['address'] ?? '');
    bool saving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _sheetField(nameCtrl,    'Full Name',    Icons.person_outline),
              const SizedBox(height: 12),
              _sheetField(phoneCtrl,   'Phone Number', Icons.phone_outlined,
                  type: TextInputType.phone),
              const SizedBox(height: 12),
              _sheetField(addressCtrl, 'Address',
                  Icons.location_on_outlined, maxLines: 2),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: saving
                      ? null
                      : () async {
                          setSheet(() => saving = true);
                          try {
                            await UserService.updateProfile(
                              name:    nameCtrl.text.trim(),
                              phone:   phoneCtrl.text.trim(),
                              address: addressCtrl.text.trim(),
                            );
                            if (mounted) {
                              Navigator.pop(ctx);
                              _loadProfile();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profile updated!'),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          } catch (e) {
                            setSheet(() => saving = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Update failed: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Save Changes',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetField(TextEditingController ctrl, String label, IconData icon,
      {TextInputType type = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayName = _profile?['name'] ??
        AuthService.currentUser?.displayName ?? 'User';
    final email = _profile?['email'] ??
        AuthService.currentUser?.email ?? '';
    final phone   = _profile?['phone']   as String? ?? '';
    final initials = displayName.trim().isNotEmpty
        ? displayName.trim().split(' ').map((s) => s[0]).take(2).join().toUpperCase()
        : 'FD';

    final menuItems = [
      {'icon': Icons.shopping_bag_outlined, 'label': 'My Orders',       'screen': const MyOrdersScreen()},
      {'icon': Icons.favorite_outline,      'label': 'Wishlist',         'screen': const WishlistScreen()},
      {'icon': Icons.location_on_outlined,  'label': 'Saved Addresses',  'screen': const SavedAddressScreen()},
      {'icon': Icons.payment_outlined,      'label': 'Payment Methods',  'screen': const PaymentMethodsScreen()},
      {'icon': Icons.help_outline,          'label': 'Help & Support',   'screen': const HelpSupportScreen()},
      {'icon': Icons.info_outline,          'label': 'About F-Dilu',     'screen': const AboutScreen()},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: _showEditSheet,
          ),
        ],
      ),
      body: _loadingProfile
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SingleChildScrollView(
              child: Column(children: [

                // ── HEADER ────────────────────────────────────────────────
                Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  child: Row(children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.accent,
                      child: Text(initials,
                          style: const TextStyle(color: Colors.white,
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName,
                            style: const TextStyle(color: Colors.white,
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(email, style: const TextStyle(color: Colors.white70)),
                        if (phone.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(phone,
                                style: const TextStyle(
                                    color: Colors.white54, fontSize: 12)),
                          ),
                      ],
                    )),
                  ]),
                ),

                // ── STATS ─────────────────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(children: [
                    _statItem('$_orderCount', 'Orders'),
                    _divider(),
                    _statItem('0', 'Wishlist'),
                    _divider(),
                    _statItem('0', 'Reviews'),
                  ]),
                ),

                const SizedBox(height: 12),

                // ── SETTINGS ──────────────────────────────────────────────
                Container(
                  color: Colors.white,
                  child: Column(children: [
                    SwitchListTile(
                      title: const Text('Notifications'),
                      value: _notificationsOn,
                      onChanged: (v) => setState(() => _notificationsOn = v),
                      activeThumbColor: AppColors.accent,
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      value: _darkModeOn,
                      onChanged: (v) => setState(() => _darkModeOn = v),
                      activeThumbColor: AppColors.accent,
                    ),
                  ]),
                ),

                const SizedBox(height: 12),

                // ── MENU ──────────────────────────────────────────────────
                Container(
                  color: Colors.white,
                  child: Column(
                    children: List.generate(menuItems.length, (i) {
                      final item = menuItems[i];
                      return Column(children: [
                        ListTile(
                          leading: Icon(item['icon'] as IconData,
                              color: AppColors.primary),
                          title: Text(item['label'] as String),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => item['screen'] as Widget)),
                        ),
                        if (i < menuItems.length - 1) const Divider(height: 1),
                      ]);
                    }),
                  ),
                ),

                const SizedBox(height: 16),

                // ── LOGOUT ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.logout, color: Colors.red),
                      label: const Text('Logout',
                          style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Logout?'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Logout',
                                      style: TextStyle(color: Colors.red))),
                            ],
                          ),
                        );
                        if (confirm != true) return;
                        await AuthService.logout();
                        if (!mounted) return;
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (_) => false,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Text('F-Dilu Fashion Store v1.0.0',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                const SizedBox(height: 20),
              ]),
            ),
    );
  }

  Widget _statItem(String value, String label) => Expanded(
        child: Column(children: [
          Text(value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: AppColors.textGrey)),
        ]),
      );

  Widget _divider() =>
      Container(width: 1, height: 40, color: Colors.grey.shade300);
}