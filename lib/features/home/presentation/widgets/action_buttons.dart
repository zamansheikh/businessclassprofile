import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _ActionButton(
              text: 'Share Your Experience',
              icon: Icons.rate_review_outlined,
              onTap: () {
                // Handle share experience
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Share Experience feature coming soon!'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ActionButton(
              text: 'Ask A Question',
              icon: Icons.help_outline,
              onTap: () {
                // Handle ask question
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ask Question feature coming soon!'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
