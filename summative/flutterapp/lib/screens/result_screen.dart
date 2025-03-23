import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/form_provider.dart';
import '../theme/app_theme.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, Map<String, String>? inputData, double? predictedScore});

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FormProvider>(context);
    final prediction = formProvider.prediction ?? 0.0;
    

    String performanceLevel;
    Color performanceColor;

    // Determine performance level based on prediction
    if (prediction >= 90) {
      performanceLevel = "Excellent";
      performanceColor = Colors.green;
    } else if (prediction >= 80) {
      performanceLevel = "Very Good";
      performanceColor = Colors.lightGreen;
    } else if (prediction >= 70) {
      performanceLevel = "Good";
      performanceColor = Colors.lime;
    } else if (prediction >= 60) {
      performanceLevel = "Satisfactory";
      performanceColor = Colors.amber;
    } else if (prediction >= 50) {
      performanceLevel = "Needs Improvement";
      performanceColor = Colors.orange;
    } else {
      performanceLevel = "At Risk";
      performanceColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.school, color: AppTheme.darkColor),
            const SizedBox(width: 8),
            Text(
              "Prediction Results",
              style: TextStyle(
                color: AppTheme.darkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.darkColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Result Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, Colors.lightGreen.shade200],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Predicted Performance",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "${prediction.toStringAsFixed(1)}%",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: performanceColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        performanceLevel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Factors affecting performance
              const Text(
                "Key Factors",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _buildFactorCard(
                "Academic",
                "Hours studied and previous scores have a significant impact on performance.",
                Icons.school,
                Colors.blue,
              ),

              const SizedBox(height: 12),

              _buildFactorCard(
                "Personal",
                "Sleep hours and motivation level contribute to better learning outcomes.",
                Icons.person,
                Colors.purple,
              ),

              const SizedBox(height: 12),

              _buildFactorCard(
                "Environmental",
                "School quality and peer influence shape the student's learning environment.",
                Icons.home,
                Colors.teal,
              ),

              const SizedBox(height: 32),

              // Explanatory note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "What does this mean?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "This prediction is based on the data you provided. The score represents the estimated student performance based on historical data patterns. Use this as a guide to identify areas for potential improvement.",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Make another prediction button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    formProvider.reset();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: const Text(
                    "Make Another Prediction",
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
    );
  }

  Widget _buildFactorCard(
      String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
