import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../theme.dart';
import 'post_detail_screen.dart';
import 'post_form_screen.dart';
import 'login_screen.dart';

class PostsListScreen extends StatefulWidget {
  final String username;

  const PostsListScreen({super.key, required this.username});

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  final PostService _postService = PostService();

  List<Post> _posts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final posts = await _postService.fetchPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _deletePost(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Siba Inyandiko'),
        content: const Text('Uremeza gusiba iyi nyandiko?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Oya'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yego, Siba'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _postService.deletePost(id);
      setState(() {
        _posts.removeWhere((p) => p.id == id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Inyandiko yasibwe neza!'),
            ]),
            backgroundColor: AppTheme.primaryGreen,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  Future<void> _goToEdit(Post post) async {
    final updatedPost = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => PostFormScreen(post: post)),
    );
    if (updatedPost != null && mounted) {
      setState(() {
        final index = _posts.indexWhere((p) => p.id == post.id);
        if (index != -1) {
          _posts[index] = updatedPost;
        }
      });
    }
  }

  Future<void> _goToCreate() async {
    final newPost = await Navigator.push<Post>(
      context,
      MaterialPageRoute(builder: (_) => const PostFormScreen()),
    );
    if (newPost != null && mounted) {
      setState(() {
        _posts.insert(0, newPost);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Muraho, ${widget.username}! 👋',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Urugo rw\'Amakuru - Rwanda',
              style: TextStyle(fontSize: 10, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPosts,
            tooltip: 'Subiramo',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sohoka',
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Sohoka'),
                  content: const Text('Uremeza gusohoka muri konti yawe?'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Oya'),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yego, Sohoka'),
                    ),
                  ],
                ),
              );
              if (confirm == true && mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            height: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accentGold, AppTheme.lightGreen, AppTheme.accentGold],
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.primaryGreen, strokeWidth: 3),
                  SizedBox(height: 16),
                  Text('Turagutegereza...', style: TextStyle(color: Colors.grey, fontSize: 16)),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off, size: 72, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(_errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _loadPosts,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Ongera Ugerageze'),
                        ),
                      ],
                    ),
                  ),
                )
              : _posts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined, size: 72, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            'Nta nyandiko zihari.\nNdika inyandiko nshya!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        // Total posts counter
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          color: AppTheme.darkGreen,
                          child: Row(
                            children: [
                              const Icon(Icons.article, color: AppTheme.accentGold, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Inyandiko zose: ${_posts.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            color: AppTheme.primaryGreen,
                            onRefresh: _loadPosts,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(top: 8, bottom: 80),
                              itemCount: _posts.length,
                              itemBuilder: (context, index) {
                                final post = _posts[index];
                                final isNew = post.id != null && post.id! > 100;
                                return _PostCard(
                                  post: post,
                                  isNew: isNew,
                                  username: widget.username,
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PostDetailScreen(post: post, username: widget.username),
                                      ),
                                    );
                                    if (result != null && mounted) {
                                      setState(() {
                                        if (result == 'deleted') {
                                          _posts.removeWhere((p) => p.id == post.id);
                                        } else if (result is Post) {
                                          final i = _posts.indexWhere((p) => p.id == post.id);
                                          if (i != -1) _posts[i] = result;
                                        }
                                      });
                                    }
                                  },
                                  onEdit: () => _goToEdit(post),
                                  onDelete: () => _deletePost(post.id!),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCreate,
        icon: const Icon(Icons.add),
        label: const Text('Inyandiko Nshya'),
        backgroundColor: AppTheme.primaryGreen,
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;
  final bool isNew;
  final String username;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PostCard({
    required this.post,
    required this.isNew,
    required this.username,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isNew
                      ? AppTheme.accentGold.withOpacity(0.2)
                      : AppTheme.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: isNew
                      ? Border.all(color: AppTheme.accentGold, width: 1.5)
                      : null,
                ),
                alignment: Alignment.center,
                child: isNew
                    ? const Icon(Icons.fiber_new, color: AppTheme.accentGold, size: 26)
                    : Text(
                        '${post.id}',
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isNew) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGold,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NSHYA',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, height: 1.3),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isNew ? Icons.person : Icons.cloud_outlined,
                          size: 14,
                          color: isNew ? AppTheme.primaryGreen : Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isNew ? username : 'Server',
                          style: TextStyle(
                            color: isNew ? AppTheme.primaryGreen : Colors.grey[500],
                            fontSize: 12,
                            fontWeight: isNew ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Actions
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryGreen),
                    onPressed: onEdit,
                    tooltip: 'Hindura',
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Siba',
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}