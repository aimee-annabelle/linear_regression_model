class PredictionData {
  int? hoursStudied;
  int? attendance;
  int? previousScores;
  int? sleepHours;
  int? tutoringSessions;
  int? physicalActivity;
  String? parentalInvolvement;
  String? accessToResources;
  String? motivationLevel;
  String? extracurricularActivities;
  String? internetAccess;
  String? familyIncome;
  String? teacherQuality;
  String? schoolType;
  String? peerInfluence;
  String? learningDisabilities;
  String? parentalEducationLevel;
  String? distanceFromHome;
  String? gender;

  Map<String, dynamic> toJson() {
    return {
      "Hours_Studied": hoursStudied,
      "Attendance": attendance,
      "Previous_Scores": previousScores,
      "Sleep_Hours": sleepHours,
      "Tutoring_Sessions": tutoringSessions,
      "Physical_Activity": physicalActivity,
      "Parental_Involvement": parentalInvolvement,
      "Access_to_Resources": accessToResources,
      "Motivation_Level": motivationLevel,
      "Extracurricular_Activities": extracurricularActivities,
      "Internet_Access": internetAccess,
      "Family_Income": familyIncome,
      "Teacher_Quality": teacherQuality,
      "School_Type": schoolType,
      "Peer_Influence": peerInfluence,
      "Learning_Disabilities": learningDisabilities,
      "Parental_Education_Level": parentalEducationLevel,
      "Distance_from_Home": distanceFromHome,
      "Gender": gender,
    };
  }
}
