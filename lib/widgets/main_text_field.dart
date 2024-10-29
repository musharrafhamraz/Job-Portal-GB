import 'package:flutter/material.dart';

class SearchLocationTextField extends StatelessWidget {
  const SearchLocationTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search Field
          const Expanded(
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Search',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 30,
            color: Colors.grey.withOpacity(0.4),
          ),
          const SizedBox(width: 8),

          // Location Field
          const Expanded(
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'City, state, zip code',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
