//
//  ContentView.swift
//  TextDetection
//
//  Created by Andy on 2024/8/30.
//

import SwiftUI
import UIKit
import Vision
import NaturalLanguage

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


struct ContentView: View {
    @State private var image: UIImage?
    @State private var recognizedText: String = "No text recognized"
    @State private var isShowingImagePicker = false

    @State private var paperName: String = ""
    @State private var questionNumber: Int = 0
    @State private var questionText: String = ""
    @State private var questionMs: String?
    @State private var numImage: String = "1"

    let embedding = NLEmbedding.sentenceEmbedding(for: .english)!
    
    var body: some View {
         VStack {
             if let image = image {
                 Image(uiImage: image)
                     .resizable()
                     .scaledToFit()
                     .frame(width: 300, height: 300)
             } else {
                 Image(systemName: "photo")
                     .resizable()
                     .scaledToFit()
                     .frame(width: 300, height: 300)
                     .foregroundColor(.gray)
             }
             if let questionMs = questionMs {
                 VStack {
                     ForEach(0...((Int(numImage) ?? 1) - 1), id: \.self) { index in
                         let imageName = "\(questionMs)_\(index)"
                         Image(imageName)
                             .resizable()
                             .scaledToFit()
                             .frame(width: 300, height: 300)
                     }
                 }
             } else {
                 Image(systemName: "photo")
                     .resizable()
                     .scaledToFit()
                     .frame(width: 300, height: 300)
                     .foregroundColor(.gray)
             }
             Text("Name: \(paperName)")
             Text("Number: \(questionNumber)")
             Text("Content: \(questionText)")
             Text("Markscheme: \(String(describing: questionMs))")
             Button("Take Photo") {
                 isShowingImagePicker = true
             }
             .padding()
         }
         .fullScreenCover(isPresented: $isShowingImagePicker, onDismiss: recognizeText) {
             ImagePicker(image: $image)
                 .edgesIgnoringSafeArea(.all)
         }
     }
    
    func getSimilarity(a: String, b: String) -> Double{
        let distance = embedding.distance(between: a, and: b)
        return distance
    }
    
    func searching(text: String) {
        
        if let examQuestions = parseExamQuestions() {
            var closestSim: Double = 2.0
            var closestPaper = ""
            var closestNum = 0
            var closestQText = ""
            var closestMS = ""
            var num = "1"
            for examQuestion in examQuestions {
                let paperName = examQuestion.paper
                let questions = examQuestion.questions
                let markScheme = examQuestion.ms
                let numImage = examQuestion.n
                
                for (questionNumber, questionText) in questions {
                    let distance = embedding.distance(between: text, and: questionText)
                    
                    if distance < closestSim {
                        closestSim = distance
                        closestPaper = paperName
                        closestNum = Int(questionNumber) ?? 0
                        closestQText = questionText
                        closestMS = markScheme[questionNumber] ?? "No mark scheme available"
                        num = numImage[questionNumber] ?? "1"
                    }
                }
            }
            
            print(closestPaper)
            print(closestNum)
            print(closestQText)
            print(closestMS)
            
            self.paperName = closestPaper
            self.questionNumber = closestNum
            self.questionText = closestQText
            self.questionMs = closestMS
            self.numImage = num
        } else {
            self.paperName = ""
            self.questionNumber = 0
            self.questionText = "No match found"
            self.questionMs = "No mark scheme available"
            self.numImage = "1"
        }
    }

    func recognizeText() {
        guard let image = image?.cgImage else { return }

        let requestHandler = VNImageRequestHandler(cgImage: image, options: [:])
        let request = VNRecognizeTextRequest { (request, error) in
            if let observations = request.results as? [VNRecognizedTextObservation] {
                let recognizedStrings = observations.compactMap { $0.topCandidates(1).first?.string }
                DispatchQueue.main.async {
                    recognizedText = recognizedStrings.joined(separator: "\n")
                    recognizedText = recognizedText.trimmingCharacters(in: CharacterSet.newlines)
                    searching(text: recognizedText)
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    recognizedText = "Error: \(error.localizedDescription)"
                }
            }
        }

        do {
            try requestHandler.perform([request])
        } catch {
            recognizedText = "Error: \(error.localizedDescription)"
        }
    }
}


#Preview {
    ContentView()
}
