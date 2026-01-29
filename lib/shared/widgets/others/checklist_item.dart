import 'package:flutter/material.dart';
import '../../theme.dart';

class ChecklistItem extends StatelessWidget {
  final String text;

  const ChecklistItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.2), // Orange muda
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: AppColors.secondary, // Icon orange
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5, // Line height agar enak dibaca
              ),
            ),
          ),
        ],
      ),
    );
  }
}
