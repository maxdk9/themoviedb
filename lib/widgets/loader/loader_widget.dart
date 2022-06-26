import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/navigation/main_navigation.dart';
import 'package:themoviedb/widgets/loader/loader_view_cubit.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return BlocListener<LoaderViewCubit, LoaderViewCubitState>(
      listenWhen: (previous, current) =>
          current != LoaderViewCubitState.unknown,
      listener: onLoaderViewCubitStateChange,
      child: const Scaffold(
        body:  Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void onLoaderViewCubitStateChange(BuildContext context,LoaderViewCubitState state){
        final nextScreen = state == LoaderViewCubitState.authorized
            ? MainNavigationRouteNames.mainScreen
            : MainNavigationRouteNames.auth;
        Navigator.of(context).pushReplacementNamed(nextScreen);
  }
}
