//
//  SoundWaveComponent.swift
//  talktify
//
//  Created by Dason Tiovino on 02/05/24.
//

import Foundation
import SwiftUI
import AVFoundation

struct SoundWaveComponent: View {
    @State var audioRecorder: AVAudioRecorder?
    @State private var soundWaveHeights: [CGFloat] = Array(repeating: 30, count: 6)
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<6, id: \.self) { index in
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 10, height: self.soundWaveHeights[index])
                    .cornerRadius(40)
            }
        }.onAppear(){
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
                try audioSession.setActive(true)
                
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatLinearPCM),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
                ]
                
                let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder?.isMeteringEnabled = true
                audioRecorder?.prepareToRecord()
                audioRecorder?.record()
                
            } catch {
                // Handle error
                print("Error: \(error)")
            }
            
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ timer in
                updateSoundWaveHeights()
            }
        }
    }
    
    func updateSoundWaveHeights() {
        audioRecorder?.updateMeters()
        for index in 0..<6 {
            let normalizedValue = CGFloat(pow(6, (audioRecorder?.averagePower(forChannel: 0) ?? 0) / 20))
            soundWaveHeights[index] = normalizedValue * 200
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
}

struct SoundWaveComponent_Previews: PreviewProvider {
    static var previews: some View {
        SoundWaveComponent()
    }
}
