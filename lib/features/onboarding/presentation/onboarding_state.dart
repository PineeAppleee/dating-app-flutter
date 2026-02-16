import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingState extends ChangeNotifier {
  int _currentStep = 0;
  int get currentStep => _currentStep;
  int get totalSteps => 6; // Identity, InterestedIn, Interests, Photos, Religion, Review

  // Step 1: Identity
  String _name = '';
  DateTime? _dob;
  String _gender = '';
  
  String get name => _name;
  DateTime? get dob => _dob;
  String get gender => _gender;

  // Step 2: Interested In
  final List<String> _interestedIn = [];
  List<String> get interestedIn => _interestedIn;

  // Step 3: Interests & Hobbies
  final List<String> _interests = [];
  List<String> get interests => _interests;

  // Step 4: Photos
  final List<XFile> _photos = [];
  List<XFile> get photos => _photos;

  // Step 5: Religion
  String? _religion;
  String? get religion => _religion;

  void nextStep() {
    if (_currentStep < totalSteps - 1) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void gotoStep(int step) {
      if (step >= 0 && step < totalSteps) {
          _currentStep = step;
          notifyListeners();
      }
  }

  // Setters
  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setDob(DateTime dob) {
    _dob = dob;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void toggleInterestedIn(String gender) {
    if (_interestedIn.contains(gender)) {
      _interestedIn.remove(gender);
    } else {
      _interestedIn.add(gender);
    }
    notifyListeners();
  }

  void toggleInterest(String interest) {
    if (_interests.contains(interest)) {
      _interests.remove(interest);
    } else {
      _interests.add(interest);
    }
    notifyListeners();
  }

  void addPhoto(XFile photo) {
    if (_photos.length < 6) {
      _photos.add(photo);
      notifyListeners();
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _photos.length) {
      _photos.removeAt(index);
      notifyListeners();
    }
  }
  
  void reorderPhotos(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final XFile item = _photos.removeAt(oldIndex);
    _photos.insert(newIndex, item);
    notifyListeners();
  }

  void setReligion(String? religion) {
    _religion = religion;
    notifyListeners();
  }
  
  int get age {
      if (_dob == null) return 0;
      final now = DateTime.now();
      int age = now.year - _dob!.year;
      if (now.month < _dob!.month || (now.month == _dob!.month && now.day < _dob!.day)) {
          age--;
      }
      return age;
  }
  
  bool get isIdentityValid => _name.isNotEmpty && _dob != null && _gender.isNotEmpty;
  bool get isInterestedInValid => _interestedIn.isNotEmpty;
  bool get isInterestsValid => _interests.length >= 3;
  bool get isPhotosValid => _photos.length >= 2;
}
