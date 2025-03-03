import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/app/di/di.dart';
import 'package:linkora_app/features/auth/presentation/view/login_view.dart';
import 'package:linkora_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:linkora_app/features/blog/presentation/view/blog_page.dart';
import 'package:linkora_app/features/home/presentation/view_model/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          const HomeState(
            selectedIndex: 0,
            appBarTitle: "Dashboard",
            views: [
              BlogPage(), // BlogPage as the first view
              Center(child: Text('Search')), // Placeholder for Search
              Center(child: Text('Profile')), // Placeholder for Profile
            ],
          ),
        );

  void onTabTapped(int index) {
    final titles = ["Dashboard", "Search", "Profile"];
    emit(state.copyWith(selectedIndex: index, appBarTitle: titles[index]));
  }

  Future<void> logout(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<LoginBloc>(),
            child: LoginView(),
          ),
        ),
      );
    }
  }
}
