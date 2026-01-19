import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/providers.dart';

class RukunDetailScreen extends ConsumerStatefulWidget {
  final String rukunId;
  const RukunDetailScreen({super.key, required this.rukunId});

  @override
  ConsumerState<RukunDetailScreen> createState() => _RukunDetailScreenState();
}

class _RukunDetailScreenState extends ConsumerState<RukunDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncDetail = ref.watch(rukunDetailProvider(widget.rukunId));

    return Scaffold(
      appBar: AppBar(
        title: Text('Rukun'),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Inti (Sah)'),
            Tab(text: 'Sunnah (Opsional)'),
          ],
        ),
      ),
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal load detail: $e')),
        data: (d) {
          final title = (d['title'] ?? widget.rukunId) as String;
          final subtitle = (d['subtitle'] ?? '') as String;

          final inti = (d['inti'] ?? {}) as Map<String, dynamic>;
          final sunnah = (d['sunnah'] ?? {}) as Map<String, dynamic>;

          final media = (d['media'] ?? {}) as Map<String, dynamic>;
          final mediaType = (media['type'] ?? '') as String;
          final mediaPath = (media['assetPath'] ?? '') as String;

          final correction = (d['correction'] ?? {}) as Map<String, dynamic>;
          final correctionEnabled = (correction['enabled'] ?? false) as bool;

          return Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),

              // Media placeholder (sementara)
              if (mediaType.isNotEmpty && mediaPath.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Text(
                      'Media: $mediaType\n$mediaPath',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Tabs content
              Expanded(
                child: TabBarView(
                  controller: _tab,
                  children: [
                    _IntiTab(inti: inti),
                    _SunnahTab(sunnah: sunnah),
                  ],
                ),
              ),

              // Bottom actions
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              context.go('/rukun/${widget.rukunId}/practice'),
                          child: const Text('Latihan'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: correctionEnabled
                              ? () => context.go(
                                  '/rukun/${widget.rukunId}/camera',
                                )
                              : null,
                          child: const Text('Koreksi (Kamera)'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _IntiTab extends StatelessWidget {
  final Map<String, dynamic> inti;
  const _IntiTab({required this.inti});

  @override
  Widget build(BuildContext context) {
    final summary = (inti['summary'] ?? '') as String;
    final poin = (inti['poinPenting'] ?? []) as List;
    final errors = (inti['kesalahanUmum'] ?? []) as List;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        if (summary.isNotEmpty) Text(summary),
        if (poin.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Poin penting', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...poin.map((e) => _bullet(e.toString())),
        ],
        if (errors.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Kesalahan umum',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...errors.map((e) => _bullet(e.toString())),
        ],
      ],
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _SunnahTab extends StatelessWidget {
  final Map<String, dynamic> sunnah;
  const _SunnahTab({required this.sunnah});

  @override
  Widget build(BuildContext context) {
    final note =
        (sunnah['note'] ?? 'Opsional untuk menambah kesempurnaan.') as String;
    final items = (sunnah['items'] ?? []) as List;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      children: [
        Text(note),
        const SizedBox(height: 12),
        if (items.isEmpty)
          const Text('Belum ada sunnah khusus untuk rukun ini.')
        else
          ...items.map((it) {
            final m = it as Map;
            final t = (m['title'] ?? '').toString();
            final d = (m['description'] ?? '').toString();
            return Card(
              child: ListTile(
                title: Text(t),
                subtitle: d.isEmpty ? null : Text(d),
              ),
            );
          }),
      ],
    );
  }
}
