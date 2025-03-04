import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/app/di/di.dart';
import 'package:linkora_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:linkora_app/features/blog/presentation/view/blog_page.dart';
import 'package:linkora_app/features/blog/presentation/view_model/view_blog/blog_bloc.dart';
import 'package:linkora_app/features/regular_user/presentation/view/profile_view.dart';
import 'package:linkora_app/features/regular_user/presentation/view_model/profile_bloc.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final TokenSharedPrefs tokenSharedPrefs;

  const HomeState(
      {required this.selectedIndex, required this.tokenSharedPrefs});

  factory HomeState.initial() => HomeState(
        selectedIndex: 0,
        tokenSharedPrefs: getIt<TokenSharedPrefs>(), // Inject dependency
      );

  HomeState copyWith({int? selectedIndex}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      tokenSharedPrefs: tokenSharedPrefs,
    );
  }

  List<Widget> get views => [
        BlocProvider(
          create: (context) => getIt<BlogBloc>(),
          child: const BlogPage(),
        ),
        const Center(child: Text('Search')),
        BlocProvider(
          create: (context) => getIt<ProfileBloc>(), // Provide ProfileBloc
          child: ProfilePage(tokenSharedPrefs: tokenSharedPrefs),
        ),
      ];

  @override
  List<Object> get props => [selectedIndex, tokenSharedPrefs];
}
