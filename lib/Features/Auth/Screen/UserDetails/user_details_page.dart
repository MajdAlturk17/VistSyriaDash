import 'package:flutter/material.dart';
import 'package:visitsyriadashboard/Core/AppColor.dart';
import 'package:visitsyriadashboard/Core/Modle/user_details_model.dart';
import 'package:visitsyriadashboard/Core/Service/AdminUserDetailsService.dart';

class UserDetailsPage extends StatefulWidget {
  final String userId;
  const UserDetailsPage({super.key, required this.userId});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _service = AdminUserDetailsService();

  UserDetailsModel? user;
  bool isLoading = true;
  bool isEditing = false;
  String? error;

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final data = await _service.getUserById(widget.userId);
      setState(() {
        user = data;
        isLoading = false;
      });
      firstNameCtrl.text = data.firstName;
      lastNameCtrl.text = data.lastName;
      mobileCtrl.text = data.mobile;
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> updateUser() async {
    try {
      setState(() => isLoading = true);

      final updated = await _service.updateUser(widget.userId, {
        "firstName": firstNameCtrl.text,
        "lastName": lastNameCtrl.text,
        "mobile": mobileCtrl.text,
        "isActive": user!.isActive,
      });

      setState(() {
        user = updated;
        isEditing = false;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User updated successfully!")),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    }
  }

  Future<void> deleteUser() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete User"),
        content: const Text("Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        setState(() => isLoading = true);
        final ok = await _service.deleteUser(widget.userId);
        setState(() => isLoading = false);
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User deleted successfully")),
          );
          Navigator.pop(context); // رجوع بعد الحذف
        }
      } catch (e) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Delete failed: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) {
      return Center(
        child: Text(error!, style: const TextStyle(color: Colors.red)),
      );
    }
    if (user == null) return const Center(child: Text("No user data found"));
    final imageUrl =
        "http://srv706312.hstgr.cloud:7003${user!.imageUrl.startsWith('/') ? user!.imageUrl : '/${user!.imageUrl}'}";

    return Scaffold(
      backgroundColor: AppColors.grey.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        title: Text(
          "${user!.fullName}'s Profile",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            tooltip: "Edit",
            onPressed: () => setState(() => isEditing = !isEditing),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            tooltip: "Delete",
            onPressed: deleteUser,
          ),
        ],
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.darkBlue,
                backgroundImage: NetworkImage(imageUrl),
              ),
              const SizedBox(height: 16),
              Text(
                user!.fullName,
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildTag(
                user!.isAdmin ? "Admin" : "User",
                user!.isAdmin ? AppColors.gold : AppColors.darkBlue,
              ),
              const SizedBox(height: 20),
              const Divider(),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    _buildEditableRow("First Name", firstNameCtrl),
                    _buildEditableRow("Last Name", lastNameCtrl),
                    _buildEditableRow("Mobile", mobileCtrl),
                    _buildInfoRow("Email", user!.email),
                    _buildInfoRow("Username", user!.username),
                    _buildInfoRow("Provider", user!.provider),
                    _buildInfoRow(
                      "Status",
                      user!.isActive ? "Active" : "Inactive",
                    ),
                    _buildInfoRow(
                      "Email Verified",
                      user!.emailVerified ? "Yes" : "No",
                    ),
                    _buildInfoRow(
                      "Created At",
                      user!.createdAt.toLocal().toString().split(".")[0],
                    ),
                  ],
                ),
              ),

              if (isEditing)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkBlue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      "Save Changes",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: updateUser,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isEditing
                ? TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                    ),
                  )
                : Text(
                    controller.text,
                    style: const TextStyle(color: Colors.black87),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.darkBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : "-",
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
