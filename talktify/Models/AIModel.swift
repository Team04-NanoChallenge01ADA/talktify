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


class AIModel: Encodable{
    var gender: AIGenderEnum?
    var personality : AIPersonalityEnum?
    var interest : AIInterestEnum?
    
    static private var shared: AIModel?
    
    static func sharedInstance() -> AIModel {
        if shared == nil {
            shared = AIModel()
        }
        return shared!
    }
    
    func initialPrompt()->String{
        if((gender == nil) || (personality == nil) || (interest == nil)){return ""}
        
        let prompt = "Bayangkan kamu adalah seorang \(gender!.rawValue), kamu memiliki sifat \(personality!.rawValue) dan hobi mu seputar \(interest!.rawValue). Saat ini kamu akan memperkenalkan diri kepada seseorang. Cobalah untuk berbicara seperti teman, dan perkenalkanlah namamu serta tanya kembali nama lawan bicaramu.";
        
        return prompt
//        let jsonData = try JSONEncoder().encode(self)
//        guard let jsonString = String(data: jsonData, encoding: .utf8) else{
//            throw NSError(domain: "Encoding Error", code:0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to string"])
//        }
//        return jsonString;
//        return prompt
    }
}
