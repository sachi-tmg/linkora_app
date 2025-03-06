import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:linkora_app/features/home/presentation/view/home_view.dart';
import 'package:linkora_app/features/home/presentation/view_model/home_cubit.dart';

void main() {
  setUp(() {
    // Ensure that HomeCubit is registered with GetIt before running the test
    GetIt.instance.registerSingleton<HomeCubit>(HomeCubit());
  });

  tearDown(() {
    // Clean up GetIt after each test
    GetIt.instance.reset();
  });

  testWidgets(
    'Check for Home, Search, and Profile texts in BottomNavigationBar',
    (tester) async {
      // Build the HomeView widget with the HomeCubit instance from GetIt
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeCubit>(
            create: (_) =>
                GetIt.instance<HomeCubit>(), // Use GetIt to get HomeCubit
            child: const HomeView(),
          ),
        ),
      );

      // Check for the presence of 'Home', 'Search', and 'Profile' text in BottomNavigationBar
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );
}
