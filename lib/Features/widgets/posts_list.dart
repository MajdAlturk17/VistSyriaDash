import 'package:flutter/material.dart';
import 'package:visitsyriadashboard/Core/AppColor.dart';
import 'package:visitsyriadashboard/Core/Modle/post_model.dart';
import 'package:visitsyriadashboard/Core/Service/AdminPostService.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _postService = AdminPostService();

  List<PostModel> pendingPosts = [];
  List<PostModel> allPosts = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      final pending = await _postService.getPendingPosts();
      final all = await _postService.getAllPosts();
      setState(() {
        pendingPosts = pending;
        allPosts = all;
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
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (errorMessage != null) {
      return Center(
          child: Text(errorMessage!, style: const TextStyle(color: Colors.red)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =====================
          // 🟣 SECTION 1: Pending
          // =====================
          Text(
            "Pending Posts",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Review and approve or reject posts submitted by users.",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          const SizedBox(height: 20),

          if (pendingPosts.isEmpty)
            const Center(child: Text("No pending posts.")),

          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: pendingPosts.length,
            itemBuilder: (context, i) {
              final post = pendingPosts[i];
              return _buildPostCard(context, post, isPending: true);
            },
          ),

          const SizedBox(height: 40),

          // =====================
          // 🟢 SECTION 2: All Posts
          // =====================
          Text(
            "All Posts",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Browse all approved and published posts.",
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          const SizedBox(height: 20),

          if (allPosts.isEmpty)
            const Center(child: Text("No posts available.")),

          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: allPosts.length,
            itemBuilder: (context, i) {
              final post = allPosts[i];
              return _buildPostCard(context, post, isPending: false);
            },
          ),
        ],
      ),
    );
  }

  // 🧩 COMPONENT: Post Card Widget
  Widget _buildPostCard(BuildContext context, PostModel post,
      {required bool isPending}) {
    final authorImage =
        "https://visitsyria.fun${post.author.imageUrl}";
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header (Avatar + Author)
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.darkBlue,
                backgroundImage: NetworkImage(authorImage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  post.author.fullName.isNotEmpty
                      ? post.author.fullName
                      : post.author.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
              ),
              if (!isPending)
                _buildStatusTag(post.status),
            ],
          ),

          const SizedBox(height: 12),
          Text(
            post.title,
            style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(post.content,
              style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 8),

          if (post.media.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: post.media.map((m) {
                final mediaUrl =
                    "https://app.visitsyria.fun/public/uploads/${m.type == "image" ? "images" : "videos"}/${m.file}";
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: m.type == "image"
                      ? Image.network(
                          mediaUrl,
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 100,
                          height: 80,
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: const Icon(Icons.videocam,
                              color: Colors.black54),
                        ),
                );
              }).toList(),
            ),

          if (isPending) const SizedBox(height: 10),

          if (isPending)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text("Approve",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    try {
                      await _postService.approvePost(post.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Post '${post.title}' approved ✅")),
                      );
                      await loadAllData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  },
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                  ),
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text("Reject",
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    final reason = await _showRejectDialog(context);
                    if (reason == null || reason.isEmpty) return;

                    try {
                      await _postService.rejectPost(post.id, reason);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "Post '${post.title}' rejected ❌")),
                      );
                      await loadAllData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    }
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case "approved":
        color = Colors.green;
        break;
      case "rejected":
        color = Colors.redAccent;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<String?> _showRejectDialog(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reject Post"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Reason for rejection",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text("Cancel")),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child:
                const Text("Reject", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
