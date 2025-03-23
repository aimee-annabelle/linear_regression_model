
import pandas as pd
import joblib
import os

def predict_student_performance(student_data, model_path='models/best_student_performance_model.pkl'):

    # Check if model exists
    if not os.path.exists(model_path):
        raise FileNotFoundError(f"Model file not found at {model_path}")
    
    # Load the model
    model = joblib.load(model_path)
    
    # Convert to DataFrame (single row)
    student_df = pd.DataFrame([student_data])
    
    # Make prediction
    prediction = model.predict(student_df)[0]
    
    return prediction

if __name__ == "__main__":
    # Example usage
    sample_student = {
        'Hours_Studied': 20,
        'Attendance': 85,
        'Parental_Involvement': 'Medium',
        'Access_to_Resources': 'Medium',
        'Extracurricular_Activities': 'Yes',
        'Sleep_Hours': 7,
        'Previous_Scores': 75,
        'Motivation_Level': 'Medium',
        'Internet_Access': 'Yes',
        'Tutoring_Sessions': 2,
        'Family_Income': 'Medium',
        'Teacher_Quality': 'Medium',
        'School_Type': 'Public',
        'Peer_Influence': 'Positive',
        'Physical_Activity': 3,
        'Learning_Disabilities': 'No',
        'Parental_Education_Level': 'College',
        'Distance_from_Home': 'Near',
        'Gender': 'Female'
    }
    
    try:
        predicted_score = predict_student_performance(sample_student)
        print(f"Predicted exam score: {predicted_score:.2f}")
    except Exception as e:
        print(f"Error making prediction: {e}")
