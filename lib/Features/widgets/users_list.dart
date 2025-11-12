import 'package:flutter/material.dart';
import 'package:visitsyriadashboard/Core/AppColor.dart';
import 'package:visitsyriadashboard/Core/Modle/user_model.dart';
import 'package:visitsyriadashboard/Core/Service/admin_user_service.dart';
import 'package:visitsyriadashboard/Features/Auth/Screen/UserDetails/user_details_page.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final _service = AdminUserService();
  List<UserModel> users = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final data = await _service.getAllUsers();
      setState(() {
        users = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: users.length,
      itemBuilder: (context, i) {
        final user = users[i];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserDetailsPage(userId: user.id),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.darkBlue,
                  backgroundImage: user.imageUrl.isNotEmpty
                      ? NetworkImage(
                          "http://srv706312.hstgr.cloud:7003${user.imageUrl}",
                        )
                      : null,
                  child: user.imageUrl.isEmpty
                      ? Text(
                          user.firstName.isNotEmpty
                              ? user.firstName[0].toUpperCase()
                              : "?",
                          style: const TextStyle(color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Mobile: ${user.mobile}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildTag(
                      user.isAdmin ? "Admin" : "User",
                      user.isAdmin
                          ? AppColors.gold
                          : AppColors.darkBlue.withOpacity(0.6),
                    ),
                    const SizedBox(height: 6),
                    _buildTag(
                      user.isActive ? "Active" : "Inactive",
                      user.isActive ? Colors.green : Colors.redAccent,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
