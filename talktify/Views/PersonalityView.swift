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
        Spacer().frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
        VStack {
            Picker("Emotions?", selection: $selectedEmotions) {
                ForEach(0..<emotions.count, id: \.self) { index in
                    Text(emotions[index])
                        .tag(index)
                        
                    
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .scaledToFit()
            .scaleEffect(CGSize(width: 1.2, height: 1.2))
            .padding(20)
            
            
            LazyVGrid(columns: flexibleColumn, spacing: 20) {
                ForEach(interest.indices, id: \.self) { index in
                                
                    ZStack{
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 90, height: 50, alignment: .center)
                            .foregroundColor(selectedInterest == index ? Color(UIColor.systemBackground) : Color(UIColor.secondarySystemBackground))
                            .shadow(color: selectedInterest == index ? Color.black.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
                        
                        Text(String(interest[index]))
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .onTapGesture {
                                selectedInterest = index
                            }
                            
                    }
                
                }
            }
            Spacer()
            //Text("Emotions = \(selectedEmotions) \n Interest = \(selectedInterest)")
            Button(action: {

            }) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 40).bold())
                    .frame(width: 275, height: 70)
                    .foregroundColor(.white)
                    .background(Color(red: 0.2, green: 0.78, blue: 0.35))
                    .cornerRadius(45)
            }.padding(.bottom)

            

        }.padding(.horizontal, 50)
    }
    

}

#Preview {
    PersonalityView()
}
