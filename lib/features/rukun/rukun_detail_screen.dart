import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets/button/primary_button.dart';
import '../../shared/widgets/cards/tip_card.dart';
import '../../shared/widgets/others/checklist_item.dart';
import '../../shared/theme.dart';
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
    // Listen to tab changes to trigger rebuild
    _tab.addListener(() {
      if (!_tab.indexIsChanging) {
        setState(() {});
      }
    });
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
        title: const Text(
          'Detail Gerakan',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
      ),
      body: asyncDetail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal load detail: $e')),
        data: (d) {
          final title = (d['title'] ?? widget.rukunId) as String;
          final subtitle = (d['subtitle'] ?? '') as String;

          // Inti (Wajib) data
          final inti = (d['inti'] ?? {}) as Map<String, dynamic>;
          final intiSummary = (inti['summary'] ?? '') as String;
          final poinPenting = (inti['poinPenting'] ?? []) as List;
          final kesalahanUmum = (inti['kesalahanUmum'] ?? []) as List;

          // Sunnah data
          final sunnah = (d['sunnah'] ?? {}) as Map<String, dynamic>;
          final sunnahNote =
              (sunnah['note'] ?? 'Opsional untuk menambah kesempurnaan.')
                  as String;
          final sunnahItems = (sunnah['items'] ?? []) as List;

          final correction = (d['correction'] ?? {}) as Map<String, dynamic>;
          final correctionEnabled = (correction['enabled'] ?? false) as bool;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Video Player Container
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.offline_pin,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "OFFLINE READY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. Tab Switcher (Custom Style)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F6),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TabBar(
                    controller: _tab,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: "Wajib"),
                      Tab(text: "Sunnah"),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 3. Title & Description
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _tab.index == 0 ? intiSummary : sunnahNote,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 24),

                // 4. Content based on selected tab
                if (_tab.index == 0) ...[
                  // === WAJIB TAB ===
                  // Poin Penting
                  Text(
                    "Poin Penting",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.black12.withOpacity(0.05),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: poinPenting.isEmpty
                          ? const [Text("Data poin penting belum tersedia.")]
                          : poinPenting
                                .map((e) => ChecklistItem(text: e.toString()))
                                .toList(),
                    ),
                  ),

                  // Kesalahan Umum (jika ada)
                  if (kesalahanUmum.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      "Kesalahan Umum",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Column(
                        children: kesalahanUmum
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.red.shade400,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        e.toString(),
                                        style: TextStyle(
                                          color: Colors.red.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ] else ...[
                  // === SUNNAH TAB ===
                  Text(
                    "Sunnah",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (sunnahItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F4F6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          "Belum ada sunnah khusus untuk rukun ini.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...sunnahItems.map((item) {
                      final itemMap = item as Map<String, dynamic>;
                      final itemTitle = (itemMap['title'] ?? '') as String;
                      final itemDescription =
                          (itemMap['description'] ?? '') as String;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.black12.withOpacity(0.05),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary.withOpacity(
                                      0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.star_rounded,
                                    color: AppColors.secondary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    itemTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                            if (itemDescription.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                itemDescription,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Colors.black54,
                                      height: 1.5,
                                    ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                ],

                const SizedBox(height: 32),

                // 5. Action Buttons
                PrimaryButton(
                  text: 'Mulai Latihan',
                  icon: const Icon(Icons.fitness_center),
                  onPressed: () =>
                      context.go('/rukun/${widget.rukunId}/practice'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: correctionEnabled
                        ? () => context.go('/rukun/${widget.rukunId}/camera')
                        : null,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      foregroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.videocam_outlined),
                    label: const Text('Cek Gerakan (Kamera)'),
                  ),
                ),

                const SizedBox(height: 32),

                // 6. Footer Tip
                const TipCard(
                  text:
                      "\"Tidak apa-apa kalau masih bingung, ulangi pelan-pelan ya. Allah melihat usahamu, bukan hanya hasilnya.\"",
                ),

                const SizedBox(height: 48), // Bottom padding
              ],
            ),
          );
        },
      ),
    );
  }
}
