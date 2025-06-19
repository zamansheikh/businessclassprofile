import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'class_selection_modal.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';

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
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

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
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImages,
          child: Container(
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
          ),
        ),
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildSelectedImages(),
        ],
      ],
    );
  }

  Widget _buildSelectedImages() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImages[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
        isExpanded: true,
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
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, overflow: TextOverflow.ellipsis, maxLines: 1),
          );
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

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.clear();
          _selectedImages.addAll(images.map((xFile) => File(xFile.path)));
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitShareExperience() async {
    if (!_validateForm()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Parse departure airport
      final departureParts = selectedDepartureAirport!.split(' - ');
      final departureIata = departureParts[0];
      final departureInfo = _getAirportInfo(selectedDepartureAirport!);

      // Parse arrival airport
      final arrivalParts = selectedArrivalAirport!.split(' - ');
      final arrivalIata = arrivalParts[0];
      final arrivalInfo = _getAirportInfo(selectedArrivalAirport!);

      // Parse airline
      final airlineInfo = _getAirlineInfo(selectedAirline!);

      context.read<PostBloc>().add(ShareExperience(
        departure: departureInfo,
        arrival: arrivalInfo,
        airline: airlineInfo,
        classType: selectedClass!,
        rating: rating,
        shareDate: selectedTravelDate!,
        description: _descriptionController.text.trim(),
        authorId: "685391a607a87fb45ddc4a5a", // Placeholder - replace with actual user ID
        imagePaths: _selectedImages.isNotEmpty 
            ? _selectedImages.map((file) => file.path).toList() 
            : null,
      ));

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing experience: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  bool _validateForm() {
    if (selectedDepartureAirport == null) {
      _showValidationError('Please select departure airport');
      return false;
    }
    if (selectedArrivalAirport == null) {
      _showValidationError('Please select arrival airport');
      return false;
    }
    if (selectedAirline == null) {
      _showValidationError('Please select airline');
      return false;
    }
    if (selectedClass == null) {
      _showValidationError('Please select class');
      return false;
    }
    if (selectedTravelDate == null) {
      _showValidationError('Please select travel date');
      return false;
    }
    if (rating == 0) {
      _showValidationError('Please provide a rating');
      return false;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showValidationError('Please enter a description');
      return false;
    }
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Map<String, dynamic> _getAirportInfo(String airportString) {
    // Extract airport code and name from the string format: "JFK - John F. Kennedy International Airport"
    final parts = airportString.split(' - ');
    final iata = parts[0];
    final name = parts.length > 1 ? parts[1] : iata;
    
    // For now, using mock data for city and country
    // In a real app, you'd have a proper airport database
    return {
      "city": "New York", // This should be dynamic based on actual airport data
      "country": "United States",
      "iata": iata,
      "airport_name": name,
    };
  }

  Map<String, dynamic> _getAirlineInfo(String airlineName) {
    // For now, using mock data
    // In a real app, you'd have a proper airline database
    return {
      "name": airlineName,
      "code": "XX", // This should be the actual airline code
      "country": "Unknown",
    };
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
