import 'package:flutter/material.dart';

class SearchLocationTextField extends StatelessWidget {
  final Function(String) onSearchChanged;
  final Function(String) onLocationChanged;

  const SearchLocationTextField({
    super.key,
    required this.onSearchChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
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
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                    onChanged: onSearchChanged, // Trigger onSearchChanged
                  ),
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
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'City, state, zip code',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                    onChanged: onLocationChanged, // Trigger onLocationChanged
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
