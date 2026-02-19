import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import '../onboarding_state.dart';
import '../../../../core/theme/app_theme.dart';

class PhotosStep extends StatelessWidget {
  const PhotosStep({super.key});

  Future<void> _pickImage(BuildContext context, OnboardingState state) async {
    final ImagePicker picker = ImagePicker();
    try {
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
            state.addPhoto(image);
        }
    } catch (e) {
        // Handle error or permission denial
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to pick image")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OnboardingState>();
    final theme = Theme.of(context);

    // Fixed 6 slots
    final List<Widget> slots = List.generate(6, (index) {
        if (index < state.photos.length) {
            return _buildPhotoItem(context, state, index);
        } else {
            return _buildEmptySlot(context, state, index);
        }
    });

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add your best photos",
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Add at least 2 photos to continue. Tap to add, hold to reorder.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: theme.disabledColor,
                  ),
                ),
                const SizedBox(height: 32),

                // Grid
                // Using ReorderableListView for drag and drop if possible, but it's list based.
                // Implementing a simple GridView for now. 
                GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.8, // Portrait aspect ratio
                    children: slots,
                ),
              ],
            ),
          ),
        ),

        // Fixed Bottom Button Area
        Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: state.isPhotosValid ? state.nextStep : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                    ),
                    child: Text(
                        "Continue (${state.photos.length}/2)",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        ),
                    ),
                ),
            ),
        ),
      ],
    );
  }

  Widget _buildPhotoItem(BuildContext context, OnboardingState state, int index) {
      final path = state.photos[index].path;
      
      ImageProvider imageProvider;
      if (kIsWeb) {
        imageProvider = NetworkImage(path);
      } else {
        imageProvider = FileImage(File(path));
      }
      
      return Stack(
          children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                      ),
                  ),
              ),
              Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                      onTap: () => state.removePhoto(index),
                      child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                  ),
              ),
              if (index == 0)
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.8),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                              ),
                          ),
                          child: const Text(
                              "Main",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                      ),
                  ),
          ],
      );
  }

  Widget _buildEmptySlot(BuildContext context, OnboardingState state, int index) {
      final theme = Theme.of(context);
      return InkWell(
          onTap: () => _pickImage(context, state),
          borderRadius: BorderRadius.circular(12),
          child: Container(
              decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: theme.disabledColor.withOpacity(0.3),
                      style: BorderStyle.solid,
                      width: 1, // Dotted logic requires custom painter, solid is fine for MVP
                  ),
              ),
              child: Center(
                  child: Icon(
                      Icons.add_a_photo_rounded,
                      color: theme.disabledColor,
                      size: 24,
                  ),
              ),
          ),
      );
  }
}
