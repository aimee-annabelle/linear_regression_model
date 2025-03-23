from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, validator
import joblib
import pandas as pd
import uvicorn
import os
from typing import Optional, Literal

# Initialize FastAPI app with metadata
app = FastAPI(
    title="Student Performance Prediction API",
    description="API for predicting student academic performance based on various factors",
    version="1.0.0",
    docs_url="/docs"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Define the input data model with constraints using Pydantic
class StudentData(BaseModel):
    # Numerical features with range constraints
    Hours_Studied: float = Field(..., ge=0, le=50, description="Number of hours spent studying per week")
    Attendance: float = Field(..., ge=0, le=100, description="Percentage of classes attended")
    Previous_Scores: float = Field(..., ge=0, le=100, description="Scores from previous exams")
    Sleep_Hours: float = Field(..., ge=0, le=24, description="Average number of hours of sleep per night")
    Tutoring_Sessions: int = Field(..., ge=0, le=20, description="Number of tutoring sessions attended per month")
    Physical_Activity: int = Field(..., ge=0, le=20, description="Average number of hours of physical activity per week")
    
    # Categorical features with specific allowed values
    Parental_Involvement: Literal["Low", "Medium", "High"] = Field(..., description="Level of parental involvement")
    Access_to_Resources: Literal["Low", "Medium", "High"] = Field(..., description="Availability of educational resources")
    Motivation_Level: Literal["Low", "Medium", "High"] = Field(..., description="Student's level of motivation")
    Extracurricular_Activities: Literal["Yes", "No"] = Field(..., description="Participation in extracurricular activities")
    Internet_Access: Literal["Yes", "No"] = Field(..., description="Availability of internet access")
    Family_Income: Literal["Low", "Medium", "High"] = Field(..., description="Family income level")
    Teacher_Quality: Literal["Low", "Medium", "High"] = Field(..., description="Quality of the teachers")
    School_Type: Literal["Public", "Private"] = Field(..., description="Type of school attended")
    Peer_Influence: Literal["Positive", "Neutral", "Negative"] = Field(..., description="Influence of peers on academic performance")
    Learning_Disabilities: Literal["Yes", "No"] = Field(..., description="Presence of learning disabilities")
    Parental_Education_Level: Literal["High School", "College", "Postgraduate"] = Field(..., description="Highest education level of parents")
    Distance_from_Home: Literal["Near", "Moderate", "Far"] = Field(..., description="Distance from home to school")
    Gender: Literal["Male", "Female"] = Field(..., description="Gender of the student")
    
    # Add custom validators if needed
    @validator('Hours_Studied')
    def validate_hours_studied(cls, v):
        if v < 0:
            raise ValueError('Hours studied cannot be negative')
        return v
    
    @validator('Attendance')
    def validate_attendance(cls, v):
        if v < 0 or v > 100:
            raise ValueError('Attendance must be between 0 and 100 percent')
        return v
    
    class Config:
        schema_extra = {
            "example": {
                "Hours_Studied": 20,
                "Attendance": 85,
                "Previous_Scores": 75,
                "Sleep_Hours": 7,
                "Tutoring_Sessions": 2,
                "Physical_Activity": 3,
                "Parental_Involvement": "Medium",
                "Access_to_Resources": "Medium",
                "Motivation_Level": "Medium",
                "Extracurricular_Activities": "Yes",
                "Internet_Access": "Yes",
                "Family_Income": "Medium",
                "Teacher_Quality": "Medium",
                "School_Type": "Public",
                "Peer_Influence": "Positive",
                "Learning_Disabilities": "No",
                "Parental_Education_Level": "College",
                "Distance_from_Home": "Near",
                "Gender": "Female"
            }
        }

# Define the prediction response model
class PredictionResponse(BaseModel):
    predicted_exam_score: float
    confidence_level: str  # e.g., "High", "Medium", "Low"
    
    class Config:
        schema_extra = {
            "example": {
                "predicted_exam_score": 78.5,
                "confidence_level": "Medium"
            }
        }

# Load the model at startup
def load_model():
    try:
        # Try to load the model from the expected path
        model_path = os.path.join('models', 'best_student_performance_model.pkl')
        model = joblib.load(model_path)
        print("Model loaded successfully!")
        return model
    except Exception as e:
        print(f"Error loading model: {e}")
        # Return None if model could not be loaded
        return None

model = load_model()

# Helper function to determine confidence level based on model type
def get_confidence_level(input_data, prediction):
    # This is a simplistic approach - in a real system, you'd use
    # the model's uncertainty estimates or prediction intervals
    
    # Example logic: higher hours studied and attendance typically lead to more confident predictions
    hours_studied = input_data.get('Hours_Studied', 0)
    attendance = input_data.get('Attendance', 0)
    
    if hours_studied > 25 and attendance > 90:
        return "High"
    elif hours_studied > 15 and attendance > 75:
        return "Medium"
    else:
        return "Low"

# Prediction endpoint
@app.post("/predict", response_model=PredictionResponse)
def predict(student_data: StudentData):
    if model is None:
        raise HTTPException(status_code=500, detail="Model not loaded. Please ensure the model file exists and is accessible.")
    
    # Convert Pydantic model to dictionary
    student_dict = student_data.dict()
    
    # Create a DataFrame from the input data
    student_df = pd.DataFrame([student_dict])
    
    try:
        # Make prediction
        prediction = model.predict(student_df)[0]
        
        # Determine confidence level
        confidence = get_confidence_level(student_dict, prediction)
        
        # Round to 2 decimal places
        rounded_prediction = round(float(prediction), 2)
        
        return PredictionResponse(
            predicted_exam_score=rounded_prediction,
            confidence_level=confidence
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

# Health check endpoint
@app.get("/health")
def health_check():
    if model is None:
        return {"status": "unhealthy", "message": "Model not loaded"}
    return {"status": "healthy", "message": "API is running and model is loaded"}

# Run the app
if __name__ == "__main__":
    uvicorn.run("prediction:app", host="0.0.0.0", port=8000, reload=True)