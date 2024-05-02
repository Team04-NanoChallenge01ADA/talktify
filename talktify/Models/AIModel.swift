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

enum AILanguageEnum: String, Codable {
    case indonesian = "Bahasa Indonesia"
    case english = "Bahasa Inggris"
    case mandarin = "Bahasa Mandarin"
}

enum Voices: String, Codable {
    case male_calm = "IKne3meq5aSn9XLyUdCD" // Charlie
    case male_cheerful = "zcAOhNBS3c14rBihAFp1" // Giovanni
    case male_energetic = "D38z5RcWu1voky8WS1ja" // Fin
    case female_calm = "LcfcDJNUP1GQjkzn1xUU" // Emily
    case female_cheerful = "XrExE9yKIg1WjnnlVkGX" // Matilda
    case female_energetic = "jsCqWAovK2LkecY7zXl4" // Freya
    //case english = "XB0fDUnXU5powFXDhCwa"
}

enum VoiceModel: String, Codable {
    case english = "eleven_turbo_v2" // ENG
    case other = "eleven_multilingual_v2" // Other
}


class AIModel: Encodable{
    var gender: AIGenderEnum?
    var personality : AIPersonalityEnum?
    var interest : AIInterestEnum?
    var language : AILanguageEnum?
    var voice : Voices?
    var voiceModel : VoiceModel?
    
    static private var shared: AIModel?
    
    static func sharedInstance() -> AIModel {
        if shared == nil {
            shared = AIModel()
        }
        return shared!
    }
    
    func voicesChange()->String{
        if(gender == AIGenderEnum.male){
            if(personality == AIPersonalityEnum.calm){voice = Voices.male_calm}
            else if(personality == AIPersonalityEnum.cheerful){voice = Voices.male_cheerful}
            else if(personality == AIPersonalityEnum.energetic){voice = Voices.male_energetic}
        }else if(gender == AIGenderEnum.female){
            if(personality == AIPersonalityEnum.calm){voice = Voices.female_calm}
            else if(personality == AIPersonalityEnum.cheerful){voice = Voices.female_cheerful}
            else if(personality == AIPersonalityEnum.energetic){voice = Voices.female_energetic}
        }
        if(voice == nil){return Voices.female_cheerful.rawValue}

        if(language == AILanguageEnum.english){}
        let voiceID = voice!.rawValue
        return voiceID
    }
    
    func initialPrompt()->String{
        if((language == nil) || (gender == nil) || (personality == nil) || (interest == nil)){return ""}

//        let prompt = "Bayangkan kamu adalah seorang \(gender!.rawValue), kamu berbicara bahasa \(language!.rawValue), kamu memiliki sifat \(personality!.rawValue) dan hobi mu seputar \(interest!.rawValue). Saat ini kamu akan memperkenalkan diri kepada seseorang. Cobalah untuk berbicara santai dan seperti teman, dan perkenalkanlah namamu serta tanya kembali nama lawan bicaramu. Cobalah untuk menjawab dengan singkat 10 kata";
        
        let prompt = "Kamu adalah seorang manusia dengan jenia kelamin \(gender!.rawValue), kamu berbicara dalam \(language!.rawValue). Kamu memiliki sifat \(personality!.rawValue) dan hobi mu seputar \(interest!.rawValue). Sekarang, kamu akan memperkenalkan diri kamu kepada seorang teman. Perkenalkan diri kamu dengan singkat sebanyak 10 kata.  Berbicaralah seperti sedang menelepon teman dengan gaya bicara yang santai. Pertama-tama perkenalkan dirimu terlebih dahulu dan tanyakan balik nama dari lawan bicaramu."
        
        return prompt
//        let jsonData = try JSONEncoder().encode(self)
//        guard let jsonString = String(data: jsonData, encoding: .utf8) else{
//            throw NSError(domain: "Encoding Error", code:0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert data to string"])
//        }
//        return jsonString;
//        return prompt
    }
}
