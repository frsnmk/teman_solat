import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teman_solat/features/home/home_screen.dart';
import 'package:teman_solat/features/splash/splash_screen.dart'; // Fixed import
import 'package:teman_solat/features/rukun/rukun_detail_screen.dart';
import 'package:teman_solat/features/rukun/rukun_list_screen.dart';
import 'package:teman_solat/features/settings/settings_screen.dart';

import 'package:flutter/material.dart'; //sementara (sebelum dipindah isian dari kamera dan practice)

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/rukun',
        builder: (context, state) => const RukunListScreen(),
      ),
      GoRoute(
        path: '/rukun/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return RukunDetailScreen(rukunId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/rukun/:id/practice',
        builder: (_, state) => Scaffold(
          appBar: AppBar(title: const Text('Latihan')),
          body: Center(child: Text('Practice: ${state.pathParameters['id']}')),
        ),
      ),
      GoRoute(
        path: '/rukun/:id/camera',
        builder: (_, state) => Scaffold(
          appBar: AppBar(title: const Text('Koreksi Kamera')),
          body: Center(child: Text('Camera: ${state.pathParameters['id']}')),
        ),
      ),
    ],
  );
});
