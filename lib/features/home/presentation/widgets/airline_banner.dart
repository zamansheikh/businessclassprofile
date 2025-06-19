import 'package:flutter/material.dart';

class AirlineBanner extends StatelessWidget {
  const AirlineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE6A47A), // Light orange/beige
            Color(0xFF8B3A7E), // Purple
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background airplane image
          Positioned(
            left: -20,
            top: 20,
            child: Opacity(
              opacity: 0.3,
              child: Image.network(
                'https://via.placeholder.com/200x100', // Placeholder for airplane image
                width: 150,
                height: 80,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.airplanemode_active,
                    size: 80,
                    color: Colors.white,
                  );
                },
              ),
            ),
          ),
          // Qatar Airways text
          const Positioned(
            right: 20,
            top: 30,
            child: Text(
              'QATAR AIRWAYS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          // Subtle pattern overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
