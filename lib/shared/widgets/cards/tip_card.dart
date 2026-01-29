import 'package:flutter/material.dart';
import '../../theme.dart';

class TipCard extends StatelessWidget {
  final String text;

  const TipCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F6), // Abu-abu muda sekali (sesuai desain)
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb,
            color: Colors.amber, // Warna lampu kuning
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: const Color(0xFF2E646B), // Text agak kehijauan gelap
              ),
            ),
          ),
        ],
      ),
    );
  }
}
