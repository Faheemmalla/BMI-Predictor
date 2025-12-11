📱 BMI Predictor — SwiftUI + TensorFlow Lite
A modern, lightweight BMI prediction app built with SwiftUI and powered by a TensorFlow Lite (TFLite) machine learning model.
The app provides an intuitive interface for users to enter health & lifestyle data, then predicts BMI and BMI category using on-device ML inference.

🚀 Features
⚡ Realtime BMI Prediction using TensorFlow Lite
🧠 Predicts BMI & BMI category
🎨 Clean, responsive SwiftUI interface
📦 .tflite model bundled with app for offline inference
👤 Includes lifestyle & health factors:
Age
Gender
Height & Weight
Sleep Hours
Alcohol Intake
Diet Quality
Exercise Level
Smoking
Chronic Disease
🔐 Fully offline — no data leaves the device
🧩 Modular architecture for easy expansion

🧠 Machine Learning Model
The app uses a TensorFlow Lite model trained using Python/Jupyter Notebook.
The .tflite file is located at:
BMI-Predictor/models/bodexmodel.tflite
The model predicts:
BMI value
BMI category (Underweight / Normal / Overweight / Obese)
