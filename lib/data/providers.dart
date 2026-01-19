import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'content_repo.dart';

final contentRepoProvider = Provider((ref) => ContentRepo());

final rukunIndexProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final repo = ref.read(contentRepoProvider);
  return repo.loadRukunIndexItems();
});

final rukunDetailProvider = FutureProvider.family<Map<String, dynamic>, String>(
  (ref, id) async {
    return ref.read(contentRepoProvider).loadRukunDetailItems(id);
  },
);
