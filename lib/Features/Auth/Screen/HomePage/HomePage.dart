import 'package:flutter/material.dart';
import 'package:visitsyriadashboard/Core/AppColor.dart';
import 'package:visitsyriadashboard/Features/widgets/posts_list.dart';
import 'package:visitsyriadashboard/Features/widgets/users_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0; 

  final List<Widget> pages = const [
    UsersList(),
    PostsList(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey.withOpacity(0.1),
      body: Row(
        children: [
          // 🧭 Sidebar
          Container(
            width: 230,
            color: AppColors.darkBlue,
            child: Column(
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.dashboard, size: 48, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  "Dashboard",
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                _buildNavItem(Icons.people, "Users", 0),
                _buildNavItem(Icons.article_outlined, "Posts", 1),
                const Spacer(),
                Divider(color: Colors.white.withOpacity(0.3), height: 1),
                TextButton.icon(
                  onPressed: () {
                    // Logout or back to login
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // 📄 Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.grey.withOpacity(0.1),
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, int index) {
    final bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.grey.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.gold : Colors.white),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? AppColors.gold : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
