import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../theme/app_theme.dart';
import 'result_screen.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Input controllers for required fields
  final TextEditingController _hoursStudiedController = TextEditingController();
  final TextEditingController _attendanceController = TextEditingController();
  final TextEditingController _previousScoresController =
      TextEditingController();
  final TextEditingController _sleepHoursController = TextEditingController();
  final TextEditingController _tutoringsSessionsController =
      TextEditingController();
  final TextEditingController _physicalActivityController =
      TextEditingController();

  // Dropdown values
  String? _parentalInvolvement;
  String? _accessToResources;
  String? _motivationLevel;
  String? _extracurricularActivities;
  String? _internetAccess;
  String? _familyIncome;
  String? _teacherQuality;
  String? _schoolType;
  String? _peerInfluence;
  String? _learningDisabilities;
  String? _parentalEducationLevel;
  String? _distanceFromHome;
  String? _gender;

  String? _errorMessage;

  @override
  void dispose() {
    _hoursStudiedController.dispose();
    _attendanceController.dispose();
    _previousScoresController.dispose();
    _sleepHoursController.dispose();
    _tutoringsSessionsController.dispose();
    _physicalActivityController.dispose();
    super.dispose();
  }

  Future<void> _predict() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });

        // Prepare data for API request
        final Map<String, dynamic> requestData = {
          "Hours_Studied": int.parse(_hoursStudiedController.text),
          "Attendance": int.parse(_attendanceController.text),
          "Previous_Scores": int.parse(_previousScoresController.text),
          "Sleep_Hours": int.parse(_sleepHoursController.text),
          "Tutoring_Sessions": int.parse(_tutoringsSessionsController.text),
          "Physical_Activity": int.parse(_physicalActivityController.text),
          "Parental_Involvement": _parentalInvolvement ?? "Low",
          "Access_to_Resources": _accessToResources ?? "Low",
          "Motivation_Level": _motivationLevel ?? "Low",
          "Extracurricular_Activities": _extracurricularActivities ?? "No",
          "Internet_Access": _internetAccess ?? "Yes",
          "Family_Income": _familyIncome ?? "Low",
          "Teacher_Quality": _teacherQuality ?? "Low",
          "School_Type": _schoolType ?? "Public",
          "Peer_Influence": _peerInfluence ?? "Positive",
          "Learning_Disabilities": _learningDisabilities ?? "No",
          "Parental_Education_Level": _parentalEducationLevel ?? "High School",
          "Distance_from_Home": _distanceFromHome ?? "Near",
          "Gender": _gender ?? "Male",
        };

        // Make API call
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/predict'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(requestData),
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final double predictedScore = result['prediction'];

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                predictedScore: predictedScore,
                inputData: {
                  "Hours Studied": _hoursStudiedController.text,
                  "Previous Scores": _previousScoresController.text,
                  "Attendance": _attendanceController.text,
                  "Sleep Hours": _sleepHoursController.text,
                  "Parental Involvement": _parentalInvolvement ?? "Low",
                  "School Type": _schoolType ?? "Public",
                  "Gender": _gender ?? "Male",
                  // Add other inputs as needed
                },
              ),
            ),
          );
        } else {
          setState(() {
            _errorMessage =
                "Server error: ${response.statusCode}. ${response.body}";
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = "Error: ${e.toString()}";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _errorMessage = "Please fill in all required fields correctly.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.school, color: AppTheme.darkColor),
            const SizedBox(width: 8),
            Text(
              "StudentPredictor",
              style: TextStyle(
                color: AppTheme.darkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Enter Student Data",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Fill in the fields below to predict student performance",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Academic Inputs Section
                      const Text(
                        "Academic Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Hours Studied
                      const Text("Weekly Study Hours",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _hoursStudiedController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "e.g., 20",
                          suffixIcon: Icon(Icons.schedule),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter study hours";
                          }
                          if (int.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Previous Scores
                      const Text("Previous Scores (0-100)",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _previousScoresController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "e.g., 85",
                          suffixIcon: Icon(Icons.grade),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter previous scores";
                          }
                          final score = int.tryParse(value);
                          if (score == null) {
                            return "Please enter a valid number";
                          }
                          if (score < 0 || score > 100) {
                            return "Score must be between 0 and 100";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Attendance
                      const Text("Attendance (%)",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _attendanceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "e.g., 90",
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter attendance percentage";
                          }
                          final attendance = int.tryParse(value);
                          if (attendance == null) {
                            return "Please enter a valid number";
                          }
                          if (attendance < 0 || attendance > 100) {
                            return "Attendance must be between 0 and 100";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Personal Information Section
                      const Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Sleep Hours
                      const Text("Sleep Hours (per day)",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _sleepHoursController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "e.g., 8",
                          suffixIcon: Icon(Icons.nightlight),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter sleep hours";
                          }
                          final hours = int.tryParse(value);
                          if (hours == null) {
                            return "Please enter a valid number";
                          }
                          if (hours < 0 || hours > 24) {
                            return "Hours must be between 0 and 24";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Physical Activity
                      const Text("Physical Activity (hours per week)",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _physicalActivityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "e.g., 5",
                          suffixIcon: Icon(Icons.fitness_center),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter physical activity hours";
                          }
                          if (int.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Tutoring Sessions
                      const Text("Tutoring Sessions (per month)",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _tutoringsSessionsController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "e.g., 4",
                          suffixIcon: Icon(Icons.people),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter tutoring sessions";
                          }
                          if (int.tryParse(value) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Gender
                      const Text("Gender",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person),
                        ),
                        hint: const Text("Select gender"),
                        value: _gender,
                        items: const [
                          DropdownMenuItem(value: "Male", child: Text("Male")),
                          DropdownMenuItem(
                              value: "Female", child: Text("Female")),
                          DropdownMenuItem(
                              value: "Other", child: Text("Other")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select gender";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Environmental Factors Section
                      const Text(
                        "Environmental Factors",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // School Type
                      const Text("School Type",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.school),
                        ),
                        hint: const Text("Select school type"),
                        value: _schoolType,
                        items: const [
                          DropdownMenuItem(
                              value: "Public", child: Text("Public")),
                          DropdownMenuItem(
                              value: "Private", child: Text("Private")),
                          DropdownMenuItem(
                              value: "Charter", child: Text("Charter")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _schoolType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select school type";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Teacher Quality
                      const Text("Teacher Quality",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person_outline),
                        ),
                        hint: const Text("Select teacher quality"),
                        value: _teacherQuality,
                        items: const [
                          DropdownMenuItem(value: "Low", child: Text("Low")),
                          DropdownMenuItem(
                              value: "Medium", child: Text("Medium")),
                          DropdownMenuItem(value: "High", child: Text("High")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _teacherQuality = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),

                      // Socioeconomic Factors
                      const Text(
                        "Socioeconomic Factors",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Family Income
                      const Text("Family Income",
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.monetization_on),
                        ),
                        hint: const Text("Select income level"),
                        value: _familyIncome,
                        items: const [
                          DropdownMenuItem(value: "Low", child: Text("Low")),
                          DropdownMenuItem(
                              value: "Medium", child: Text("Medium")),
                          DropdownMenuItem(value: "High", child: Text("High")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _familyIncome = value;
                          });
                        },
                      ),

                      // Error message area
                      if (_errorMessage != null)
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Predict Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _predict,
                          child: const Text(
                            "Predict",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),
                      // Hardcoded Predict Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ResultScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Predict",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
