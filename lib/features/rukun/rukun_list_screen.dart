import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';

class RukunListScreen extends ConsumerWidget {
  const RukunListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(rukunIndexProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Rukun')),
      body: asyncItems.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal load JSON: $e')),
        data: (items) {
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final item = items[i];
              final id = item['id'] as String;
              final title = item['title'] as String;
              final subtitle = item['subtitle'] as String;

              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/rukun/$id'),
              );
            },
          );
        },
      ),
    );
  }
}
