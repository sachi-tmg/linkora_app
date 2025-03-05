import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/app/di/di.dart';
import 'package:linkora_app/features/blog/presentation/view/blog_page.dart';
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';
import 'package:linkora_app/features/regular_user/presentation/view/profile_view.dart';
import 'package:linkora_app/features/regular_user/presentation/view_model/profile_bloc.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final List<Widget> views;

  const HomeState({required this.selectedIndex, required this.views});

  // Initial state
  static HomeState initial() {
    return HomeState(
      selectedIndex: 0,
      views: [
        BlocProvider(
          create: (context) => getIt<BlogBloc>(),
          child: const BlogPage(),
        ),
        const Center(child: Text('Search')),
        BlocProvider(
          create: (context) => getIt<ProfileBloc>(),
          child: const ProfilePage(),
        ),
      ],
    );
  }

  HomeState copyWith({
    int? selectedIndex,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      views: views ?? this.views,
    );
  }

  @override
  List<Object?> get props => [selectedIndex, views];
}
