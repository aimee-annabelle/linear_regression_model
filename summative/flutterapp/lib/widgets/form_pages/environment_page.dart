import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/form_provider.dart';
import '../../../theme/app_theme.dart';

class EnvironmentPage extends StatelessWidget {
  const EnvironmentPage({super.key});

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
              "Environment & Influence",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please provide information about the student's environment",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Distance from Home",
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
                  hint: const Text("Select distance"),
                  value: formProvider.data.distanceFromHome,
                  items: const [
                    DropdownMenuItem(value: "Near", child: Text("Near")),
                    DropdownMenuItem(value: "Moderate", child: Text("Moderate")),
                    DropdownMenuItem(value: "Far", child: Text("Far")),
                  ],
                  onChanged: (value) {
                    formProvider.data.distanceFromHome = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Peer Influence",
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
                  hint: const Text("Select influence type"),
                  value: formProvider.data.peerInfluence,
                  items: const [
                    DropdownMenuItem(
                        value: "Positive", child: Text("Positive")),
                    DropdownMenuItem(value: "Neutral", child: Text("Neutral")),
                    DropdownMenuItem(
                        value: "Negative", child: Text("Negative")),
                  ],
                  onChanged: (value) {
                    formProvider.data.peerInfluence = value;
                    formProvider.notifyListeners();
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber),
                      SizedBox(width: 8),
                      Text(
                        "Final Step",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    "You're almost done! Please review your entries before submitting. Click 'Predict' to get the student performance prediction.",
                    style: TextStyle(
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
