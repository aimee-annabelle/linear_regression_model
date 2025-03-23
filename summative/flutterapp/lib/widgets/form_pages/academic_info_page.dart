import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/form_provider.dart';
import '../../../theme/app_theme.dart';
import '../custom_text_field.dart';

class AcademicInfoPage extends StatelessWidget {
  const AcademicInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Academic Information",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please provide the student's academic details",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: "Hours Studied (per week)",
              hintText: "e.g., 20",
              iconData: Icons.schedule,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  formProvider.data.hoursStudied = int.tryParse(value);
                }
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: "Previous Scores (0-100)",
              hintText: "e.g., 85",
              iconData: Icons.score,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  formProvider.data.previousScores = int.tryParse(value);
                }
              },
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
            CustomTextField(
              label: "Attendance (%)",
              hintText: "e.g., 90",
              iconData: Icons.calendar_today,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  formProvider.data.attendance = int.tryParse(value);
                }
              },
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
            const SizedBox(height: 16),
            CustomTextField(
              label: "Tutoring Sessions (per month)",
              hintText: "e.g., 4",
              iconData: Icons.person,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  formProvider.data.tutoringSessions = int.tryParse(value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "School Type",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Select school type"),
                  value: formProvider.data.schoolType,
                  items: const [
                    DropdownMenuItem(value: "Public", child: Text("Public")),
                    DropdownMenuItem(value: "Private", child: Text("Private")),
                  ],
                  onChanged: (value) {
                    formProvider.data.schoolType = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Teacher Quality",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Select teacher quality"),
                  value: formProvider.data.teacherQuality,
                  items: const [
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "High", child: Text("High")),
                  ],
                  onChanged: (value) {
                    formProvider.data.teacherQuality = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
