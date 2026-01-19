import 'dart:convert';
import 'package:flutter/services.dart';

class ContentRepo {
  Future<List<Map<String, dynamic>>> loadRukunIndexItems() async {
    final raw = await rootBundle.loadString('assets/contents/rukun/index.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final items = (json['items'] as List).cast<Map<String, dynamic>>();
    return items;
  }

  Future<Map<String, dynamic>> loadRukunDetailItems(String id) async {
    final raw = await rootBundle.loadString('assets/contents/rukun/${id}.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return json;
  }
}
