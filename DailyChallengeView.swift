import SwiftUI

struct DailyChallengeView: View {
    @ObservedObject var challengeManager = DailyChallengeManager.shared
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var correctAnswers = 0
    @State private var timeRemaining = 30 // 30 seconds per question
    @State private var timer: Timer?
    @State private var showingResults = false
    @State private var startTime = Date()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if !showingResults {
                    // Header with progress and timer
                    VStack(spacing: 16) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Daily Challenge")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("Question \(currentQuestionIndex + 1) of \(challengeManager.currentChallenge?.questions.count ?? 0)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            // Timer
                            VStack {
                                Text("\(timeRemaining)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(timeRemaining <= 10 ? ColorUtilities.patrioticRed : ColorUtilities.patrioticBlue)
                                
                                Text("seconds")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        // Progress bar
                        ProgressView(value: Double(currentQuestionIndex), total: Double(challengeManager.currentChallenge?.questions.count ?? 1))
                            .progressViewStyle(LinearProgressViewStyle(tint: ColorUtilities.patrioticBlue))
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    
                    // Question content
                    ScrollView {
                        VStack(spacing: 24) {
                            if let challenge = challengeManager.currentChallenge {
                                // Question
                                VStack(alignment: .leading, spacing: 16) {
                                    Text(challenge.questions[currentQuestionIndex].question)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                        .multilineTextAlignment(.leading)
                                    
                                    // Answer options
                                    VStack(spacing: 12) {
                                        ForEach(0..<challenge.questions[currentQuestionIndex].options.count, id: \.self) { index in
                                            Button(action: {
                                                selectedAnswer = index
                                                submitAnswer()
                                            }) {
                                                HStack {
                                                    Text(challenge.questions[currentQuestionIndex].options[index])
                                                        .font(.body)
                                                        .foregroundColor(.primary)
                                                        .multilineTextAlignment(.leading)
                                                    
                                                    Spacer()
                                                    
                                                    if selectedAnswer == index {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(ColorUtilities.patrioticBlue)
                                                    } else {
                                                        Image(systemName: "circle")
                                                            .foregroundColor(.secondary)
                                                    }
                                                }
                                                .padding()
                                                .background(
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(selectedAnswer == index ? ColorUtilities.patrioticBlue.opacity(0.1) : Color(.systemGray6))
                                                )
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .disabled(selectedAnswer != nil)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                } else {
                    // Results view
                    VStack(spacing: 32) {
                        // Result icon
                        ZStack {
                            Circle()
                                .fill(correctAnswers >= 4 ? ColorUtilities.patrioticBlue.opacity(0.2) : ColorUtilities.patrioticRed.opacity(0.2))
                                .frame(width: 120, height: 120)
                            
                            Image(systemName: correctAnswers >= 4 ? "star.fill" : "star")
                                .font(.system(size: 50))
                                .foregroundColor(correctAnswers >= 4 ? ColorUtilities.patrioticBlue : ColorUtilities.patrioticRed)
                        }
                        
                        // Score
                        VStack(spacing: 8) {
                            Text("Challenge Complete!")
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Text("You got \(correctAnswers) out of \(challengeManager.currentChallenge?.questions.count ?? 0) questions correct")
                                .font(.title3)
                                .multilineTextAlignment(.center)
                            
                            Text("Score: \(Int((Double(correctAnswers) / Double(challengeManager.currentChallenge?.questions.count ?? 1)) * 100))%")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(ColorUtilities.patrioticBlue)
                        }
                        
                        // Streak info
                        VStack(spacing: 8) {
                            Text("🔥 \(challengeManager.dailyStreak) Day Streak!")
                                .font(.headline)
                                .foregroundColor(ColorUtilities.patrioticRed)
                            
                            Text("Keep it up! Come back tomorrow for another challenge.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Points earned
                        VStack(spacing: 4) {
                            Text("+\(correctAnswers * 20) Points")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(ColorUtilities.patrioticBlue)
                            
                            Text("Earned for today's challenge")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Button("Continue") {
                            let timeSpent = Int(Date().timeIntervalSince(startTime))
                            challengeManager.completeChallenge(score: correctAnswers, timeSpent: timeSpent)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 12)
                        .background(ColorUtilities.patrioticBlue)
                        .cornerRadius(8)
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Daily Challenge")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                submitAnswer()
            }
        }
    }
    
    private func submitAnswer() {
        timer?.invalidate()
        
        guard let challenge = challengeManager.currentChallenge else { return }
        
        if let selected = selectedAnswer {
            if selected == challenge.questions[currentQuestionIndex].correctAnswer {
                correctAnswers += 1
            }
        }
        
        // Move to next question or show results
        if currentQuestionIndex < challenge.questions.count - 1 {
            currentQuestionIndex += 1
            selectedAnswer = nil
            timeRemaining = 30
            startTimer()
        } else {
            showingResults = true
        }
    }
}

struct DailyChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        DailyChallengeView()
    }
} 