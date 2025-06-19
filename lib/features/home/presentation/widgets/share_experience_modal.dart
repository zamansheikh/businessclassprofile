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
  DateTime? selectedTravelDate;  double rating = 0;
  final TextEditingController _descriptionController = TextEditingController();
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final List<Map<String, String>> airports = [
    {
      'display': 'CXB - Cox\'s Bazar Airport',
      'iata': 'CXB',
      'name': 'Cox\'s Bazar Airport',
      'city': 'Cox\'s Bazar',
      'country': 'Bangladesh'
    },
    {
      'display': 'CGP - Chittagong Airport',
      'iata': 'CGP',
      'name': 'Chittagong Airport',
      'city': 'Chittagong',
      'country': 'Bangladesh'
    },
    {
      'display': 'JFK - John F. Kennedy International Airport',
      'iata': 'JFK',
      'name': 'John F. Kennedy International Airport',
      'city': 'New York',
      'country': 'United States'
    },
    {
      'display': 'LAX - Los Angeles International Airport',
      'iata': 'LAX',
      'name': 'Los Angeles International Airport',
      'city': 'Los Angeles',
      'country': 'United States'
    },
    {
      'display': 'LHR - London Heathrow Airport',
      'iata': 'LHR',
      'name': 'London Heathrow Airport',
      'city': 'London',
      'country': 'United Kingdom'
    },
    {
      'display': 'DXB - Dubai International Airport',
      'iata': 'DXB',
      'name': 'Dubai International Airport',
      'city': 'Dubai',
      'country': 'United Arab Emirates'
    },
    {
      'display': 'NRT - Narita International Airport',
      'iata': 'NRT',
      'name': 'Narita International Airport',
      'city': 'Tokyo',
      'country': 'Japan'
    },
    {
      'display': 'SIN - Singapore Changi Airport',
      'iata': 'SIN',
      'name': 'Singapore Changi Airport',
      'city': 'Singapore',
      'country': 'Singapore'
    },
  ];

  final List<Map<String, String>> airlines = [
    {
      'display': 'Air Bangladesh',
      'name': 'Air Bangladesh',
      'code': 'B9',
      'country': 'Bangladesh'
    },
    {
      'display': 'Emirates',
      'name': 'Emirates',
      'code': 'EK',
      'country': 'United Arab Emirates'
    },
    {
      'display': 'Singapore Airlines',
      'name': 'Singapore Airlines',
      'code': 'SQ',
      'country': 'Singapore'
    },
    {
      'display': 'Qatar Airways',
      'name': 'Qatar Airways',
      'code': 'QR',
      'country': 'Qatar'
    },
    {
      'display': 'Lufthansa',
      'name': 'Lufthansa',
      'code': 'LH',
      'country': 'Germany'
    },
    {
      'display': 'British Airways',
      'name': 'British Airways',
      'code': 'BA',
      'country': 'United Kingdom'
    },
    {
      'display': 'American Airlines',
      'name': 'American Airlines',
      'code': 'AA',
      'country': 'United States'
    },
    {
      'display': 'Delta Air Lines',
      'name': 'Delta Air Lines',
      'code': 'DL',
      'country': 'United States'
    },
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
                      const SizedBox(height: 20),                      _buildDropdown(
                        'Departure Airport',
                        selectedDepartureAirport,
                        airports.map((airport) => airport['display']!).toList(),
                        (value) =>
                            setState(() => selectedDepartureAirport = value),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        'Arrival Airport',
                        selectedArrivalAirport,
                        airports.map((airport) => airport['display']!).toList(),
                        (value) =>
                            setState(() => selectedArrivalAirport = value),
                      ),
                      const SizedBox(height: 16),
                      _buildDropdown(
                        'Airline',
                        selectedAirline,
                        airlines.map((airline) => airline['display']!).toList(),
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
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state is PostSubmitted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is PostSubmissionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: SizedBox(
        width: double.infinity,
        child: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            final isSubmitting = state is PostSubmitting;
            return ElevatedButton(
              onPressed: isSubmitting ? null : _submitShareExperience,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Share Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            );
          },
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
  }  Future<void> _submitShareExperience() async {
    if (!_validateForm()) return;

    try {
      // Parse departure airport
      final departureInfo = _getAirportInfo(selectedDepartureAirport!);

      // Parse arrival airport
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing experience: $e')),
      );
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
  Map<String, dynamic> _getAirportInfo(String airportDisplay) {
    // Find the airport data from our list
    final airportData = airports.firstWhere(
      (airport) => airport['display'] == airportDisplay,
      orElse: () => {
        'display': airportDisplay,
        'iata': 'XXX',
        'name': 'Unknown Airport',
        'city': 'Unknown',
        'country': 'Unknown'
      },
    );
    
    return {
      "city": airportData['city']!,
      "country": airportData['country']!,
      "iata": airportData['iata']!,
      "airport_name": airportData['name']!,
    };
  }

  Map<String, dynamic> _getAirlineInfo(String airlineDisplay) {
    // Find the airline data from our list
    final airlineData = airlines.firstWhere(
      (airline) => airline['display'] == airlineDisplay,
      orElse: () => {
        'display': airlineDisplay,
        'name': airlineDisplay,
        'code': 'XX',
        'country': 'Unknown'
      },
    );
    
    return {
      "name": airlineData['name']!,
      "code": airlineData['code']!,
      "country": airlineData['country']!,
    };
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
