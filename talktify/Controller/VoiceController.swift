//
//  VoiceController.swift
//  talktify
//
//  Created by Dason Tiovino on 29/04/24.
//
import Foundation
import AVFAudio
import SwiftUI

struct VoiceController {
    let apiKey: String = "485df26dc9fb10b96844f77b1eba720b"
    let baseURL: String = "https://api.elevenlabs.io/v1/text-to-speech/"
    @Binding var audioPlayer: AVAudioPlayer?
    
    func speechToText(voiceId: String = "XB0fDUnXU5powFXDhCwa", text: String) {
        guard let url = URL(string: "\(baseURL)\(voiceId)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        let parameters = [
            "model_id": "eleven_multilingual_v2",
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
        request.setValue(apiKey, forHTTPHeaderField: "xi-api-key")

        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            print("Masuk")
            
            if let error = error {
                print("Error:", error)
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            print(response)
            print("Talk..")
            playAudio(data: data)
        }
        task.resume()
    }

    func playAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to play audio:", error.localizedDescription)
        }
    }
}
