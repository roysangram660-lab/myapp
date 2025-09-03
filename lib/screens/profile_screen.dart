import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:myapp/services/auth_service.dart';
import 'package:myapp/services/user_service.dart';
import 'package:myapp/services/storage_service.dart';
import 'package:myapp/services/gemini_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  void _showAnalysisResult(String result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Image Analysis'),
        content: Text(result),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userService = Provider.of<UserService>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    final geminiService = Provider.of<GeminiService>(context, listen: false);
    final user = authService.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userService.getUser(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user data'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;userData['displayName'] ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(File(_imageFile!.path))
                          : (userData['photoURL'] != null
                              ? NetworkImage(userData['photoURL'])
                              : null) as ImageProvider?,
                      child: _imageFile == null && userData['photoURL'] == null
                          ? const Icon(Icons.camera_alt, size: 50)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(labelText: 'Display Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a display name' : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final newDisplayName = _displayNameController.text;
                        final updateData = <String, dynamic>{
                          'displayName': newDisplayName,
                        };

                        if (_imageFile != null) {
                          final photoURL = await storageService.uploadProfileImage(user.uid, _imageFile!);
                          if (photoURL != null) {
                            updateData['photoURL'] = photoURL;
                          }
                        }

                        await userService.updateUser(user.uid, updateData);

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile updated!')),
                          );
                        }
                      }
                    },
                    child: const Text('Update Profile'),
                  ),
                  const SizedBox(height: 10),
                  if (userData['photoURL'] != null)
                    ElevatedButton(
                      onPressed: _isAnalyzing
                          ? null
                          : () async {
                              setState(() {
                                _isAnalyzing = true;
                              });
                              try {
                                final photoUrl = userData['photoURL'] as String;
                                final storageUri = await storageService.getStorageUri(photoUrl);
                                final result = await geminiService.analyzeImage(
                                  'Describe this image in a fun and creative way.',
                                  Uri.parse(storageUri),
                                );

                                if (mounted) {
                                  _showAnalysisResult(result);
                                }
                              } catch (e, s) {
                                developer.log('Image analysis failed', name: 'ProfileScreen', error: e, stackTrace: s);
                                if (mounted) {
                                  _showAnalysisResult('Failed to analyze image. Please try again.');
                                }
                              } finally {
                                setState(() {
                                  _isAnalyzing = false;
                                });
                              }
                            },
                      child: _isAnalyzing
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Analyze Profile Picture'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
