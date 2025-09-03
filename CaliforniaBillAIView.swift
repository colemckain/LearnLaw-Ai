import SwiftUI

struct CaliforniaBillAIView: View {
    let bill: CaliforniaBill
    @State private var selectedQuestion: String?
    @State private var aiResponse: String?
    @State private var isLoading = false
    @State private var chatHistory: [ChatMessage] = []
    @Environment(\.dismiss) private var dismiss
    
    // Generate contextual questions for the bill
    private var contextualQuestions: [String] {
        [
            "What is the main purpose of \(bill.billNumber) and how will it impact Californians?",
            "What are the key arguments for and against \(bill.billNumber)?",
            "How does \(bill.billNumber) compare to similar laws in other states?"
        ]
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if chatHistory.isEmpty {
                    // Show questions if no conversation has started
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Ask AI about \(bill.billNumber)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        Text("Choose a question to get started:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ForEach(contextualQuestions, id: \.self) { question in
                                Button(action: {
                                    selectedQuestion = question
                                    askQuestion(question)
                                }) {
                                    HStack {
                                        Text(question)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.leading)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                }
                                .disabled(isLoading)
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                } else {
                    // Show chat interface
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(Array(chatHistory.enumerated()), id: \.element.id) { idx, message in
                                    ChatBubble(message: message, isSummary: false)
                                        .id(message.id)
                                }
                                
                                if isLoading {
                                    HStack {
                                        Text("AI is thinking...")
                                            .font(.body)
                                            .padding(12)
                                            .background(Color(.systemGray5))
                                            .foregroundColor(.primary)
                                            .cornerRadius(18)
                                        Spacer()
                                    }
                                    .padding(.leading, 40)
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
                    
                    // Additional questions button
                    if !chatHistory.isEmpty && !isLoading {
                        Button(action: {
                            // Show questions again
                            chatHistory.removeAll()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                Text("Ask Another Question")
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Ask AI")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func askQuestion(_ question: String) {
        isLoading = true
        
        // Add user question to chat
        chatHistory.append(ChatMessage(text: question, isUser: true))
        
        // Create context-aware prompt
        let contextPrompt = """
        You are a legal AI assistant helping users understand California legislation. 
        
        Bill Information:
        - Bill Number: \(bill.billNumber)
        - Title: \(bill.title)
        - Author: \(bill.author)
        - Status: \(bill.status)
        - House: \(bill.house)
        - Description: \(bill.description ?? "No description available")
        
        User Question: \(question)
        
        Please provide a clear, informative response that helps the user understand this California bill. Focus on practical implications and explain legal concepts in accessible terms.
        """
        
        // Get AI response
        Task {
            let response = await getAIResponse(prompt: contextPrompt)
            await MainActor.run {
                chatHistory.append(ChatMessage(text: response, isUser: false))
                isLoading = false
            }
        }
    }
    
    private func getAIResponse(prompt: String) async -> String {
        guard APIConfiguration.isOpenAIAPIKeyValid else {
            return "AI API key missing. Please add your OpenAI API key to use this feature."
        }
        
        let url = URL(string: APIConfiguration.Endpoints.chatCompletions)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(APIConfiguration.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [["role": "user", "content": prompt]],
            "max_tokens": 500,
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



struct CaliforniaBillAIView_Previews: PreviewProvider {
    static var previews: some View {
        CaliforniaBillAIView(bill: CaliforniaBill(
            id: "AB-123",
            billNumber: "AB 123",
            title: "An act to add Section 12345 to the Health and Safety Code, relating to public health.",
            description: "This bill would require the Department of Public Health to establish guidelines for public health emergencies.",
            status: "In Committee",
            lastAction: "Referred to Assembly Health Committee",
            lastActionDate: "2024-01-15",
            author: "Assembly Member Smith",
            house: "Assembly",
            session: "2023-2024",
            url: "https://leginfo.legislature.ca.gov/faces/billTextClient.xhtml?bill_id=202320240AB123"
        ))
    }
}
