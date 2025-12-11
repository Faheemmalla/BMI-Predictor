// ToggleCardView.swift
import SwiftUI

struct ToggleCardView: View {
    let hintText: String
    let bgColor: Color
    let iconName: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 26))
                .foregroundColor(.white)
                .frame(width: 54, height: 54)
                .background(Color.white.opacity(0.18))
                .cornerRadius(10)
                .padding(.leading, 16)

            Text(hintText)
                .font(.headline)
                .foregroundColor(.white.opacity(0.95))
                .padding(.vertical, 12)

            Spacer()

            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .white))
                .labelsHidden()
                .padding(.trailing, 16)
        }
        .background(bgColor)
        .cornerRadius(14)
        .shadow(color: bgColor.opacity(0.25), radius: 6, y: 3)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}
