// DropdownCardView.swift
import SwiftUI

struct DropdownCardView: View {
    let hintText: String
    let bgColor: Color
    let iconName: String
    @Binding var selectedOption: Int
    let options: [String]

    var body: some View {
        HStack(spacing: 12) {
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

                // Use a Picker in menu style (works well with SwiftUI and avoids extra UIKit wrappers)
                Picker(selection: $selectedOption, label: HStack {
                    Text(options[selectedOption])
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white.opacity(0.7))
                }) {
                    ForEach(options.indices, id: \.self) { idx in
                        Text(options[idx]).tag(idx)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.vertical, 12)
            .padding(.trailing, 12)

            Spacer()
        }
        .background(bgColor)
        .cornerRadius(14)
        .shadow(color: bgColor.opacity(0.25), radius: 6, y: 3)
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
    }
}
