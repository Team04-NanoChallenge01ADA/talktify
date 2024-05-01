//
//  CallView.swift
//  talktify
//
//  Created by Dason Tiovino on 29/04/24.
//

import Foundation
import SwiftUI
import UIKit
import AVFAudio

struct CallView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var callTimer: Int = 0
    @State private var isMicrophoneMuted: Bool = false;
    @State private var isLoudSpeaker: Bool = true;

    @State private var isLoading: Bool = false;
    @State private var audioPlayer: AVAudioPlayer?

    @State private var previousRecognizedText: String = ""
    @ObservedObject private var speechRecognition = SpeechRecognition()
    @ObservedObject private var apiController: OpenAICaller = OpenAICaller()
    
    @State var ttsUtils: TextToSpeechUtils?
    
    @State private var player: AVAudioPlayer!

    
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
                            if(!isLoading && isMicrophoneMuted){
                                isMicrophoneMuted.toggle()
                                speechRecognition.start()
                            }
                            else if(!isLoading && !isMicrophoneMuted){
                                isMicrophoneMuted.toggle()
                                speechRecognition.stop()
                            }
                        },
                        isActive: isMicrophoneMuted,
                        activeIcon: "mic.slash.fill",
                        inActiveIcon: "mic.slash.fill",
                        activeBackground: .white,
                        inactiveBackground: .black.opacity(0.3))
                    
                    
                    CallButtonComponent(
                        action: {
//                            ttsUtils!.send(
//                                text: "Indonesia banget ga sih"
//                            )
                            self.playEndCallEffect()
                            
                            endCallVibrate()
                            audioPlayer?.stop()
                            self.presentationMode.wrappedValue.dismiss()
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
                isMicrophoneMuted = true
                speechRecognition.stop()

                self.playAnswerEffect()
                ttsUtils = TextToSpeechUtils(begin: {
                    isMicrophoneMuted = true
                    speechRecognition.stop()
                    isLoading = true
                },completion: {
                    isMicrophoneMuted = false
                    speechRecognition.start()
                    isLoading = false
                })
                
                apiController.send(text: AIModel.sharedInstance().initialPrompt()) { response in
                    DispatchQueue.main.async {
                        ttsUtils!.send(text: response)
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
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true){time in
            // Validating someone is stop talking
            if speechRecognition.recognizedText == previousRecognizedText && !isLoading && speechRecognition.recognizedText != "" {
                
                // API Controller
                apiController.send(text: speechRecognition.recognizedText!){ response in
                    DispatchQueue.main.async {
                        ttsUtils!.send(text: response)
                        speechRecognition.recognizedText = ""
                        previousRecognizedText = ""
                    }
                }
            }
            previousRecognizedText = speechRecognition.recognizedText ?? ""
        }
    }
    
    
    func endCallVibrate(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
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
    
    func playAnswerEffect(){
        let url = Bundle.main.url(forResource: "facetimeAnswer", withExtension: "mp3")
        
        guard url != nil else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player.play()
        } catch {
            print("Can't play sound effect")
        }
    }
    
    func playEndCallEffect(){
        let url = Bundle.main.url(forResource: "facetimeHangUp", withExtension: "mp3")
        
        guard url != nil else {
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            player.play()
        } catch {
            print("Can't play sound effect")
        }
    }
}


#Preview {
    CallView()
}
