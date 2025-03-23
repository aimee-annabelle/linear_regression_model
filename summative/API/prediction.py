from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field, validator
import pandas as pd
import uvicorn
import os
import sys
import joblib
import pickle
from typing import Literal
import logging
import traceback

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

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
    confidence_level: str
    model_source: str
    
    class Config:
        schema_extra = {
            "example": {
                "predicted_exam_score": 78.5,
                "confidence_level": "Medium",
            }
        }

# Backup prediction class in case model loading fails
class BackupModel:
    """A linear regression model to use as backup if the original model fails to load"""
    
    def __init__(self):
        # Define coefficients based on typical impact of factors
        self.coefficients = {
            "Hours_Studied": 0.8,
            "Attendance": 0.15,
            "Previous_Scores": 0.5,
            "Sleep_Hours": 0.3,
            "Tutoring_Sessions": 1.0,
            "Physical_Activity": 0.2,
            "Parental_Involvement": {"Low": -5, "Medium": 0, "High": 5},
            "Access_to_Resources": {"Low": -4, "Medium": 0, "High": 4},
            "Motivation_Level": {"Low": -8, "Medium": 0, "High": 8},
            "Extracurricular_Activities": {"Yes": 2, "No": -1},
            "Internet_Access": {"Yes": 2, "No": -2},
            "Family_Income": {"Low": -2, "Medium": 0, "High": 2},
            "Teacher_Quality": {"Low": -5, "Medium": 0, "High": 5},
            "School_Type": {"Public": 0, "Private": 3},
            "Peer_Influence": {"Positive": 4, "Neutral": 0, "Negative": -4},
            "Learning_Disabilities": {"Yes": -6, "No": 0},
            "Parental_Education_Level": {"High School": 0, "College": 2, "Postgraduate": 3},
            "Distance_from_Home": {"Near": 2, "Moderate": 0, "Far": -2},
            "Gender": {"Male": 0, "Female": 0},
            "base_score": 50
        }
    
    def predict(self, X):
        """Predict exam scores based on input features"""
        predictions = []
        
        for _, row in X.iterrows():
            score = self.coefficients["base_score"]
            
            # Add contribution from numerical features
            score += row["Hours_Studied"] * self.coefficients["Hours_Studied"]
            score += row["Attendance"] * self.coefficients["Attendance"] / 100
            score += row["Previous_Scores"] * self.coefficients["Previous_Scores"] / 100
            score += row["Sleep_Hours"] * self.coefficients["Sleep_Hours"]
            score += row["Tutoring_Sessions"] * self.coefficients["Tutoring_Sessions"]
            score += row["Physical_Activity"] * self.coefficients["Physical_Activity"]
            
            # Add contribution from categorical features
            for feature in ["Parental_Involvement", "Access_to_Resources", "Motivation_Level", 
                           "Extracurricular_Activities", "Internet_Access", "Family_Income",
                           "Teacher_Quality", "School_Type", "Peer_Influence", 
                           "Learning_Disabilities", "Parental_Education_Level", 
                           "Distance_from_Home", "Gender"]:
                if feature in self.coefficients:
                    if isinstance(self.coefficients[feature], dict):
                        score += self.coefficients[feature].get(row[feature], 0)
            
            # Ensure score is within reasonable bounds
            score = max(0, min(100, score))
            predictions.append(score)
        
        return predictions

def load_model():
    """
    Attempts to load the model using multiple methods and paths.
    Returns the model and a string indicating the source.
    """
    # List of model paths to try
    model_paths = [
        # Relative paths
        os.path.join('models', 'best_student_performance_model.pkl'),
        'best_student_performance_model.pkl',
        # Absolute paths considering Render structure
        os.path.join(os.getcwd(), 'models', 'best_student_performance_model.pkl'),
        # Path considering Root Directory in Render settings
        os.path.join('..', 'models', 'best_student_performance_model.pkl'),
    ]
    
    # Methods to try loading the model
    loaders = [
        (joblib.load, "joblib"),
        (lambda path: pickle.load(open(path, 'rb')), "pickle")
    ]
    
    # Log the current directory and contents for debugging
    logger.info(f"Current directory: {os.getcwd()}")
    logger.info(f"Directory contents: {os.listdir('.')}")
    
    # Try to list the models directory if it exists
    if os.path.exists('models'):
        logger.info(f"Models directory contents: {os.listdir('models')}")
    
    # Try each path and loading method
    for path in model_paths:
        if os.path.exists(path):
            logger.info(f"Found model file at: {path}")
            for loader_func, loader_name in loaders:
                try:
                    model = loader_func(path)
                    logger.info(f"Successfully loaded model with {loader_name} from {path}")
                    return model, "Task 1 Model"
                except Exception as e:
                    logger.error(f"Failed to load with {loader_name} from {path}: {str(e)}")
                    logger.error(traceback.format_exc())
        else:
            logger.info(f"Model file not found at: {path}")
    
    # If all loading attempts fail, use the backup model
    logger.warning("Using backup model since all loading attempts failed")
    return BackupModel(), "Backup Model"

