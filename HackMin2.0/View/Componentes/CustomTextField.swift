//
//  CustomTextField.swift
//  hackaton2026
//
//  Created by Naolop on 29/03/26.
//
import SwiftUI

// MARK: - CustomTextfiled Cases and variables
struct CustomTextField: View {
    enum FieldType {
        case normal
        case secure
        case textEditor
    }
    
    let placeholder: String
    @Binding var text: String
    let type: FieldType
    var backgroundColor: Color
    var foregroundColor: Color
    var tittleColor: Color
    var cornerRadius: CGFloat
    var height: CGFloat
    var width: CGFloat
    
    var minHeight: CGFloat = 40
    var maxHeight: CGFloat = 200
    
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    @State private var textEditorHeight: CGFloat = 40
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                switch type {
                    
// MARK: - CustomTextfiled Basic
                case .normal:
                    TextField(placeholder, text: $text)
// MARK: - CustomTextfiled Security
                case .secure:
                    HStack {
                        if isPasswordVisible {
                            TextField(placeholder, text: $text)
                        } else {
                            SecureField(placeholder, text: $text)
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
// MARK: - CustomTextfiled Editor
                case .textEditor:
                    ZStack(alignment: .topLeading) {
                        
                        Text(text)
                            .font(.headline)
                            .foregroundColor(.clear)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear
                                        .onAppear {
                                            updateTextHeight(geometry.size.height)
                                        }
                                        .onChange(of: text) { oldValue, newValue in
                                            updateTextHeight(geometry.size.height)
                                        }
                                }
                            )
                            .frame(height: min(max(textEditorHeight, minHeight), maxHeight))
                            .opacity(0)
                        

                        TextEditor(text: $text)
                            .focused($isFocused)
                            .scrollContentBackground(.hidden)
                            .font(.headline)
                            .foregroundColor(foregroundColor)
                            .frame(height: min(max(textEditorHeight, minHeight), maxHeight))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 4)
                        

                        if text.isEmpty && !isFocused {
                            Text(placeholder)
                                .font(.headline)
                                .foregroundColor(foregroundColor.opacity(0.5))
                                .padding(.top, 12)
                                .padding(.leading, 8)
                                .allowsHitTesting(false)
                        }
                    }
                }
            }
            .textFieldStyle(.plain)
            .padding()
            .frame(width: width, height: type == .textEditor ? nil : height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .font(.headline)
            .foregroundColor(foregroundColor)
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: textEditorHeight)
    }
    
    private func updateTextHeight(_ height: CGFloat) {
        let newHeight = height + 16
        if newHeight != textEditorHeight {
            textEditorHeight = newHeight
        }
    }
}

//#Preview {
//    VStack(spacing: 30) {
//        Text("Prueba de TextEditor Autoexpansible")
//            .font(.title2)
//            .bold()
//            .multilineTextAlignment(.center)
//        
//        // 1. TextEditor vacío (placeholder visible)
//        VStack(alignment: .leading) {
//            Text("1. TextEditor vacío:")
//                .font(.headline)
//                .foregroundColor(.blue)
//            
//            CustomTextField(
//                placeholder: "Escribe tu mensaje aquí...",
//                text: .constant(""),
//                type: .textEditor,
//                backgroundColor: .white,
//                foregroundColor: .black,
//                tittleColor: .black,
//                cornerRadius: 12,
//                height: 40,
//                width: 350,
//                minHeight: 60,
//                maxHeight: 300
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Color.blue.opacity(0.3), lineWidth: 2)
//            )
//        }
//        
//        // 2. TextEditor con texto corto
//        VStack(alignment: .leading) {
//            Text("2. Texto corto (1 línea):")
//                .font(.headline)
//                .foregroundColor(.green)
//            
//            CustomTextField(
//                placeholder: "Escribe tu mensaje aquí...",
//                text: .constant("Hola, este es un texto corto"),
//                type: .textEditor,
//                backgroundColor: .green.opacity(0.1),
//                foregroundColor: .black,
//                tittleColor: .black,
//                cornerRadius: 12,
//                height: 40,
//                width: 350,
//                minHeight: 60,
//                maxHeight: 300
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Color.green.opacity(0.3), lineWidth: 2)
//            )
//        }
//        
//        // 3. TextEditor con texto medio
//        VStack(alignment: .leading) {
//            Text("3. Texto medio (3 líneas):")
//                .font(.headline)
//                .foregroundColor(.orange)
//            
//            CustomTextField(
//                placeholder: "Escribe tu mensaje aquí...",
//                text: .constant("Este es un texto más largo que debería ocupar varias líneas. Aquí estamos probando cómo se expande el TextEditor automáticamente."),
//                type: .textEditor,
//                backgroundColor: .orange.opacity(0.1),
//                foregroundColor: .black,
//                tittleColor: .black,
//                cornerRadius: 12,
//                height: 40,
//                width: 350,
//                minHeight: 60,
//                maxHeight: 300
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Color.orange.opacity(0.3), lineWidth: 2)
//            )
//        }
//        
//        // 4. TextEditor con texto MUY largo
//        VStack(alignment: .leading) {
//            Text("4. Texto muy largo (máxima expansión):")
//                .font(.headline)
//                .foregroundColor(.red)
//            
//            CustomTextField(
//                placeholder: "Escribe tu mensaje aquí...",
//                text: .constant("""
//                Este es un texto extremadamente largo diseñado para probar los límites del TextEditor autoexpansible. 
//                
//                Vamos a escribir varias líneas de contenido para ver cómo el componente se adapta automáticamente a la cantidad de texto.
//                
//                Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
//                
//                Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
//                """),
//                type: .textEditor,
//                backgroundColor: .red.opacity(0.1),
//                foregroundColor: .black,
//                tittleColor: .black,
//                cornerRadius: 12,
//                height: 80,
//                width: 350,
//                minHeight: 100,
//                maxHeight: 300
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Color.red.opacity(0.3), lineWidth: 2)
//            )
//        }
//        
//        // 5. Contador para ver el crecimiento en tiempo real
//        VStack(alignment: .leading) {
//            Text("5. Prueba interactiva:")
//                .font(.headline)
//                .foregroundColor(.purple)
//            
//            Text("Escribe abajo y observa cómo crece:")
//                .font(.caption)
//                .foregroundColor(.gray)
//            
//            CustomTextField(
//                placeholder: "Escribe aquí para probar en tiempo real...",
//                text: .constant(""),
//                type: .textEditor,
//                backgroundColor: .purple.opacity(0.1),
//                foregroundColor: .black,
//                tittleColor: .black,
//                cornerRadius: 12,
//                height: 40,
//                width: 350,
//                minHeight: 80,
//                maxHeight: 250
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(Color.purple.opacity(0.3), lineWidth: 2)
//            )
//        }
//        
//        Spacer()
//        
//        Text("💡 Observa cómo cada TextEditor se adapta a su contenido")
//            .font(.caption)
//            .foregroundColor(.gray)
//            .multilineTextAlignment(.center)
//            .padding()
//    }
//    .padding()
//    .background(Color.gray.opacity(0.05))
//}
//
