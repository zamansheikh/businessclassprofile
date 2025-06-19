import 'package:flutter/material.dart';
import 'class_selection_modal.dart';

class ShareExperienceModal extends StatefulWidget {
  const ShareExperienceModal({super.key});

  @override
  State<ShareExperienceModal> createState() => _ShareExperienceModalState();
}

class _ShareExperienceModalState extends State<ShareExperienceModal> {
  String? selectedDepartureAirport;
  String? selectedArrivalAirport;
  String? selectedAirline;
  String? selectedClass;
  DateTime? selectedTravelDate;
  double rating = 0;
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> airports = [
    'JFK - John F. Kennedy International Airport',
    'LAX - Los Angeles International Airport',
    'LHR - London Heathrow Airport',
    'DXB - Dubai International Airport',
    'NRT - Narita International Airport',
    'SIN - Singapore Changi Airport',
    'CDG - Charles de Gaulle Airport',
    'FRA - Frankfurt Airport',
  ];
  final List<String> airlines = [
    'Emirates',
    'Singapore Airlines',
    'Qatar Airways',
    'Lufthansa',
    'British Airways',
    'American Airlines',
    'Delta Air Lines',
    'United Airlines',
  ];
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.95,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageUploadSection(),
                      const SizedBox(height: 20),
                      _buildDropdown(
                        'Departure Airport',
                        selectedDepartureAirport,
                        airports,
                        (value) =>
                            setState(() => selectedDepartureAirport = value),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        'Arrival Airport',
                        selectedArrivalAirport,
                        airports,
                        (value) =>
                            setState(() => selectedArrivalAirport = value),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        'Airline',
                        selectedAirline,
                        airlines,
                        (value) => setState(() => selectedAirline = value),
                      ),
                      const SizedBox(height: 16),
                      _buildClassSelector(),
                      const SizedBox(height: 16),
                      _buildDescriptionField(),
                      const SizedBox(height: 16),
                      _buildDatePicker(),
                      const SizedBox(height: 20),
                      _buildRatingSection(),
                      const SizedBox(height: 24),
                      _buildShareButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.file_upload_outlined, size: 32, color: Colors.grey[600]),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: 'Drag and drop your files here, or ',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
              children: [
                TextSpan(
                  text: 'browse',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 4,
        decoration: const InputDecoration(
          hintText: 'Write description',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedTravelDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            selectedTravelDate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedTravelDate != null
                    ? '${selectedTravelDate!.day}/${selectedTravelDate!.month}/${selectedTravelDate!.year}'
                    : 'Travel Date',
                style: TextStyle(
                  color: selectedTravelDate != null
                      ? Colors.black
                      : Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rating',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  rating = index + 1.0;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  size: 32,
                  color: Colors.amber,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildShareButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle share action
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Experience shared successfully!')),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Share Now',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildClassSelector() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ClassSelectionModal(
            selectedClass: selectedClass,
            onClassSelected: (className) {
              setState(() {
                selectedClass = className;
              });
            },
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selectedClass ?? 'Class',
                style: TextStyle(
                  color: selectedClass != null
                      ? Colors.black
                      : Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
