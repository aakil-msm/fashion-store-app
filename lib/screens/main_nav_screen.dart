import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import 'home_screen.dart';
import 'product_listing_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({Key? key}) : super(key: key);

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ProductListingScreen(category: ''),
    CartScreen(),
    ProfileScreen(),
  ];

  // ✅ Removed "const" and "_" issue
  final List<NavItem> _navItems = [
    NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    NavItem(
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view,
      label: 'Explore',
    ),
    NavItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: 'Cart',
    ),
    NavItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (i) {
                final item = _navItems[i];
                final bool active = i == _currentIndex;

                return GestureDetector(
                  onTap: () => setState(() => _currentIndex = i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),

                    // ✅ soft light pink background
                    decoration: active
                        ? BoxDecoration(
                            color:
                                // ignore: deprecated_member_use
                                AppColors.accent.withOpacity(0.08),
                            borderRadius:
                                BorderRadius.circular(14),
                          )
                        : null,

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ✅ Cart icon – NO badge
                        Icon(
                          active
                              ? item.activeIcon
                              : item.icon,
                          color: active
                              ? AppColors.accent
                              : AppColors.textGrey,
                          size: 24,
                        ),

                        // ✅ Label only when active
                        if (active) ...[
                          const SizedBox(width: 6),
                          Text(
                            item.label,
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ Public model (no underscore = no analyzer issue)
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}