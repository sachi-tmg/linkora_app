import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linkora_app/app/di/di.dart';
import 'package:linkora_app/features/blog/presentation/view/create_blog_view.dart';
import 'package:linkora_app/features/blog/presentation/view_model/editor/create_blog_bloc.dart';
import 'package:linkora_app/features/home/presentation/view_model/home_cubit.dart';
import 'package:linkora_app/features/home/presentation/view_model/home_state.dart';
import 'package:sensors_plus/sensors_plus.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _hasLoggedOut = false;
  DateTime? _lastShakeTime; // Track the last shake time

  @override
  void initState() {
    super.initState();

    accelerometerEventStream().listen((AccelerometerEvent event) {
      if (!_hasLoggedOut &&
          (event.x.abs() > 15 || event.y.abs() > 15 || event.z.abs() > 15)) {
        final now = DateTime.now();
        // Debounce: Only trigger logout if the last shake was more than 2 seconds ago
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!) > const Duration(seconds: 2)) {
          _lastShakeTime = now;
          _hasLoggedOut = true;
          context.read<HomeCubit>().logout(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        return Scaffold(
          body: state.views[state.selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: state.selectedIndex,
            onTap: cubit.onTabTapped,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider<CreateBlogBloc>(
                      create: (_) => getIt<CreateBlogBloc>(),
                      child: const CreateBlogView(),
                    );
                  },
                ),
              );
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: const Icon(Icons.edit),
          ),
        );
      },
    );
  }
}
