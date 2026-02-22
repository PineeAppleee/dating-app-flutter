import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/repositories/auth_repository.dart';
import '../../../../core/theme/app_theme.dart';

class PhoneLoginSheet extends StatefulWidget {
  const PhoneLoginSheet({super.key});

  @override
  State<PhoneLoginSheet> createState() => _PhoneLoginSheetState();
}

class _PhoneLoginSheetState extends State<PhoneLoginSheet> {
  // _phoneController is no longer needed directly for text, but we need to store the full number
  String? _completePhoneNumber;
  final _otpController = TextEditingController();
  final _authRepo = AuthRepository();

  bool _codeSent = false;
  String? _verificationId;
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _verifyPhone() async {
    final phone = _completePhoneNumber;
    if (phone == null || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authRepo.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android only: Auto-resolution
          debugPrint("✅ Auto-retrieval success!");
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          debugPrint("❌ Phone Auth Error: ${e.code} - ${e.message}");
          
          String message = "Verification Failed: ${e.code} - ${e.message}";
          if (e.code == 'invalid-phone-number') {
            message = "Invalid phone number format.";
          } else if (e.code == 'too-many-requests') {
            message = "Too many requests. Try again later.";
          } else if (e.code == 'app-not-authorized') {
            message = "App not authorized. Check SHA-256 in Firebase Console.";
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: "Copy",
                onPressed: () {
                  // TODO: Implement copy to clipboard if needed
                },
              ),
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint("📩 Code Sent to $phone");
          setState(() {
            _verificationId = verificationId;
            _codeSent = true;
            _isLoading = false;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint("⏰ Timeout for ID: $verificationId");
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty || _verificationId == null) return;

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _signInWithCredential(credential);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid OTP: $e")),
        );
      }
    }
  }

  Future<void> _signInWithCredential(AuthCredential credential) async {
    try {
      await _authRepo.signInWithCredential(credential);
      if (mounted) {
         Navigator.pop(context); // Close sheet
         // Routing is handled automatically by GoRouter redirect
      }
    } catch (e) {
      setState(() => _isLoading = false);
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sign In Failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _codeSent ? "Enter Verification Code" : "Enter Phone Number",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (!_codeSent) ...[
            IntlPhoneField(
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
              initialCountryCode: 'IN',
              onChanged: (phone) {
                // IMPORTANT: The library returns the full number including the + and country code
                _completePhoneNumber = phone.completeNumber;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyPhone,
                            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Receive OTP"),
            ),
          ] else ...[
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "6-Digit Code",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_clock),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
             onPressed: _isLoading ? null : _verifyOtp,
               style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Verify & Login"),
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
