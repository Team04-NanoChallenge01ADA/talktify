import SwiftUI

final class ViewModel: ObservableObject {
    private let apiKey: String
    private let baseURL = URL(string: "https://api.openai.com/v1/")!
    static var historyMessage: Array<[String:String]> = []
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func send(text: String, messages: [String]?, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "chat/completions", relativeTo: baseURL) else {
            print("Invalid URL")
            return
        }
        
        var prompt = ViewModel.historyMessage
        prompt.append([
            "role":"user",
            "content": text
        ])
        
        print(prompt)
        
        let requestData: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": prompt,
            "max_tokens": 500
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        guard let httpBody = try? JSONSerialization.data(withJSONObject: requestData) else {
            print("Failed to serialize JSON")
            return
        }
        
        request.httpBody = httpBody
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let decodedResponse = try? JSONDecoder().decode(CompletionResponse.self, from: data) {
                print(data)
                ViewModel.historyMessage.append([
                    "role": "assistant",
                    "content": decodedResponse.choices.first?.message.content ?? "",
                ])
                
                completion(decodedResponse.choices.first?.message.content ?? "")
            } else {
                let responseString = String(data: data, encoding: .utf8) ?? "Unable to decode response data"
                print("Response: \(responseString)")
            }
        }.resume()
    }

}

struct CompletionResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let index: Int
    let message: ChoiceMessage
    let logprobs: String?
    let finishReason: String?
}

struct ChoiceMessage: Decodable {
    let role: String
    let content: String
}

struct OpenAICaller: View {
    @ObservedObject var viewModel: ViewModel
    @State var text = ""
    @State var models = [String]()
    
    init() {
//        let apiKey = "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"
        let apiKey = "sk-proj-veQX3jLtw6iZ4muej129T3BlbkFJK3dDhr957FvJW7GueL5O" 
//        let apiKey = "sk-proj-HTqDSyks1ta9ePIPCKe3T3BlbkFJJouJqtk2US4zUs9IyJyh"
        self.viewModel = ViewModel(apiKey: apiKey)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(models, id: \.self) { string in
                Text(string)
            }
            Spacer()
            
            HStack {
                TextField("Type", text: $text)
                Button("Send") {
                    send()
                }
            }
        }
        .padding()
    }
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        models.append("Me: \(text)")
        
        viewModel.send(text: text, messages: self.models) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT: \(response)")
                self.text = ""
            }
        }
    }
}

#Preview {
    OpenAICaller()
}
