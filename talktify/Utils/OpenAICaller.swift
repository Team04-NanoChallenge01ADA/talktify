import SwiftUI

final class ViewModel: ObservableObject {
    private let apiKey: String
    private let baseURL = URL(string: "https://api.openai.com/v1/")!
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "completions", relativeTo: baseURL) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo-instruct",
            "prompt": text,
            "max_tokens": 150
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters) else {
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
                completion(decodedResponse.choices.first?.text ?? "")
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
    let text: String
}

struct OpenAICaller: View {
    @ObservedObject var viewModel: ViewModel
    @State var text = ""
    @State var models = [String]()
    
    init() {
//        let apiKey = "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"
        let apiKey = "sk-proj-veQX3jLtw6iZ4muej129T3BlbkFJK3dDhr957FvJW7GueL5O"
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
        
        viewModel.send(text: text) { response in
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
