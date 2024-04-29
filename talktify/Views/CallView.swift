//
//  CallView.swift
//  talktify
//
//  Created by Dason Tiovino on 29/04/24.
//

import Foundation
import SwiftUI
import AVFAudio

struct CallView: View {
    @State private var callTimer: Int = 0
    @State private var isMicrophoneMuted: Bool = false;
    @State private var isLoudSpeaker: Bool = true;
    @State private var audioPlayer: AVAudioPlayer?

    @State private var isProcessing: Bool = false;

    @State private var previousRecognizedText: String = ""
    @ObservedObject private var speechRecognition = SpeechRecognition()

    
    
    var body: some View {
        GeometryReader{geometry in
            ZStack{
                VStack{
                    Text("\(String(format:"%02D", callTimer/60%60)):\(String(format:"%02D", callTimer%60))")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    ZStack{
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: 250, height: 250)
                            
                        Text("👨️")
                            .font(.system(size: 150))
                    }
                }.offset(CGSize(width: 0, height: -100))
                
                Text(speechRecognition.recognizedText ?? "-").offset(CGSize(width: 0, height: 100))
                
                Text(previousRecognizedText == speechRecognition.recognizedText ? "SAME" : "NOT SAME").offset(CGSize(width: 0, height: 75))
                    
                
                HStack(spacing: 30){
                    CallButtonComponent(
                        action: {
                            isMicrophoneMuted.toggle()
                        },
                        isActive: isMicrophoneMuted,
                        activeIcon: "mic.fill",
                        inActiveIcon: "mic.slash.fill",
                        activeBackground: .white,
                        inactiveBackground: .black.opacity(0.3))
                    
                    CallButtonComponent(
                        action: {
                            fetchAudioFromAPI()
                        },
                        isActive: true,
                        activeIcon: "phone.down.fill",
                        inActiveIcon: "",
                        activeBackground: .white,
                        inactiveBackground: .white)
                    
                    CallButtonComponent(
                        action: {
                            isLoudSpeaker.toggle()
                        },
                        isActive: isLoudSpeaker,
                        activeIcon: "speaker.wave.3.fill",
                        inActiveIcon: "speaker.wave.3.fill",
                        activeBackground: .white,
                        inactiveBackground: .black.opacity(0.3))
                    
                }.offset(CGSize(width: 0, height: geometry.size
                    .height/2 - 75))
                
            }.frame(
                width: geometry.size.width,
                height: geometry.size.height)
        }.background(.primaryBlue)
            .onAppear(){
                speechRecognition.start()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true){time in
                    callTimer += 1
                }
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: true){time in
                    print(speechRecognition.recognizedText ?? "-")
                    if speechRecognition.recognizedText == previousRecognizedText && !isProcessing {
                       
                    }
                    
                    previousRecognizedText = speechRecognition.recognizedText ?? ""
                }
            }
    }
    
    func fetchAudioFromAPI(){
        isProcessing = true
        
        // API Endpoint
        let urlString = "https://api.elevenlabs.io/v1/text-to-speech/XB0fDUnXU5powFXDhCwa"
        
        // Request Body
        let parameters = [
            "model_id": "eleven_multilingual_v2",
            "text": "indonesia banget ga sih"
        ]
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        // Create URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set Headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("485df26dc9fb10b96844f77b1eba720b", forHTTPHeaderField: "xi-api-key")
        
        // Add Parameters
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("Error serializing JSON:", error)
            return
        }
        
        // Create URLSession
        let session = URLSession.shared
        
        // Create Data Task
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error:", error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // Convert Data to String
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response:", responseString)
            }
        }
        
        // Resume Task
        task.resume()
        
    }
    
    
    func playAudio(data: Data){
        do {
            self.audioPlayer = try AVAudioPlayer(data: data)
            self.audioPlayer?.prepareToPlay()
            self.audioPlayer?.play()
        } catch {
            print("Failed to play audio:", error.localizedDescription)
        }
    }
}


#Preview {
    CallView()
}
