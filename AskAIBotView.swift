import SwiftUI

struct AskAIBotView: View {
    var bill: Bill?
    @State private var userInput: String = ""
    @State private var chatHistory: [ChatMessage] = [
        ChatMessage(text: "Hi! I’m your Civic AI. Ask me anything about government, rights, or laws!", isUser: false)
    ]
    @FocusState private var isInputFocused: Bool
    @EnvironmentObject var navigationCoordinator: NavigationCoordinator
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollViewReader { scrollProxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(chatHistory.enumerated()), id: \.element.id) { idx, message in
                                let isSummary = (bill != nil && idx == chatHistory.firstIndex(where: { !$0.isUser && $0.text != "Hi! I’m your Civic AI. Ask me anything about government, rights, or laws!" }))
                                ChatBubble(message: message, isSummary: isSummary)
                                    .id(message.id)
                            }
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 12)
                    }
                    .background(Color(.systemGroupedBackground))
                    .onChange(of: chatHistory.count) { _ in
                        withAnimation {
                            scrollProxy.scrollTo(chatHistory.last?.id, anchor: .bottom)
                        }
                    }
                }
                Divider()
                HStack {
                    TextField("Type your question...", text: $userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isInputFocused)
                        .onSubmit(sendMessage)
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(ColorUtilities.patrioticBlue)
                    }
                    .disabled(userInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding()
            }
            .navigationTitle("Ask AI")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if let bill = bill {
                    let summaryPrompt = "Summarize this bill in simple terms: \(bill.title)"
                    chatHistory.append(ChatMessage(text: summaryPrompt, isUser: true))
                    // Automatically send the summary prompt to OpenAI
                    Task {
                        let aiResponse = await getAIResponse(prompt: summaryPrompt)
                        await MainActor.run {
                            chatHistory.append(ChatMessage(text: aiResponse, isUser: false))
                        }
                    }
                    navigationCoordinator.aiSummaryBill = nil // Reset after use
                }
            }
        }
    }
    
    private func sendMessage() {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        chatHistory.append(ChatMessage(text: trimmed, isUser: true))
        let prompt = trimmed
        userInput = ""
        // Call OpenAI API for response
        Task {
            let aiResponse = await getAIResponse(prompt: prompt)
            await MainActor.run {
                chatHistory.append(ChatMessage(text: aiResponse, isUser: false))
            }
        }
    }

    private func getAIResponse(prompt: String) async -> String {
        guard APIConfiguration.isOpenAIAPIKeyValid else {
            return "AI API key missing. Please add your OpenAI API key."
        }
        let url = URL(string: APIConfiguration.Endpoints.chatCompletions)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIConfiguration.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [["role": "user", "content": prompt]],
            "max_tokens": 256,
            "temperature": 0.7
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return "No HTTP response from OpenAI."
            }
            if httpResponse.statusCode != 200 {
                let errorBody = String(data: data, encoding: .utf8) ?? "<no error body>"
                return "OpenAI error: Status \(httpResponse.statusCode)\n\(errorBody)"
            }
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                return content.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                return "AI response could not be parsed."
            }
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}

struct ChatMessage: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct ChatBubble: View {
    let message: ChatMessage
    let isSummary: Bool
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            Text(message.text)
                .font(isSummary ? .title3.weight(.medium) : .body)
                .padding(isSummary ? 18 : 12)
                .background(message.isUser ? ColorUtilities.patrioticBlue.opacity(0.9) : Color(.systemGray5))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(isSummary ? 24 : 18)
                .frame(maxWidth: isSummary ? .infinity : 260, alignment: message.isUser ? .trailing : .leading)
            if !message.isUser { Spacer() }
        }
        .padding(message.isUser ? .leading : .trailing, isSummary ? 10 : 40)
        .padding(.horizontal, isSummary ? 0 : 2)
    }
}

// Preview
struct AskAIBotView_Previews: PreviewProvider {
    static var previews: some View {
        AskAIBotView()
    }
} 