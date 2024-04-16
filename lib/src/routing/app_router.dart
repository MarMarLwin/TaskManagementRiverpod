import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:task_management/src/features/authentication/data/auth_repository.dart';
import 'package:task_management/src/features/authentication/presentation/account/account_screen.dart';
import 'package:task_management/src/features/authentication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:task_management/src/features/authentication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:task_management/src/features/task/presentation/create_task/create_new_task.dart';
import 'package:task_management/src/features/task/presentation/task_list_screen.dart';
import 'package:task_management/src/routing/not_found_screen.dart';

part 'app_router.g.dart';

enum AppRoute { home, newTask, tasks, signIn, account }

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path == '/signIn') {
          return '/';
        }
      } else {
        if (path == '/signup') {
          return '/';
        }
      }
      return null;
    },
    // refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    routes: [
      GoRoute(
        path: '/',
        name: AppRoute.signIn.name,
        builder: (context, state) => EmailPasswordSignInScreen(
            formType: EmailPasswordSignInFormType.signIn,
            onSignedIn: () =>
                GoRouter.of(context).pushNamed(AppRoute.home.name)),
        routes: [
          GoRoute(
            path: 'home',
            name: AppRoute.home.name,
            builder: (context, state) => const TaskListScreen(),
            routes: [
              GoRoute(
                path: 'task/:id',
                name: AppRoute.newTask.name,
                builder: (context, state) {
                  final taskId = state.pathParameters['id']!;
                  return CreateNewTask(
                      id: taskId == 'new' ? null : int.parse(taskId));
                },
              ),
              GoRoute(
                path: 'account',
                name: AppRoute.account.name,
                pageBuilder: (context, state) {
                  return const MaterialPage(
                      fullscreenDialog: true, child: AccountScreen());
                },
              )
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
