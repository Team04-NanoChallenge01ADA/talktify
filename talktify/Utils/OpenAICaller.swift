import SwiftUI
import OpenAISwift

final class ViewModel: ObservableObject{
    init(){}
    
    private var client: OpenAISwift?
    
    // func untuk setup API Key
    func setupOpenAI() { // Masukin key API
        let config: OpenAISwift.Config = .makeDefaultOpenAI(apiKey: "sk-proj-xdlBkI0t1fFv9qs9RKrpT3BlbkFJxXTcS5hxeTnltTW9WT8Y")
        client = OpenAISwift(config: config)
    }
    
    // func untuk send string ke model
    func send(text: String, completion: @escaping (String) -> Void){
        client?.sendCompletion(with: text, completionHandler:{ result in
            switch result{
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                //print(model)
                print(model.choices as Any)
                completion(output)
            case .failure:
                print("fail")
                break
            }
        })
    }
    
}

struct OpenAICaller: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack(alignment: .leading){
            ForEach(models, id: \.self){ string in
                Text(string)
            }
            Spacer()
            
            HStack{
                TextField("Type", text: $text)
                Button("Send"){
                    send()
                }
            }
        }
        .onAppear{
            viewModel.setupOpenAI()
        }
        .padding()
    }
    
    func send(){
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        
        models.append("Me: \(text)")
        
        //print("test")
        // Respon dari ChatGPT
        viewModel.send(text: text) { response in
            //print("response")
            DispatchQueue.main.async {
                self.models.append("ChatGPT: "+response)
                
                self.text = ""
            }
        }
    }
}

#Preview {
    OpenAICaller()
}
