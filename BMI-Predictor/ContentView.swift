import SwiftUI
import TensorFlowLite

struct ContentView: View {
    @State var age = ""
    @State var height = ""
    @State var weight = ""
    @State var sleepHours = ""
    @State var selectedGender = 0  // 0=Male, 1=Other
    @State var isSmoker = false

    @State var selectedAlcohol = 0 // 0=Low, 1=Moderate, 2=High
    @State var selectedDiet = 0    // 0=Average, 1=Good, 2=Excellent
    @State var selectedExercise = 0 // 0=1-2, 1=3-5, 2=Daily
    @State var hasChronicDisease = false

    @State var result = "BMI"
    @State var bmiCategory = "Enter your details"

    let genderOptions = ["Male", "Other"]
    let alcoholOptions = ["Low", "Moderate", "High"]
    let dietOptions = ["Average", "Good", "Excellent"]
    let exerciseOptions = ["1-2", "3-5", "Daily"]

    private var interpreter: Interpreter?

    init() {
        interpreter = loadModel()
    }
    func loadModel() -> Interpreter? {
        guard let modelPath = Bundle.main.path(forResource: "bodexmodel", ofType: "tflite") else {
            print("❌ Model NOT FOUND")
            return nil
        }
        do {
            let interpreter = try Interpreter(modelPath: modelPath)
            try interpreter.allocateTensors()
            print("Model Loaded!")
            return interpreter
        } catch {
            print("❌ Error loading model:", error)
            return nil
        }
    }
    func predictBMI() {
        guard let interpreter = interpreter else { return }

        guard
            let ageF = Float(age),
            let heightF = Float(height),
            let weightF = Float(weight),
            let sleepF = Float(sleepHours)
        else {
            result = "?"
            bmiCategory = "Invalid Input"
            return
        }

        // One-hot encodings
        let genderMale: Float = selectedGender == 0 ? 1 : 0
        let genderOther: Float = selectedGender == 1 ? 1 : 0

        let smokerF: Float = isSmoker ? 1 : 0

        let alcoholLow: Float = selectedAlcohol == 0 ? 1 : 0
        let alcoholMod: Float = selectedAlcohol == 1 ? 1 : 0
        let alcoholHigh: Float = selectedAlcohol == 2 ? 1 : 0

        let dietAvg: Float = selectedDiet == 0 ? 1 : 0
        let dietGood: Float = selectedDiet == 1 ? 1 : 0
        let dietExc: Float = selectedDiet == 2 ? 1 : 0

        let ex12: Float = selectedExercise == 0 ? 1 : 0
        let ex35: Float = selectedExercise == 1 ? 1 : 0
        let exDaily: Float = selectedExercise == 2 ? 1 : 0

        let chronicYes: Float = hasChronicDisease ? 1 : 0
        let chronicNo: Float = hasChronicDisease ? 0 : 1

        // EXACT 19 MODEL INPUTS
        var inputVector: [Float] = [
            0.0, ageF, heightF, weightF, sleepF,
            genderMale, genderOther,
            smokerF,
            alcoholLow, alcoholMod, alcoholHigh,
            dietAvg, dietGood, dietExc,
            ex12, ex35, exDaily,
            chronicYes, chronicNo
        ]

        do {
            let inputData = Data(bytes: &inputVector,
                                 count: MemoryLayout<Float>.size * inputVector.count)
            try interpreter.copy(inputData, toInputAt: 0)
            try interpreter.invoke()

            let outputTensor = try interpreter.output(at: 0)
            let predicted = outputTensor.data.withUnsafeBytes {
                $0.load(as: Float.self)
            }

            result = String(format: "%.1f", predicted)
            bmiCategory = getBMICategory(predicted)

        } catch {
            print("❌ Prediction Error:", error)
            result = "ERR"
            bmiCategory = "Failed"
        }
    }

    func getBMICategory(_ bmi: Float) -> String {
        switch bmi {
        case ..<18.5: return "Underweight"
        case 18.5..<25: return "Normal"
        case 25..<30: return "Overweight"
        default: return "Obese"
        }
    }

    // MARK: UI STARTS HERE -----------------------------------

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // BMI DISPLAY
                VStack(spacing: 10) {
                    Text(result)
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.blue)

                    Text(bmiCategory)
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)

                // ===== ROW 1 =====
                HStack(spacing: 15) {
                    inputCard(title: "Age", value: $age, unit: "yrs")
                    inputCard(title: "Height", value: $height, unit: "cm")
                }

                // ===== ROW 2 =====
                HStack(spacing: 15) {
                    inputCard(title: "Weight", value: $weight, unit: "kg")
                    inputCard(title: "Sleep", value: $sleepHours, unit: "hrs")
                }

                // ===== ROW 3 (DROPDOWNS) =====
                HStack(spacing: 15) {
                    dropdownCard(title: "Gender", options: genderOptions, selection: $selectedGender)
                    dropdownCard(title: "Diet", options: dietOptions, selection: $selectedDiet)
                }

                // ===== ROW 4 =====
                HStack(spacing: 15) {
                    dropdownCard(title: "Alcohol", options: alcoholOptions, selection: $selectedAlcohol)
                    dropdownCard(title: "Exercise", options: exerciseOptions, selection: $selectedExercise)
                }

                // ===== TOGGLES =====
                toggleCard(title: "Smoker", isOn: $isSmoker)
                toggleCard(title: "Chronic Disease", isOn: $hasChronicDisease)

                Button(action: predictBMI) {
                    Text("Predict BMI")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
            }
            .padding(.horizontal)
        }
    }

    // MARK: Reusable UI Components

    func inputCard(title: String, value: Binding<String>, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            HStack {
                TextField(title, text: value)
                    .keyboardType(.decimalPad)

                Text(unit)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
    }

    func dropdownCard(title: String, options: [String], selection: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            Menu {
                ForEach(options.indices, id: \.self) { idx in
                    Button(options[idx]) { selection.wrappedValue = idx }
                }
            } label: {
                HStack {
                    Text(options[selection.wrappedValue])
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
            }
        }
        .frame(maxWidth: .infinity)
    }

    func toggleCard(title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .font(.headline)

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
    }
}
