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

    @State private var isProcessing: Bool = false;
    @State private var audioPlayer: AVAudioPlayer?


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
                            VoiceController(audioPlayer: $audioPlayer).speechToText(text: "Indonesia banget ga sih")
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
        }.background(.blue400)
            .onAppear(){
//                speechRecognition.start()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true){time in
                    callTimer += 1
                }
                
                Timer.scheduledTimer(withTimeInterval: 2, repeats: true){time in
//                    print(speechRecognition.recognizedText ?? "-")
                    if speechRecognition.recognizedText == previousRecognizedText && !isProcessing {
                       
                    }
                    
                    previousRecognizedText = speechRecognition.recognizedText ?? ""
                }
            }
    }
}


#Preview {
    CallView()
}
