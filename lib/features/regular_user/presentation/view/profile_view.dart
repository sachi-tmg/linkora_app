import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkora_app/app/di/di.dart';
import 'package:linkora_app/features/auth/presentation/view/login_view.dart';
import 'package:linkora_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:linkora_app/features/regular_user/presentation/view_model/profile_bloc.dart';
import 'package:linkora_app/features/regular_user/presentation/widget/profile_blog_list_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _key = GlobalKey<FormState>();
  File? _img;
  bool _isEditing = false;
  bool _showStats = true;
  String? _selectedSocialLink;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final Map<String, TextEditingController> _socialLinksControllers = {
    'youtube': TextEditingController(),
    'instagram': TextEditingController(),
    'twitter': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfile(username: ''));
    context.read<ProfileBloc>().add(const LoadUserBlogs(page: 1, draft: false));
  }

  Future<File?> _compressImage(File file) async {
    final filePath = file.absolute.path;
    final fileExtension = filePath.split('.').last.toLowerCase();

    CompressFormat format;
    if (fileExtension == 'png') {
      format = CompressFormat.png;
    } else if (fileExtension == 'webp') {
      format = CompressFormat.webp;
    } else {
      format = CompressFormat.jpeg;
    }

    final compressedPath = '${filePath}_compressed.$fileExtension';

    final result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      compressedPath,
      quality: 70,
      format: format,
    );

    return result != null ? File(result.path) : file;
  }

  Future<void> _browseImage(ImageSource imageSource) async {
    try {
      final profilePicture = await ImagePicker().pickImage(source: imageSource);
      if (profilePicture != null) {
        File selectedImage = File(profilePicture.path);
        File? compressedImage = await _compressImage(selectedImage);
        context
            .read<ProfileBloc>()
            .add(UploadProfilePicture(file: compressedImage ?? selectedImage));
        setState(() {
          _img = compressedImage;
        });
      }
    } catch (e) {
      debugPrint('Error selecting image: $e');
    }
  }

  void _onEditProfilePressed(ProfileState state) {
    setState(() {
      _isEditing = true;
      _showStats = false;
      _usernameController.text = state.regularUser?.username ?? '';
      _bioController.text = state.regularUser?.bio ?? '';
      if (state.regularUser?.socialLinks != null) {
        state.regularUser!.socialLinks.forEach((key, value) {
          if (_socialLinksControllers.containsKey(key)) {
            _socialLinksControllers[key]!.text = value;
          }
        });
      }
    });
  }

  void _onSaveProfilePressed() {
    if (_key.currentState!.validate()) {
      final socialLinks = _socialLinksControllers
          .map((key, value) => MapEntry(key, value.text));

      final currentState = context.read<ProfileBloc>().state;

      context.read<ProfileBloc>().add(UpdateProfile(
            username: _usernameController.text,
            bio: _bioController.text,
            profilePicture: currentState.imageName ?? _img?.path ?? '',
            socialLinks: socialLinks,
          ));

      setState(() {
        _isEditing = false;
        _showStats = true;
      });
    }
  }

  void _onLogoutPressed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: getIt<LoginBloc>(),
          child: LoginView(),
        ),
      ),
    );
    debugPrint('User logged out');
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 61, 155, 233),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            onPressed: _onLogoutPressed,
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 234, 242, 248),
        child: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.errorMessage != null) {
                return Center(
                    child: Text(state.errorMessage ?? 'An error occurred'));
              }

              if (state.regularUser != null && !_isEditing) {
                _usernameController.text = state.regularUser?.username ?? '';
                _bioController.text = state.regularUser?.bio ?? '';

                state.regularUser?.socialLinks.forEach((key, value) {
                  if (_socialLinksControllers.containsKey(key)) {
                    _socialLinksControllers[key]!.text = value;
                  }
                });
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.camera),
                                          title: const Text('Camera'),
                                          onTap: () {
                                            _browseImage(ImageSource.camera);
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.image),
                                          title: const Text('Gallery'),
                                          onTap: () {
                                            _browseImage(ImageSource.gallery);
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                  radius: isTablet ? 70 : 50,
                                  backgroundImage: _img != null
                                      ? FileImage(_img!)
                                      : (state.regularUser?.profilePicture !=
                                                      null &&
                                                  state.regularUser!.profilePicture
                                                      .isNotEmpty
                                              ? NetworkImage(state
                                                  .regularUser!.profilePicture)
                                              : const AssetImage(
                                                  'assets/images/default_profile.jpg'))
                                          as ImageProvider,
                                ),
                              ),
                              if (_isEditing)
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.regularUser?.fullName ?? 'FullName',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  state.regularUser?.username ?? 'Username',
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _showStats = true;
                                            _isEditing = false;
                                          });
                                        },
                                        child: const Text("View Stats"),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            _onEditProfilePressed(state),
                                        child: const Text("Edit Profile"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      if (_showStats) _buildStatsAndBlogsSection(isTablet),
                      if (_isEditing) _buildEditProfileSection(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatsAndBlogsSection(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Stats & Blogs',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: isTablet ? 800 : 400, // Adjust height for tablet
          child:
              const ProfileBlogListWidget(), // Use ListView for both tablets and phones
        ),
      ],
    );
  }

  Widget _buildEditProfileSection() {
    return Form(
      key: _key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _bioController,
            decoration: InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          const Text(
            'Add Social Links',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _buildSocialLinkButton('youtube'),
              _buildSocialLinkButton('instagram'),
              _buildSocialLinkButton('twitter'),
            ],
          ),
          if (_selectedSocialLink != null) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _socialLinksControllers[_selectedSocialLink],
              decoration: InputDecoration(
                labelText:
                    '${_selectedSocialLink![0].toUpperCase()}${_selectedSocialLink!.substring(1)} Link',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(_getSocialIcon(_selectedSocialLink!)),
              ),
            ),
          ],
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onSaveProfilePressed,
            child: const Text("Save Profile"),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLinkButton(String platform) {
    return ChoiceChip(
      label: Text(platform[0].toUpperCase() + platform.substring(1)),
      selected: _selectedSocialLink == platform,
      onSelected: (selected) {
        setState(() {
          _selectedSocialLink = selected ? platform : null;
        });
      },
      selectedColor: Colors.blue,
      labelStyle: TextStyle(
        color: _selectedSocialLink == platform ? Colors.white : Colors.black,
      ),
    );
  }

  IconData _getSocialIcon(String platform) {
    switch (platform) {
      case 'youtube':
        return Icons.link;
      case 'instagram':
        return Icons.link;
      case 'twitter':
        return Icons.link;
      default:
        return Icons.link;
    }
  }
}
