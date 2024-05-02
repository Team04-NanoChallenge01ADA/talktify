//
//  TextToSpeechUtils.swift
//  talktify
//
//  Created by Dason Tiovino on 30/04/24.
//

import Foundation
import AVFoundation
import SwiftUI


class TextToSpeechUtils : NSObject, AVAudioPlayerDelegate{
    var audioPlayer: AVAudioPlayer?
    var speakCompletion: (()->Void)?
    var speakBegin: (()->Void)?
    
    init(begin:(()->Void)? = nil,completion: (() -> Void)? = nil) {
        self.speakCompletion = completion
        self.speakBegin = begin
    }

    func send(voiceId: String = AIModel.sharedInstance().voicesChange(), text: String){
        speakBegin?()
        
        print("VOICE KEY = \(voiceId)")
        guard let url = URL(string: "\(TTS_BASE_URL)\(voiceId)") else {
            print("Invalid URL")
            return
        }
        
        var model = "eleven_multilingual_v2"
        if(AIModel.sharedInstance().language!.rawValue == "Bahasa Inggris"){model = "eleven_turbo_v2"}
        
        var request = URLRequest(url: url)
        let parameters = [
            "model_id": model, // Any Language
            "text": text
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print("Error serializing JSON:", error)
            return
        }
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(TTS_API_KEY, forHTTPHeaderField: "xi-api-key")
        print(model)
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else {return}
            
            if let error = error {
                print("Error:", error)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            print("Talk")
            self.playAudio(data: data)
        }
        task.resume()
    }

    func playAudio(data: Data) {
        do {
            print("Audio Talk")
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Test")
        } catch {
            print("Failed to play audio:", error.localizedDescription)
            speakCompletion?()
        }
    }

    // AVAudioPlayerDelegate method
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("Audio Finished")
        speakCompletion?()
    }
}
