import 'package:flutter/material.dart';
import '../../theme.dart'; // Import tema agar bisa akses AppColors

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final bool isLoading;
  final double height;
  final double borderRadius;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.height = 52.0, // Standar tinggi tombol mobile yang nyaman
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Full width
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable klik saat loading
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(
            0.5,
          ), // Warna saat disabled/loading
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0, // Flat design modern biasanya tanpa bayangan berlebih
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!, // Tampilkan icon
                    const SizedBox(width: 8), // Jarak icon ke teks
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, // Semi bold
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
