// InputCardView.swift
import SwiftUI

struct InputCardView: View {
    let hintText: String
    let bgColor: Color
    let iconName: String
    @Binding var userInput: String
    let keyboardType: UIKeyboardType
    let unit: String

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 26))
                .foregroundColor(.white)
                .frame(width: 54, height: 54)
                .background(Color.white.opacity(0.18))
                .cornerRadius(10)
                .padding(.leading, 16)

            VStack(alignment: .leading, spacing: 6) {
                Text(hintText)
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.95))

                ZStack(alignment: .leading) {
                    if userInput.isEmpty {
                        Text("Enter \(hintText.lowercased())")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 20, weight: .medium))
                    }
                    TextField("", text: $userInput)
                        .keyboardType(keyboardType)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                        .disableAutocorrection(true)
                }
            }
            .padding(.vertical, 12)

            Spacer()

            Text(unit)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.85))
                .padding(.trailing, 16)
        }
        .background(bgColor)
        .cornerRadius(14)
        .shadow(color: bgColor.opacity(0.25), radius: 6, y: 3)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}
