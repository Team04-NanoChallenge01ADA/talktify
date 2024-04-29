//
//  AIModel.swift
//  talktify
//
//  Created by Felix Laurent on 29/04/24.
//

import Foundation

enum AIGenderEnum: String, Codable {
    case male = "Laki-laki"
    case female = "Perempuan"
}

enum AIPersonalityEnum: String, Codable {
    case calm = "kalem"
    case cheerful = "periang"
    case energetic = "energetik"
}

enum AIInterestEnum: String, Codable {
    case general = "Apa saja"
    case sport = "Olahraga"
    case music = "Musik"
    case movie = "Film"
    case food = "Makanan dan Kuliner"
    case animal = "Binatang"
    case travel = "Travelling"
    case game = "Game"
    case photography = "Fotografi"
    case eduacation = "Pendidikan"
    case tech = "Teknologi"
    case art = "Seni"
}


struct AIModel: Encodable{
    let gender: AIGenderEnum
    let personality : AIPersonalityEnum
    let interest : AIInterestEnum
    
    func initialPrompt(){
        
//        var prompt = "\(gender.rawValue) \(personality.rawValue) \(interest.rawValue)";
        
//        let jsonData = try JSONEncoder().encode(self)
//        guard let jsonString = String(data: jsonData, encoding: .utf8) else{
//            throw NSError(domain: "Encoding Error", code:0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to string"])
//        }
//        return jsonString;
    }
}
