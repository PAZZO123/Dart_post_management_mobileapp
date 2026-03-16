import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/post_service.dart';
import '../theme.dart';

class PostFormScreen extends StatefulWidget {
  final Post? post; // null = create new, non-null = edit

  const PostFormScreen({super.key, this.post});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _userIdController = TextEditingController();
  final PostService _postService = PostService();
  bool _isLoading = false;

  bool get _isEditing => widget.post != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.post!.title;
      _bodyController.text = widget.post!.body;
      _userIdController.text = widget.post!.userId.toString();
    } else {
      _userIdController.text = '1';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userIdController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final post = Post(
        id: widget.post?.id,
        userId: int.parse(_userIdController.text.trim()),
        title: _titleController.text.trim(),
        body: _bodyController.text.trim(),
      );

      if (_isEditing) {
        await _postService.updatePost(post);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Post yahindutse neza!'),
                ],
              ),
              backgroundColor: AppTheme.primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context, post);
        }
      } else {
        await _postService.createPost(post);
        // Generate a unique local ID since JSONPlaceholder always returns 101
        final localId = 101 + DateTime.now().millisecondsSinceEpoch % 100000;
        final newPostWithId = post.copyWith(id: localId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Post nshya yakozwe neza!'),
                ],
              ),
              backgroundColor: AppTheme.primaryGreen,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
          Navigator.pop(context, newPostWithId);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Hindura Post' : 'Post Nshya'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.primaryGreen.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryGreen,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _isEditing
                            ? 'Uhindura Post #${widget.post!.id}'
                            : 'Ushyiraho Post nshya mu Rwanda Media',
                        style: const TextStyle(
                          color: AppTheme.primaryGreen,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // User ID Field
              TextFormField(
                controller: _userIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'User ID',
                  hintText: 'Injiza inomero y\'umukoresha',
                  prefixIcon:
                      Icon(Icons.person, color: AppTheme.primaryGreen),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Injiza User ID';
                  }
                  if (int.tryParse(value.trim()) == null) {
                    return 'User ID igomba kuba umubare';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Umutwe wa post (title)',
                  hintText: 'Injiza title ya Post',
                  prefixIcon:
                      Icon(Icons.title, color: AppTheme.primaryGreen),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Injiza title ya post';
                  }
                  if (value.trim().length < 5) {
                    return 'Umutwe ugomba kuba nibura inyuguti 5';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Body Field
              TextFormField(
                controller: _bodyController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Ibiri mur Post',
                  hintText: 'Andika Post yawe hano...',
                  prefixIcon: Icon(Icons.article, color: AppTheme.primaryGreen),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Injiza Post';
                  }
                  if (value.trim().length < 10) {
                    return 'Post igomba kuba nibura inyuguti 10';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _submit,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(_isEditing ? Icons.save : Icons.send),
                  label: Text(
                    _isLoading
                        ? 'Turimo...'
                        : _isEditing
                            ? 'Bika Impinduka'
                            : 'Ohereza Post',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel Button
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text('Reka'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[400]!),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}