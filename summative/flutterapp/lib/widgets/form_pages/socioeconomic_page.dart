import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/form_provider.dart';
import '../../../theme/app_theme.dart';

class SocioeconomicPage extends StatelessWidget {
  const SocioeconomicPage({super.key});

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
              "Socioeconomic Factors",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please provide information about socioeconomic factors",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Family Income",
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
                  hint: const Text("Select family income level"),
                  value: formProvider.data.familyIncome,
                  items: const [
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "High", child: Text("High")),
                  ],
                  onChanged: (value) {
                    formProvider.data.familyIncome = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Parental Education Level",
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
                  hint: const Text("Select education level"),
                  value: formProvider.data.parentalEducationLevel,
                  items: const [
                    
                    DropdownMenuItem(
                        value: "High School", child: Text("High School")),
                    DropdownMenuItem(
                        value: "College", child: Text("College")),
                    DropdownMenuItem(
                        value: "Postgraduate", child: Text("Postgraduate")),
                  ],
                  onChanged: (value) {
                    formProvider.data.parentalEducationLevel = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Parental Involvement",
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
                  hint: const Text("Select level of involvement"),
                  value: formProvider.data.parentalInvolvement,
                  items: const [
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "High", child: Text("High")),
                  ],
                  onChanged: (value) {
                    formProvider.data.parentalInvolvement = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Internet Access",
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
                  value: formProvider.data.internetAccess,
                  items: const [
                    DropdownMenuItem(value: "Yes", child: Text("Yes")),
                    DropdownMenuItem(value: "No", child: Text("No")),
                  ],
                  onChanged: (value) {
                    formProvider.data.internetAccess = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Access to Resources",
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
                  hint: const Text("Select level of access"),
                  value: formProvider.data.accessToResources,
                  items: const [
                    DropdownMenuItem(value: "Low", child: Text("Low")),
                    DropdownMenuItem(value: "Medium", child: Text("Medium")),
                    DropdownMenuItem(value: "High", child: Text("High")),
                  ],
                  onChanged: (value) {
                    formProvider.data.accessToResources = value;
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
