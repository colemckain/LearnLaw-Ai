import SwiftUI

struct LessonDetailView: View {
    let topic: LearningTopic
    @State private var selectedLessonIndex = 0
    @State private var showingQuiz = false
    @State private var showingReading = false
    @ObservedObject var progressManager = ProgressManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with topic info
                VStack(spacing: 16) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(topic.color.opacity(0.2))
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: topic.icon)
                                .font(.title)
                                .foregroundColor(topic.color)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(topic.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(topic.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                            
                            Text("\(topic.lessons.count) lessons • \(topic.estimatedTime) min")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("\(Int(progressManager.getTopicProgress(topicId: topic.id) * 100))%")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(topic.color)
                            
                            Text("Complete")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Overall progress bar
                    ProgressView(value: progressManager.getTopicProgress(topicId: topic.id))
                        .progressViewStyle(LinearProgressViewStyle(tint: topic.color))
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Lessons list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(topic.lessons.enumerated()), id: \.element.id) { index, lesson in
                            LessonCard(
                                lesson: lesson,
                                isCompleted: progressManager.getLessonProgress(lessonId: lesson.id) >= 1.0,
                                progress: progressManager.getLessonProgress(lessonId: lesson.id),
                                color: topic.color
                            ) {
                                selectedLessonIndex = index
                                showingReading = true
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Lessons")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .sheet(isPresented: $showingReading) {
            ReadingView(
                lesson: topic.lessons[selectedLessonIndex],
                topicColor: topic.color,
                onReadyForQuiz: {
                    showingReading = false
                    showingQuiz = true
                }
            )
        }
        .sheet(isPresented: $showingQuiz) {
            QuizView(
                lesson: topic.lessons[selectedLessonIndex],
                onComplete: { score in
                    progressManager.updateLessonProgress(lessonId: topic.lessons[selectedLessonIndex].id, progress: score)
                    progressManager.updateTopicProgress(topicId: topic.id, progress: progressManager.calculateTopicProgress(lessons: topic.lessons))
                }
            )
        }
    }
}

struct ReadingView: View {
    let lesson: LearningLesson
    let topicColor: Color
    let onReadyForQuiz: () -> Void
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text(lesson.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Image(systemName: "book.closed.fill")
                            .foregroundColor(topicColor)
                        Text("Reading Material")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Reading content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Reading content with professional formatting
                        VStack(alignment: .leading, spacing: 16) {
                            Text(lesson.content)
                                .font(.body)
                                .lineSpacing(6)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal)
                        
                        // Quiz info
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(topicColor)
                                Text("Quiz Information")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                Spacer()
                            }
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(lesson.questions.count) Questions")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text("Multiple choice")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("\(lesson.duration) min")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Text("Estimated time")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(topicColor.opacity(0.1))
                        )
                        .padding(.horizontal)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.vertical)
                }
                
                // Ready for Quiz button
                VStack(spacing: 16) {
                    Button(action: onReadyForQuiz) {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.headline)
                            Text("Ready for Quiz")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(topicColor)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    Text("Take your time to read the material above")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom, 20)
                .background(Color(.systemBackground))
            }
            .navigationTitle("Reading")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct LessonCard: View {
    let lesson: LearningLesson
    let isCompleted: Bool
    let progress: Double
    let color: Color
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Lesson number and status
                ZStack {
                    Circle()
                        .fill(isCompleted ? color : color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    } else {
                        Text("\(lesson.order)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(color)
                    }
                }
                
                // Lesson content
                VStack(alignment: .leading, spacing: 4) {
                    Text(lesson.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Image(systemName: lessonTypeIcon)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text("\(lesson.duration) min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        if lesson.questions.count > 0 {
                            Text("• \(lesson.questions.count) questions")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if progress > 0 && progress < 1.0 {
                        ProgressView(value: progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: color))
                            .scaleEffect(x: 1, y: 0.5, anchor: .center)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var lessonTypeIcon: String {
        switch lesson.type {
        case .text: return "doc.text"
        case .video: return "play.circle"
        case .interactive: return "hand.tap"
        case .quiz: return "questionmark.circle"
        }
    }
}

struct QuizView: View {
    let lesson: LearningLesson
    let onComplete: (Double) -> Void
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: Int? = nil
    @State private var showingExplanation = false
    @State private var correctAnswers = 0
    @State private var quizCompleted = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if !quizCompleted {
                    // Progress indicator
                    HStack {
                        Text("Question \(currentQuestionIndex + 1) of \(lesson.questions.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        ProgressView(value: Double(currentQuestionIndex), total: Double(lesson.questions.count))
                            .progressViewStyle(LinearProgressViewStyle(tint: ColorUtilities.patrioticBlue))
                            .frame(width: 100)
                    }
                    .padding(.horizontal)
                    
                    // Question
                    VStack(alignment: .leading, spacing: 16) {
                        Text(lesson.questions[currentQuestionIndex].question)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        // Answer options
                        VStack(spacing: 12) {
                            ForEach(0..<lesson.questions[currentQuestionIndex].options.count, id: \.self) { index in
                                Button(action: {
                                    selectedAnswer = index
                                }) {
                                    HStack {
                                        Text(lesson.questions[currentQuestionIndex].options[index])
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
                            }
                        }
                    }
                    .padding()
                    
                    // Navigation buttons
                    HStack {
                        if currentQuestionIndex > 0 {
                            Button("Previous") {
                                currentQuestionIndex -= 1
                                selectedAnswer = nil
                                showingExplanation = false
                            }
                            .foregroundColor(ColorUtilities.patrioticBlue)
                        }
                        
                        Spacer()
                        
                        if selectedAnswer != nil {
                            Button(currentQuestionIndex == lesson.questions.count - 1 ? "Finish Quiz" : "Next") {
                                if selectedAnswer == lesson.questions[currentQuestionIndex].correctAnswer {
                                    correctAnswers += 1
                                }
                                
                                if currentQuestionIndex == lesson.questions.count - 1 {
                                    quizCompleted = true
                                } else {
                                    currentQuestionIndex += 1
                                    selectedAnswer = nil
                                    showingExplanation = false
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(ColorUtilities.patrioticBlue)
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                } else {
                    // Quiz results
                    VStack(spacing: 24) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(ColorUtilities.patrioticBlue)
                        
                        Text("Quiz Complete!")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("You got \(correctAnswers) out of \(lesson.questions.count) questions correct")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                        
                        Text("Score: \(Int((Double(correctAnswers) / Double(lesson.questions.count)) * 100))%")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(ColorUtilities.patrioticBlue)
                        
                        Button("Continue") {
                            let score = Double(correctAnswers) / Double(lesson.questions.count)
                            onComplete(score)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(ColorUtilities.patrioticBlue)
                        .cornerRadius(8)
                    }
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle(lesson.title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct LessonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailView(topic: LearningTopic(
            title: "How a Bill Becomes Law",
            description: "Learn the step-by-step process",
            icon: "doc.text",
            color: ColorUtilities.patrioticBlue,
            progress: 0.3,
            estimatedTime: 45,
            lessons: []
        ))
    }
} 