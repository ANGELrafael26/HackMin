//
//  CustomButton.swift
//  hackaton2026
//
//  Created by Naolop on 29/03/26.
//

import SwiftUI

// MARK: - CustomButton Case

enum CustomButtonStyle {
    case standard(fontColor: Color, backgroundColor: Color, buttonName: String, fontName: String, fontSize: CGFloat, width: CGFloat, height: CGFloat)
    case imageWithText(imageName: String, text: String, fontColor: Color, fontName: String, fontSize: CGFloat, width: CGFloat, height: CGFloat)
    case imageWithTextH(imageName: String, text: String, fontColor: Color, fontName: String, fontSize: CGFloat, width: CGFloat, height: CGFloat)
    case image(imageName: String, width: CGFloat, height: CGFloat)
    case viewStruct(view: AnyView, width: CGFloat, height: CGFloat)
    case smallImage(imageName: String, width: CGFloat, height: CGFloat)
    case textOnly(text: String, fontColor: Color, fontName: String, fontSize: CGFloat)
}

struct CustomButton: View {
    let action: () -> Void
    let style: CustomButtonStyle
    
    var body: some View {
        switch style {
// MARK: - CustomButton Standar
            
        case .standard(let fontColor, let backgroundColor, let buttonName, let fontName, let fontSize, let width, let height):
            Button(action: action) {
                Text(buttonName)
                    .font(.custom(fontName, size: fontSize))
                    .foregroundStyle(fontColor)
                    .frame(maxWidth: .infinity)
            }
            .frame(width: width, height: height)
            .background(backgroundColor, in: .rect(cornerRadius: 20))
            .padding(.horizontal)
            
// MARK: - CustomButton Imagen with text
        case .imageWithText(let imageName, let text, let fontColor, let fontName, let fontSize, let width, let height):
            Button(action: action) {
                VStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                    Text(text)
                        .font(.custom(fontName, size: fontSize))
                        .foregroundStyle(fontColor)
                }
                .cornerRadius(8)
            }
            
            
// MARK: - CustomButton Imagen with text
        case .imageWithTextH(let imageName, let text, let fontColor, let fontName, let fontSize, let width, let height):
            Button(action: action) {
                HStack {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                         Text(text)
                        .font(.custom(fontName, size: fontSize))
                        .foregroundStyle(fontColor)
                    }
                .cornerRadius(8)
            }
// MARK: - CustomButton Image
        case .image(let imageName, let width, let height):
            Button(action: action) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
                    .cornerRadius(8)
            }
            
        case .viewStruct(let view, let width, let height):
            Button(action: action) {
                view
            }
            .frame(width: width, height: height)
            
        case .smallImage(let imageName, let width, let height):
            Button(action: action) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: width, height: height)
            }
// MARK: - CustomButton Text
        case .textOnly(let text, let fontColor, let fontName, let fontSize):
            Button(action: action) {
                Text(text)
                    .font(.custom(fontName, size: fontSize))
                    .foregroundStyle(fontColor)
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 30) {
            // 1. Standard
            CustomButton(action: { print("Standard") },
                         style: .standard(fontColor: .white,
                                          backgroundColor: .blue,
                                          buttonName: "Botón estándar",
                                          fontName: "Helvetica Neue",
                                          fontSize: 16,
                                          width: 150,
                                          height: 44))

            // 2. Image with text
            CustomButton(action: { print("Imagen + texto") },
                         style: .imageWithText(imageName: "star.fill",
                                               text: "Favorito",
                                               fontColor: .yellow,
                                               
                                               fontName: "Helvetica Neue",
                                               fontSize: 14,
                                               width: 24,
                                               height: 24))

            // 3. Image only
            CustomButton(action: { print("Solo imagen") },
                         style: .image(imageName: "heart.fill",
                                       width: 40,
                                       height: 40))

            // 4. ViewStruct (ejemplo con un círculo)
            CustomButton(action: { print("View personalizada") },
                         style: .viewStruct(view: AnyView(
                            Circle()
                                .fill(Color.purple)
                                .frame(width: 50, height: 50)
                                .overlay(Text("👍"))
                         ),
                         width: 60,
                         height: 60))

            // 5. SmallImage
            CustomButton(action: { print("Imagen pequeña") },
                         style: .smallImage(imageName: "info.circle",
                                            width: 20,
                                            height: 20))

            // 6. TextOnly
            CustomButton(action: { print("Solo texto") },
                         style: .textOnly(text: "Olvidé mi contraseña",
                                          fontColor: .gray,
                                          fontName: "Helvetica Neue",
                                          fontSize: 14))
        }
        .padding()
    }
}

