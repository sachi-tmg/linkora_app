part of 'dashboard_bloc.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<String>
      posts; // For simplicity, we'll use a list of Strings for post titles
  DashboardLoaded({required this.posts});
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError({required this.message});
}
