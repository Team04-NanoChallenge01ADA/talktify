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

    @State private var isLoading: Bool = false;
    @State private var audioPlayer: AVAudioPlayer?

    @State private var previousRecognizedText: String = ""
    @ObservedObject private var speechRecognition = SpeechRecognition()
    @ObservedObject private var apiController: OpenAICaller = OpenAICaller()
    
    @State var ttsUtils: TextToSpeechUtils?

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
                        
                        Text(AIModel.sharedInstance().gender == AIGenderEnum.male ? "👨️" : "👩")
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
                            ttsUtils!.send(
                                text: "Indonesia banget ga sih"
                            )
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
        }.background(backgroundColor())
            .onAppear(){
                ttsUtils = TextToSpeechUtils(){
                    speechRecognition.start()
                }
                
                apiController.send(text: AIModel.sharedInstance().initialPrompt()) { response in
                    DispatchQueue.main.async {
                        ttsUtils!.send(text: response){
                            speechRecognition.start()
                        }
                        isLoading = false
                    }
                }
                
                initializeTimer()
            }.navigationBarBackButtonHidden()
    }
    
    func initializeTimer() {
        // Stopwatch Interval
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){time in
            callTimer += 1
        }
        
        // API Call Interval
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true){time in
            // Validating someone is stop talking
            if speechRecognition.recognizedText == previousRecognizedText && !isLoading && speechRecognition.recognizedText != "" {
                isLoading = true
                speechRecognition.stop()
                
                // API Controller
                apiController.send(text: speechRecognition.recognizedText!){ response in
                    DispatchQueue.main.async {
                        ttsUtils!.send(text: response)
                        
                        speechRecognition.recognizedText = ""
                        previousRecognizedText = ""
                        
                        isLoading = false
                    }
                }
            }
            previousRecognizedText = speechRecognition.recognizedText ?? ""
        }
    }
    
    func backgroundColor() -> Color {
        if AIModel.sharedInstance().gender == AIGenderEnum.male {
            if AIModel.sharedInstance().personality == AIPersonalityEnum.calm {
                return Color.blue100
            } else if AIModel.sharedInstance().personality == AIPersonalityEnum.cheerful {
                return Color.blue300
            } else if AIModel.sharedInstance().personality == AIPersonalityEnum.energetic {
                return Color.blue400
            }
        } else {
            if AIModel.sharedInstance().personality == AIPersonalityEnum.calm {
                return Color.pink100
            } else if AIModel.sharedInstance().personality == AIPersonalityEnum.cheerful {
                return Color.pink300
            } else if AIModel.sharedInstance().personality == AIPersonalityEnum.energetic {
                return Color.pink400
            }
        }
        return Color.white
    }
}


#Preview {
    CallView()
}
