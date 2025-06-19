import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          // Handle search tap
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Search feature coming soon!')),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2D2D2D),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(Icons.search, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
