import 'package:flutter/material.dart';

class ClassSelectionModal extends StatefulWidget {
  final String? selectedClass;
  final Function(String) onClassSelected;

  const ClassSelectionModal({
    super.key,
    this.selectedClass,
    required this.onClassSelected,
  });

  @override
  State<ClassSelectionModal> createState() => _ClassSelectionModalState();
}

class _ClassSelectionModalState extends State<ClassSelectionModal> {
  String? selectedClass;

  @override
  void initState() {
    super.initState();
    selectedClass = widget.selectedClass;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildClassOption('Any', selectedClass == 'Any'),
            const SizedBox(height: 8),
            _buildClassOption('Business', selectedClass == 'Business'),
            const SizedBox(height: 8),
            _buildClassOption('First', selectedClass == 'First'),
            const SizedBox(height: 8),
            _buildClassOption(
              'Premium Economy',
              selectedClass == 'Premium Economy',
            ),
            const SizedBox(height: 8),
            _buildClassOption('Economy', selectedClass == 'Economy'),
          ],
        ),
      ),
    );
  }

  Widget _buildClassOption(String className, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedClass = className;
        });
        widget.onClassSelected(className);
        Navigator.of(context).pop();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              className,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
