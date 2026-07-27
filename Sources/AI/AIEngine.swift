import Foundation

public class AIEngine: ObservableObject {
    @Published public var apiKey: String = ""
    @Published public var isLoading: Bool = false
    
    public init() {}
    
    public func explainError(_ errorLog: String) async -> String {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return "Invalid URL"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "You are a terminal debugging assistant."],
                ["role": "user", "content": "Explain this error: \(errorLog)"]
            ]
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                return content
            }
            return "Failed to parse AI response."
        } catch {
            return "API Error: \(error.localizedDescription)"
        }
    }
}
