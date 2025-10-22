import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// We are not navigating to HomeScreen from here, but I'll leave the import
// in case you want to add it back in the _signup function.
// import '../home/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();
  File? _licenseImage;

  // Controllers for all the form fields
  final _ownerNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController(); // Added email for login
  final _passwordController =
      TextEditingController(); // Added password for login
  final _restaurantNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseNumberController = TextEditingController();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _restaurantNameController.dispose();
    _addressController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _licenseImage = File(pickedFile.path);
      });
    }
  }

  // Mock signup function
  void _signup() {
    // First, validate the form
    final isFormValid = _formKey.currentState?.validate() ?? false;

    // Check if an image was picked
    if (_licenseImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload your license/proof image.'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop if no image
    }

    if (isFormValid) {
      // --- BACKEND LOGIC GOES HERE ---
      // This is where you would:
      // 1. Call Firebase Auth (or your own backend) to create a user with
      //    _emailController.text and _passwordController.text
      // 2. Get the new user's UID.
      // 3. Upload the _licenseImage to Firebase Storage.
      // 4. Get the image URL.
      // 5. Send ALL text fields + the image URL + the UID to your Flask/MongoDB
      //    backend to create the new restaurant document.

      print('Signup successful! (Mock)');
      print('Owner: ${_ownerNameController.text}');
      print('Restaurant: ${_restaurantNameController.text}');
      print('License: ${_licenseNumberController.text}');
      print('Image Path: ${_licenseImage?.path}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup successful! (Mock)'),
          backgroundColor: Colors.green,
        ),
      );

      // TODO: After successful signup, navigate to the HomeScreen
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomeScreen()),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Signup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Partner!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Please fill in the details to get started.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              const Text(
                'Owner Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const Divider(),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _ownerNameController,
                label: 'Owner Full Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _emailController,
                label: 'Login Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _passwordController,
                label: 'Login Password',
                icon: Icons.lock_outline,
                isPassword: true,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _mobileController,
                label: 'Mobile Number',
                icon: Icons.phone_android,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              const Text(
                'Restaurant Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const Divider(),
              const SizedBox(height: 16),

              _buildTextFormField(
                controller: _restaurantNameController,
                label: 'Restaurant Name',
                icon: Icons.storefront_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _addressController,
                label: 'Restaurant Address',
                icon: Icons.location_on_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _licenseNumberController,
                label: 'Govt. License Number (FSSAI, etc.)',
                icon: Icons.article_outlined,
              ),
              const SizedBox(height: 24),

              // --- Image Upload Section ---
              const Text(
                'License / Proof Upload',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: _pickImage,
                  child: Center(
                    child: _licenseImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 40,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(height: 8),
                              const Text('Tap to upload image'),
                            ],
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              _licenseImage!,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- Signup Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _signup,
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for text fields to avoid repetition
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: isPassword,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (label == 'Login Email' && !value.contains('@')) {
          return 'Please enter a valid email';
        }
        if (label == 'Login Password' && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}
