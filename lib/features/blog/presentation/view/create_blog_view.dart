import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:linkora_app/app/di/di.dart';
import 'package:linkora_app/core/common/snackbar/my_snackbar.dart';
import 'package:linkora_app/features/blog/data/model/blog_api_model.dart';
import 'package:linkora_app/features/blog/presentation/view_model/editor/create_blog_bloc.dart';
import 'package:linkora_app/features/home/presentation/view/home_view.dart';
import 'package:linkora_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateBlogView extends StatefulWidget {
  const CreateBlogView({super.key});

  @override
  State<CreateBlogView> createState() => _CreateBlogViewState();
}

class _CreateBlogViewState extends State<CreateBlogView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();

  File? _image;

  Future<void> _checkCameraPermission() async {
    if (await Permission.camera.request().isRestricted ||
        await Permission.camera.request().isDenied) {
      await Permission.camera.request();
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
          context.read<CreateBlogBloc>().add(
                UploadBanner(file: _image!),
              );
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void _showImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                _checkCameraPermission();
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Blog'),
      ),
      body: BlocListener<CreateBlogBloc, CreateBlogState>(
        listener: (context, state) {
          if (state is BlogCreated) {
            Future.delayed(const Duration(seconds: 1), () {
              showMySnackBar(
                context: context,
                message: "Blog Published",
                color: Colors.greenAccent,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider<HomeCubit>(
                      create: (_) => getIt<HomeCubit>(),
                      child: const HomeView(),
                    );
                  },
                ),
              );
            });
          } else if (state is BlogError) {
            // Show error SnackBar
            showMySnackBar(
              context: context,
              message: state.message,
              color: Colors.red,
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Image Picker Section
              GestureDetector(
                onTap: () => _showImagePickerModal(context),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Short Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Short Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Content Field
              TextFormField(
                controller: _contentController,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Tags Field
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Buttons Row
              Row(
                children: [
                  // Save Draft Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final blog = BlogApiModel(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          blogPicture: _image != null ? _image!.path : '',
                          content: _contentController.text,
                          tags: _tagsController.text.split(','),
                          draft: true,
                        );

                        context
                            .read<CreateBlogBloc>()
                            .add(CreateBlogRequested(blog: blog));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text('Save Draft'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final blog = BlogApiModel(
                          title: _titleController.text,
                          description: _descriptionController.text,
                          blogPicture: _image != null ? _image!.path : '',
                          content: _contentController.text,
                          tags: _tagsController.text.split(','),
                          draft: false,
                        );

                        context
                            .read<CreateBlogBloc>()
                            .add(CreateBlogRequested(blog: blog));
                      },
                      child: const Text('Create Blog'),
                    ),
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
