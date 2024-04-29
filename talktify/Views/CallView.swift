//
//  CallView.swift
//  talktify
//
//  Created by Dason Tiovino on 29/04/24.
//

import Foundation
import SwiftUI

struct CallView: View {
    @State private var callTimer: Int = 0
    @State private var isMicrophoneMuted: Bool = false;
    @State private var isSpeakerMuted: Bool = false;
    
    var body: some View {
        GeometryReader{geometry in
            ZStack{
                VStack{
                    Text("\(String(format:"%02D", callTimer/60%60)) : \(String(format:"%02D", callTimer%60))")
                    ZStack{
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: 175, height: 175)
                            
                        Text("👨️")
                            .font(.system(size: 100))
                    }
                }
                HStack{
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
                        action: {},
                        isActive: true,
                        activeIcon: "phone.down.fill",
                        inActiveIcon: "",
                        activeBackground: .white,
                        inactiveBackground: .white)
                    
                    CallButtonComponent(
                        action: {
                            isSpeakerMuted.toggle()
                        },
                        isActive: isSpeakerMuted,
                        activeIcon: "speaker.wave.3.fill",
                        inActiveIcon: "speaker.slash.fill",
                        activeBackground: .white,
                        inactiveBackground: .black.opacity(0.3))
                    
                }.offset(CGSize(width: 0, height: geometry.size
                    .height/2 - 100))
                
            }.frame(
                width: geometry.size.width,
                height: geometry.size.height)
        }.background(.blue400)
            .onAppear(){
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true){time in
                    callTimer += 1
                }
            }
    }
}

#Preview {
    CallView()
}
