import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final String appBarTitle;
  final List<Widget> views;

  const HomeState({
    required this.selectedIndex,
    required this.appBarTitle,
    required this.views,
  });

  HomeState copyWith({
    int? selectedIndex,
    String? appBarTitle,
    List<Widget>? views,
  }) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      appBarTitle: appBarTitle ?? this.appBarTitle,
      views: views ?? this.views,
    );
  }

  @override
  List<Object> get props => [selectedIndex, appBarTitle, views];
}
