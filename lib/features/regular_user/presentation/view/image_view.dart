import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkora_app/features/home/presentation/view/home_view.dart';
import 'package:linkora_app/features/regular_user/presentation/view_model/image_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadProfile extends StatefulWidget {
  final String userId;

  const UploadProfile({super.key, required this.userId});

  @override
  State<UploadProfile> createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  final _key = GlobalKey<FormState>();

  Future<void> checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  File? _img;

  Future<void> _browseImage(ImageSource imageSource) async {
    try {
      final profilePicture = await ImagePicker().pickImage(source: imageSource);
      if (profilePicture != null) {
        setState(() {
          _img = File(profilePicture.path);
          context.read<ImageBloc>().add(
                LoadImageP(file: _img!),
              );
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onSkipPressed() {
    context.read<ImageBloc>().add(
          NavigateHomeScreenEvent(
            context: context,
            destination: const HomeView(),
          ),
        );
  }

  void _onNextPressed() {
    final regularUserState = context.read<ImageBloc>().state;
    final imageName = regularUserState.imageName;
    context.read<ImageBloc>().add(
          RegularUser(
            context: context,
            userId: widget.userId,
            profilePicture: imageName,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose a profile picture',
          style: TextStyle(fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.grey[300],
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                checkCameraPermission();
                                _browseImage(ImageSource.camera);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.camera),
                              label: const Text('Camera'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                _browseImage(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.image),
                              label: const Text('Gallery'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _img != null
                          ? FileImage(_img!)
                          : const AssetImage(
                                  'assets/images/default_profile.jpg')
                              as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _img == null
                    ? ElevatedButton(
                        onPressed: _onSkipPressed,
                        child: const Text("Skip"),
                      )
                    : ElevatedButton(
                        onPressed: _onNextPressed,
                        child: const Text("Next"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