# Load the model
model, model_source = load_model()
logger.info(f"Model loaded. Source: {model_source}")

def get_confidence_level(input_data):
    """Determine confidence level based on key factors"""
    hours_studied = input_data.get('Hours_Studied', 0)
    attendance = input_data.get('Attendance', 0)
    previous_scores = input_data.get('Previous_Scores', 0)
    
    if hours_studied > 25 and attendance > 90 and previous_scores > 80:
        return "High"
    elif hours_studied > 15 and attendance > 75 and previous_scores > 65:
        return "Medium"
    else:
        return "Low"

@app.post("/predict", response_model=PredictionResponse)
def predict(student_data: StudentData):
    """Generate a prediction for student performance"""
    try:
        # Convert Pydantic model to dictionary
        student_dict = student_data.dict()
        
        # Create a DataFrame from the input data
        student_df = pd.DataFrame([student_dict])
        
        # Make prediction
        prediction = model.predict(student_df)[0]
        
        # Determine confidence level
        confidence = get_confidence_level(student_dict)
        
        # Round to 2 decimal places
        rounded_prediction = round(float(prediction), 2)
        
        return PredictionResponse(
            predicted_exam_score=rounded_prediction,
            confidence_level=confidence,
            model_source=model_source
        )
    except Exception as e:
        logger.error(f"Error making prediction: {str(e)}")
        logger.error(traceback.format_exc())
        raise HTTPException(status_code=500, detail=f"Prediction error: {str(e)}")

@app.get("/")
def read_root():
    """Root endpoint with API information"""
    return {
        "message": "Welcome to the Student Performance Prediction API",
        "docs": "Visit /docs for the interactive API documentation",
        "status": "operational",
    }

@app.get("/health")
def health_check():
    """Health check endpoint with detailed diagnostics"""
    try:
        # Get information about the environment
        env_info = {
            "python_version": sys.version,
            "current_directory": os.getcwd(),
            "model_source": model_source
        }
        
        # List directories to help with debugging
        dir_info = {}
        for path in [".", "models", "../models"]:
            try:
                if os.path.exists(path):
                    dir_info[path] = os.listdir(path)
                else:
                    dir_info[path] = "directory not found"
            except Exception as e:
                dir_info[path] = f"error listing directory: {str(e)}"
        
        # Test the model with sample data
        sample = StudentData(
            Hours_Studied=20,
            Attendance=85,
            Previous_Scores=75,
            Sleep_Hours=7,
            Tutoring_Sessions=2,
            Physical_Activity=3,
            Parental_Involvement="Medium",
            Access_to_Resources="Medium",
            Motivation_Level="Medium",
            Extracurricular_Activities="Yes",
            Internet_Access="Yes",
            Family_Income="Medium",
            Teacher_Quality="Medium",
            School_Type="Public",
            Peer_Influence="Positive",
            Learning_Disabilities="No",
            Parental_Education_Level="College",
            Distance_from_Home="Near",
            Gender="Female"
        )
        prediction = predict(sample)
        
        return {
            "status": "healthy",
            "model_source": model_source,
            "environment": env_info,
            "directories": dir_info,
            "test_prediction": prediction
        }
    except Exception as e:
        logger.error(f"Health check error: {str(e)}")
        logger.error(traceback.format_exc())
        return {
            "status": "error",
            "error": str(e),
            "traceback": traceback.format_exc(),
            "model_source": model_source
        }

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run("prediction:app", host="0.0.0.0", port=port)