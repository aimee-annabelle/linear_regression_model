import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/form_provider.dart';
import '../services/prediction_service.dart';
import '../theme/app_theme.dart';
import 'result_screen.dart';
import '../widgets/form_pages/academic_info_page.dart';
import '../widgets/form_pages/personal_info_page.dart';
import '../widgets/form_pages/socioeconomic_page.dart';
import '../widgets/form_pages/environment_page.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(
      builder: (context, formProvider, _) {
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
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppTheme.darkColor),
              onPressed: () {
                if (formProvider.currentPage > 0) {
                  formProvider.previousPage();
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          body: Column(
            children: [
              // Progress indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Step ${formProvider.currentPage + 1} of 4",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${((formProvider.currentPage + 1) / 4 * 100).toInt()}%",
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (formProvider.currentPage + 1) / 4,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),

              // Form pages
              Expanded(
                child: _buildCurrentPage(formProvider.currentPage),
              ),

              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (formProvider.currentPage > 0)
                      OutlinedButton(
                        onPressed: () => formProvider.previousPage(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppTheme.darkColor),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          "Back",
                          style: TextStyle(color: AppTheme.darkColor),
                        ),
                      )
                    else
                      const SizedBox(width: 100),
                    ElevatedButton(
                      onPressed: () {
                        if (formProvider.currentPage < 3) {
                          formProvider.nextPage();
                        } else {
                          _submitForm(context, formProvider);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              formProvider.currentPage < 3 ? "Next" : "Predict",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              formProvider.currentPage < 3
                                  ? Icons.arrow_forward
                                  : Icons.analytics,
                              color: AppTheme.darkColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentPage(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return const AcademicInfoPage();
      case 1:
        return const PersonalInfoPage();
      case 2:
        return const SocioeconomicPage();
      case 3:
        return const EnvironmentPage();
      default:
        return const AcademicInfoPage();
    }
  }

  void _submitForm(BuildContext context, FormProvider formProvider) async {
    formProvider.setLoading(true);
    formProvider.setError(null);

    try {
      final prediction =
          await PredictionService.getPrediction(formProvider.data);
      formProvider.setPrediction(prediction);

      // Navigate to results
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ResultScreen(),
          ),
        );
      }
    } catch (e) {
      print(formProvider.data);
      formProvider.setError(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error oooohhh: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      formProvider.setLoading(false);
    }
  }
}
