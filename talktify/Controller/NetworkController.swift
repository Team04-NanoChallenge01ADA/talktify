//
//  NetworkController.swift
//  talktify
//
//  Created by Dason Tiovino on 29/04/24.
//

import Foundation



struct NetworkController{
    let baseURL:String = "https://api.elevenlabs.io/v1/text-to-speech/"
    func fetchAudioFromAPI(voice_id: String){
        let urlString = "XB0fDUnXU5powFXDhCwa"
        let parameters = [
            "model_id": "eleven_multilingual_v2",
            "text": "indonesia banget ga sih"
        ]
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("485df26dc9fb10b96844f77b1eba720b", forHTTPHeaderField: "xi-api-key")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            print("Body")
        } catch let error {
            print("Error serializing JSON:", error)
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            print("Data Task")
            if let error = error {
                print("Error:", error)
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }

            playAudio(data: data)
        }
        task.resume()
    }
}
