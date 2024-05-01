import SwiftUI

struct PersonalityView: View {
    @State private var isCall: Bool = false
    
    @State private var selectedEmotions: Int = 1
    @State private var selectedInterest: Int = 0
    @State private var selectedLanguage: Int = 1
    var emotions = ["☺️", "😄", "🤣"]
    var languages = ["🇺🇸", "🇮🇩", "🇨🇳"]
    
    var interest: Array<(String,value: String)> = [
        ("💬","Apa saja"),
        ("🎵","Musik"),
        ("🎬","Film"),
        ("🍽️","Makanan dan Kuliner"),
        ("🐾","Binatang"),
        ("🗺️","Travelling"),
        ("🎮","Game"),
        ("📸","Fotografi"),
        ("📚","Pendidikan"),
        ("💻","Teknologi"),
        ("🎨","Seni"),
        ("⚽️","Olahraga")
    ]
    private let flexibleColumn = [
        
        GridItem(.flexible(minimum: 50, maximum: 100)),
        GridItem(.flexible(minimum: 50, maximum: 100)),
        GridItem(.flexible(minimum: 50, maximum: 100))
    ]
       

    var body: some View {
        NavigationStack {
            Spacer().frame(height: 50)
            
            VStack {
                Picker("Languages?", selection: $selectedLanguage) {
                    ForEach(0..<languages.count, id: \.self) { language in
                        Text(languages[language])
                            .tag(language)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .scaleEffect(CGSize(width: 1.7, height: 1.7))
                .accentColor(Color(buttonColor()))
                
                Spacer().frame(height: 30)
                
                Picker("Emotions?", selection: $selectedEmotions) {
                    ForEach(0..<emotions.count, id: \.self) { index in
                        Text(emotions[index])
                            .tag(index)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .scaledToFit()
                .scaleEffect(CGSize(width: 1.2, height: 1.2))
                .padding(20)
                
                Spacer().frame(height: 30)
                
                LazyVGrid(columns: flexibleColumn, spacing: 20) {
                    ForEach(interest.indices, id: \.self) { index in
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 90, height: 50, alignment: .center)
                                .foregroundColor(selectedInterest == index ? Color(UIColor.systemBackground) : Color(UIColor.secondarySystemBackground))
                                .shadow(color: selectedInterest == index ? Color.black.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
                            
                            Text(String(interest[index].0))
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.17)){
                                        selectedInterest = index
                                    }
                                }
                            
                        }
                        
                    }
                }
                

                
                Spacer()
                //Text("Emotions = \(selectedEmotions) \n Interest = \(selectedInterest)")
                
                ZStack{
                    NavigationLink(destination: PersonalityView()){
                        EmptyView()
                    }.navigationDestination(isPresented: $isCall) {
                        CallView()
                    }
                    
                    Button(action: {
                        isCall.toggle()
                        switch(emotions[selectedEmotions]){
                            case "☺️": 
                            AIModel.sharedInstance().personality = AIPersonalityEnum.calm
                            break
                            case "😄":
                            AIModel.sharedInstance().personality = AIPersonalityEnum.cheerful
                            break
                            case "🤣":
                            AIModel.sharedInstance().personality = AIPersonalityEnum.energetic
                            break
                            default:
                                break
                        }
                       
                        AIModel.sharedInstance().interest = AIInterestEnum(rawValue: interest[selectedInterest].value)
                        
                        switch(languages[selectedLanguage]){
                            case "🇺🇸":
                            AIModel.sharedInstance().language = AILanguageEnum.english
                            break
                            case "🇮🇩":
                            AIModel.sharedInstance().language = AILanguageEnum.indonesian
                            break
                            case "🇨🇳":
                            AIModel.sharedInstance().language = AILanguageEnum.mandarin
                            break
                            default:
                                break
                        }
                        
                    }) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 40).bold())
                            .frame(width: 275, height: 70)
                            .foregroundColor(.white)
                            .background(buttonColor())
                            .cornerRadius(45)
                    }.padding(.bottom)
                    
                }
            }.padding(.horizontal, 50)
        }
    }
    
    func buttonColor() -> Color{
        if AIModel.sharedInstance().gender == AIGenderEnum.male {
            return Color.blue400
        } else {
            return Color.pink400
        }
    }
    
}

#Preview {
    PersonalityView()
}
