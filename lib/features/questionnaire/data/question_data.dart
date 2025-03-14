final List<String> questions = [
  "What is your age?",
  "Do you have Type 1 or Type 2 diabetes?",
  "Are you taking insulin?",
  "What is your average blood sugar level?",
  "Do you have a family history of diabetes?",
  "Are you currently on any diabetes medications?",
  "Do you follow a specific diet plan?",
  "How often do you check your blood sugar?",
  "Do you have any diabetes-related complications?",
  "Do you exercise regularly?",
  "What is your weight category?",
  "Do you smoke or consume alcohol?",
];

final Map<int, List<String>> options = {
  0: ["Under 18", "18-40", "40-60", "Above 60"],
  1: ["Type 1", "Type 2"],
  2: ["Yes", "No"],
  3: ["Below 100 mg/dL", "100-140 mg/dL", "140-200 mg/dL", "Above 200 mg/dL"],
  4: ["Yes", "No", "Not sure"],
  5: ["Yes", "No"],
  6: ["Low-carb", "Keto", "Mediterranean", "No specific diet"],
  7: ["Multiple times a day", "Once a day", "Few times a week", "Rarely"],
  8: ["None", "Neuropathy", "Retinopathy", "Kidney issues", "Heart issues"],
  9: ["Daily", "Few times a week", "Rarely", "Never"],
  10: ["Underweight", "Normal weight", "Overweight", "Obese"],
  11: ["Yes", "No"],
};
