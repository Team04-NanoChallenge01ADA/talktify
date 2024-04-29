//
//  PersonalityView.swift
//  talktify
//
//  Created by Ages on 29/04/24.
//

import SwiftUI

struct PersonalityView: View {
    @State private var selectedEmotions: Int = 0
    @State private var selectedInterest: Int = 0
    var emotions = ["☺️", "😊", "😄"]
    var interest = [
        "⚽️", "🎵", "🎬",
        "🍽️", "🐾", "🗺️",
        "🎮", "📸", "📚",
        "💻", "🎨", "💬"
    ]
    private let flexibleColumn = [
        
        GridItem(.flexible(minimum: 50, maximum: 100)),
        GridItem(.flexible(minimum: 50, maximum: 100)),
        GridItem(.flexible(minimum: 50, maximum: 100))
    ]
       

    var body: some View {
        VStack {
            Picker("Emotions?", selection: $selectedEmotions) {
                ForEach(0..<emotions.count, id: \.self) { index in
                    Text(emotions[index])
                        .tag(index)
                    
                }
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 50)
            .scaledToFill()
            
            LazyVGrid(columns: flexibleColumn, spacing: 20) {
                ForEach(interest.indices, id: \.self) { index in
                                
                    Text(String(interest[index]))
                        .frame(width: 80, height: 50, alignment: .center)
                        .background(selectedInterest == index ? Color.white : Color(UIColor.secondarySystemBackground))
                        .shadow(color: selectedInterest == index ? Color.black.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
                        .cornerRadius(50)
                        .font(.title)
                        .onTapGesture {
                            selectedInterest = index
                            
                        }
                }
            }
            Spacer()
            //Text("Emotions = \(selectedEmotions) \n Interest = \(selectedInterest)")
            Button(action: {
                
            }, label: {
                ZStack{
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 275, height: 70)
                      .background(Color(red: 0.2, green: 0.78, blue: 0.35))
                      .cornerRadius(40)
                    Image(systemName: "phone.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.white)
                }
                
                
            })

            

        }.padding(50)
    }
}

#Preview {
    PersonalityView()
}
