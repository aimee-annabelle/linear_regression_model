import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/form_provider.dart';
import '../../../theme/app_theme.dart';
import '../custom_text_field.dart';

class PersonalInfoPage extends StatelessWidget {
  const PersonalInfoPage({super.key});

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
              "Personal Information",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please provide the student's personal details",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: "Sleep Hours (per day)",
              hintText: "e.g., 8",
              iconData: Icons.nightlight,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  formProvider.data.sleepHours = int.tryParse(value);
                }
              },
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
            CustomTextField(
              label: "Physical Activity (hours per week)",
              hintText: "e.g., 5",
              iconData: Icons.fitness_center,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  formProvider.data.physicalActivity = int.tryParse(value);
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              "Gender",
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
                  hint: const Text("Select gender"),
                  value: formProvider.data.gender,
                  items: const [
                    DropdownMenuItem(value: "Male", child: Text("Male")),
                    DropdownMenuItem(value: "Female", child: Text("Female")),
                    DropdownMenuItem(value: "Other", child: Text("Other")),
                  ],
                  onChanged: (value) {
                    formProvider.data.gender = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Motivation Level",
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
                  hint: const Text("Select motivation level"),
                  value: formProvider.data.motivationLevel,
                  items: const [
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "High", child: Text("High")),
                  ],
                  onChanged: (value) {
                    formProvider.data.motivationLevel = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Extracurricular Activities",
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
                  hint: const Text("Select option"),
                  value: formProvider.data.extracurricularActivities,
                  items: const [
                    DropdownMenuItem(value: "Yes", child: Text("Yes")),
                    DropdownMenuItem(value: "No", child: Text("No")),
                  ],
                  onChanged: (value) {
                    formProvider.data.extracurricularActivities = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Learning Disabilities",
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
                  hint: const Text("Select option"),
                  value: formProvider.data.learningDisabilities,
                  items: const [
                    DropdownMenuItem(value: "Yes", child: Text("Yes")),
                    DropdownMenuItem(value: "No", child: Text("No")),
                  ],
                  onChanged: (value) {
                    formProvider.data.learningDisabilities = value;
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
