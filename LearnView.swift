import SwiftUI

struct LearnView: View {
    @StateObject private var progressManager = ProgressManager.shared
    @StateObject private var challengeManager = DailyChallengeManager.shared
    @State private var topics: [LearningTopic] = [
        LearningTopic(
            title: "The Basics of the U.S. Government",
            description: "Learn about the three branches of government, the Constitution, and how Congress works",
            icon: "building.2",
            color: ColorUtilities.patrioticBlue,
            progress: 0.0,
            estimatedTime: 15,
            lessons: [
                LearningLesson(
                    title: "Government Fundamentals",
                    content: "The United States government is built on the principle of separation of powers, dividing authority among three branches: the Legislative, Executive, and Judicial. The Legislative Branch, known as Congress, is responsible for making laws and is divided into two chambers: the Senate and the House of Representatives. The Executive Branch, led by the President, enforces laws and manages the day-to-day operations of the federal government. The Judicial Branch, headed by the Supreme Court, interprets laws and ensures they are applied fairly.\n\nThe Constitution, signed in 1787, is the supreme law of the land. It outlines the structure of government, enumerates the powers of each branch, and protects the rights of citizens. Congress, made up of 100 Senators and 435 Representatives, creates federal laws, declares war, and controls government spending. The President, elected every four years, serves as Commander-in-Chief of the armed forces and can veto legislation. The Supreme Court and other federal courts resolve disputes and can declare laws unconstitutional.\n\nThis system of checks and balances ensures that no single branch becomes too powerful. For example, while Congress can pass laws, the President can veto them, and the Supreme Court can rule them unconstitutional. This framework has allowed the U.S. government to adapt and endure for over two centuries.",
                    type: .text,
                    duration: 5,
                    questions: [
                        QuizQuestion(
                            question: "What are the three branches of the U.S. government, and what is the primary function of each?",
                            options: [
                                "Legislative (makes laws), Executive (enforces laws), Judicial (interprets laws)",
                                "Legislative (enforces laws), Executive (interprets laws), Judicial (makes laws)",
                                "Executive (makes laws), Judicial (enforces laws), Legislative (interprets laws)",
                                "Judicial (makes laws), Legislative (enforces laws), Executive (interprets laws)"
                            ],
                            correctAnswer: 0,
                            explanation: "The Legislative branch makes laws, the Executive enforces them, and the Judicial interprets them."
                        ),
                        QuizQuestion(
                            question: "Which document is considered the supreme law of the United States?",
                            options: [
                                "Declaration of Independence",
                                "Bill of Rights",
                                "Constitution",
                                "Articles of Confederation"
                            ],
                            correctAnswer: 2,
                            explanation: "The Constitution is the supreme law of the land."
                        ),
                        QuizQuestion(
                            question: "Who has the power to veto laws passed by Congress?",
                            options: [
                                "The Supreme Court",
                                "The President",
                                "The Speaker of the House",
                                "The Senate Majority Leader"
                            ],
                            correctAnswer: 1,
                            explanation: "The President can veto laws passed by Congress."
                        ),
                        QuizQuestion(
                            question: "How many Senators and Representatives make up Congress?",
                            options: [
                                "50 Senators, 100 Representatives",
                                "100 Senators, 435 Representatives",
                                "435 Senators, 100 Representatives",
                                "200 Senators, 200 Representatives"
                            ],
                            correctAnswer: 1,
                            explanation: "Congress consists of 100 Senators and 435 Representatives."
                        ),
                        QuizQuestion(
                            question: "What is the main purpose of the system of checks and balances?",
                            options: [
                                "To allow the President to make all decisions",
                                "To ensure no branch becomes too powerful",
                                "To give Congress more power than the other branches",
                                "To let the Supreme Court write laws"
                            ],
                            correctAnswer: 1,
                            explanation: "Checks and balances prevent any one branch from becoming too powerful."
                        )
                    ],
                    order: 1
                )
            ]
        ),
        LearningTopic(
            title: "Citizens' Rights & Responsibilities",
            description: "Understand your rights as a citizen and your civic responsibilities",
            icon: "person.circle",
            color: ColorUtilities.patrioticRed,
            progress: 0.0,
            estimatedTime: 15,
            lessons: [
                LearningLesson(
                    title: "Rights and Duties",
                    content: "As a citizen of the United States, you are guaranteed a wide range of rights and freedoms, many of which are protected by the Constitution and its amendments. The First Amendment, for example, ensures freedom of speech, religion, press, assembly, and petition. These rights allow individuals to express their opinions, practice their faith, and seek changes in government without fear of punishment.\n\nOther important rights include the right to a fair trial, the right to bear arms (Second Amendment), and protection from unreasonable searches and seizures (Fourth Amendment). The right to vote is a cornerstone of American democracy, allowing citizens to choose their leaders and influence laws and policies. Voting is both a right and a responsibility, as it ensures that the government reflects the will of the people.\n\nAlongside these rights, citizens have important civic duties. These include obeying the law, paying taxes, serving on a jury when called, and participating in the democratic process. Jury service is a vital part of the justice system, ensuring that legal decisions are made by a group of peers. Respecting the rights of others, staying informed about public issues, and contributing to the community are also key responsibilities.\n\nBy understanding and exercising your rights, and by fulfilling your responsibilities, you help maintain a free and just society. Active citizenship strengthens democracy and ensures that everyone’s voice can be heard.",
                    type: .text,
                    duration: 5,
                    questions: [
                        QuizQuestion(
                            question: "Which amendment protects freedoms of speech, religion, and the press?",
                            options: [
                                "First Amendment",
                                "Second Amendment",
                                "Fifth Amendment",
                                "Tenth Amendment"
                            ],
                            correctAnswer: 0,
                            explanation: "The First Amendment protects these freedoms."
                        ),
                        QuizQuestion(
                            question: "What is one responsibility only for U.S. citizens?",
                            options: [
                                "Obeying the law",
                                "Paying taxes",
                                "Voting in federal elections",
                                "Serving in the military"
                            ],
                            correctAnswer: 2,
                            explanation: "Only U.S. citizens can vote in federal elections."
                        ),
                        QuizQuestion(
                            question: "What is the minimum age to vote in federal elections in the U.S.?",
                            options: [
                                "16",
                                "18",
                                "21",
                                "25"
                            ],
                            correctAnswer: 1,
                            explanation: "Citizens can vote at age 18."
                        ),
                        QuizQuestion(
                            question: "What do we show loyalty to when we say the Pledge of Allegiance?",
                            options: [
                                "The Constitution",
                                "The flag and the United States",
                                "The President",
                                "The military"
                            ],
                            correctAnswer: 1,
                            explanation: "The Pledge of Allegiance is to the flag and the United States."
                        ),
                        QuizQuestion(
                            question: "Which of the following is a civic duty of U.S. citizens?",
                            options: [
                                "Traveling abroad",
                                "Serving on a jury",
                                "Owning property",
                                "Running for office"
                            ],
                            correctAnswer: 1,
                            explanation: "Serving on a jury is a civic duty."
                        )
                    ],
                    order: 1
                )
            ]
        ),
        LearningTopic(
            title: "The Constitution and Bill of Rights",
            description: "Explore the founding document and the first ten amendments",
            icon: "doc.text",
            color: ColorUtilities.patrioticBlue,
            progress: 0.0,
            estimatedTime: 20,
            lessons: [
                LearningLesson(
                    title: "Founding Documents",
                    content: "The United States Constitution, signed in 1787, is the foundational document of American government. It establishes the structure of the federal government, divides powers among the three branches, and outlines the relationship between the states and the federal government. The Constitution begins with the Preamble, which sets forth the goals of the nation: “to form a more perfect Union, establish Justice, insure domestic Tranquility, provide for the common defence, promote the general Welfare, and secure the Blessings of Liberty.”\n\nThe main body of the Constitution is divided into seven articles. These articles describe the powers and responsibilities of Congress (Article I), the President (Article II), and the federal courts (Article III), as well as the relationships among the states, the process for amending the Constitution, and the supremacy of federal law.\n\nShortly after the Constitution was ratified, the first ten amendments—known as the Bill of Rights—were added to protect individual liberties. The Bill of Rights guarantees freedoms such as speech, religion, press, assembly, and petition (First Amendment); the right to bear arms (Second Amendment); protection from unreasonable searches and seizures (Fourth Amendment); the right to a fair trial (Sixth Amendment); and protection from cruel and unusual punishment (Eighth Amendment). The Fifth Amendment protects against self-incrimination and double jeopardy.\n\nOver time, additional amendments have expanded rights and clarified government powers. The Bill of Rights remains a cornerstone of American democracy, ensuring that the government cannot infringe upon the basic rights of its citizens.",
                    type: .text,
                    duration: 5,
                    questions: [
                        QuizQuestion(
                            question: "When was the U.S. Constitution signed?",
                            options: [
                                "1776",
                                "1781",
                                "1787",
                                "1791"
                            ],
                            correctAnswer: 2,
                            explanation: "The Constitution was signed in 1787."
                        ),
                        QuizQuestion(
                            question: "What are the first ten amendments to the Constitution called?",
                            options: [
                                "The Federalist Papers",
                                "The Bill of Rights",
                                "The Magna Carta",
                                "The Articles of Confederation"
                            ],
                            correctAnswer: 1,
                            explanation: "The first ten amendments are known as the Bill of Rights."
                        ),
                        QuizQuestion(
                            question: "Which amendment protects against self-incrimination?",
                            options: [
                                "First Amendment",
                                "Fourth Amendment",
                                "Fifth Amendment",
                                "Eighth Amendment"
                            ],
                            correctAnswer: 2,
                            explanation: "The Fifth Amendment protects against self-incrimination."
                        ),
                        QuizQuestion(
                            question: "Which amendment protects against cruel and unusual punishment?",
                            options: [
                                "Third Amendment",
                                "Sixth Amendment",
                                "Eighth Amendment",
                                "Tenth Amendment"
                            ],
                            correctAnswer: 2,
                            explanation: "The Eighth Amendment protects against cruel and unusual punishment."
                        ),
                        QuizQuestion(
                            question: "What is the purpose of the Bill of Rights?",
                            options: [
                                "To outline the structure of Congress",
                                "To protect individual liberties from government overreach",
                                "To establish the Supreme Court",
                                "To define the powers of the President"
                            ],
                            correctAnswer: 1,
                            explanation: "The Bill of Rights protects individual liberties from government overreach."
                        )
                    ],
                    order: 1
                )
            ]
        ),
        LearningTopic(
            title: "Checks and Balances",
            description: "Learn how the three branches keep each other in check",
            icon: "scale.3d",
            color: ColorUtilities.patrioticRed,
            progress: 0.0,
            estimatedTime: 15,
            lessons: [
                LearningLesson(
                    title: "System of Checks",
                    content: "The system of checks and balances is a fundamental principle of the United States government, designed to ensure that no single branch becomes too powerful. The Constitution divides the federal government into three branches: Legislative (Congress), Executive (President), and Judicial (Supreme Court and other federal courts). Each branch has its own powers and responsibilities, but also the ability to limit the powers of the other branches.\n\nFor example, Congress can pass laws, but the President has the power to veto those laws. However, Congress can override a presidential veto with a two-thirds majority vote in both the House and Senate. The President appoints federal judges, including Supreme Court justices, but those appointments must be confirmed by the Senate. The Supreme Court can declare laws or executive actions unconstitutional, effectively nullifying them.\n\nThis system creates a balance of power and encourages cooperation and compromise. It also provides a way for each branch to hold the others accountable. By requiring the branches to share power and check each other’s actions, the framers of the Constitution aimed to prevent tyranny and protect individual freedoms.\n\nChecks and balances are not just theoretical—they play a real role in American government. Throughout history, this system has been used to resolve conflicts, prevent abuses of power, and ensure that the government remains responsive to the people.",
                    type: .text,
                    duration: 5,
                    questions: [
                        QuizQuestion(
                            question: "What is the main purpose of the system of checks and balances?",
                            options: [
                                "To allow the President to make all decisions",
                                "To ensure no branch becomes too powerful",
                                "To give Congress more power than the other branches",
                                "To let the Supreme Court write laws"
                            ],
                            correctAnswer: 1,
                            explanation: "Checks and balances prevent any one branch from becoming too powerful."
                        ),
                        QuizQuestion(
                            question: "Who can veto a bill passed by Congress?",
                            options: [
                                "The Supreme Court",
                                "The President",
                                "The Speaker of the House",
                                "The Senate Majority Leader"
                            ],
                            correctAnswer: 1,
                            explanation: "The President can veto bills."
                        ),
                        QuizQuestion(
                            question: "How can Congress override a presidential veto?",
                            options: [
                                "With a simple majority in the House",
                                "With a two-thirds majority in both the House and Senate",
                                "With approval from the Supreme Court",
                                "With a national referendum"
                            ],
                            correctAnswer: 1,
                            explanation: "Congress can override a veto with a two-thirds majority in both chambers."
                        ),
                        QuizQuestion(
                            question: "Who confirms Supreme Court justices?",
                            options: [
                                "The House of Representatives",
                                "The Senate",
                                "The President",
                                "The Chief Justice"
                            ],
                            correctAnswer: 1,
                            explanation: "The Senate confirms Supreme Court justices."
                        ),
                        QuizQuestion(
                            question: "Which branch can declare laws unconstitutional?",
                            options: [
                                "Legislative",
                                "Executive",
                                "Judicial",
                                "State governments"
                            ],
                            correctAnswer: 2,
                            explanation: "The Judicial branch (Supreme Court) can declare laws unconstitutional."
                        )
                    ],
                    order: 1
                )
            ]
        ),
        LearningTopic(
            title: "Advanced U.S. Civics & History",
            description: "Dive deeper into American history and advanced civic concepts",
            icon: "graduationcap",
            color: ColorUtilities.patrioticBlue,
            progress: 0.0,
            estimatedTime: 20,
            lessons: [
                LearningLesson(
                    title: "Historical Foundations",
                    content: "The history of the United States is marked by pivotal events and influential documents that have shaped the nation’s government and society. After gaining independence from Britain, the Founding Fathers debated how to create a strong but fair government. The Federalist Papers—essays written by Alexander Hamilton, James Madison, and John Jay—argued for the ratification of the Constitution and explained the principles behind the new government.\n\nThe Civil War (1861–1865) was a defining conflict in American history, fought over issues including slavery and states’ rights. The war resulted in the abolition of slavery and the preservation of the Union. President Abraham Lincoln’s Emancipation Proclamation in 1863 declared freedom for slaves in Confederate states, and the 13th Amendment later abolished slavery throughout the country.\n\nThe concept of the “rule of law” is central to American democracy. It means that everyone, including leaders, must follow the law. No one is above the law, and laws are applied equally to all citizens. This principle is essential for protecting individual rights and maintaining order.\n\nThroughout its history, the United States has amended its Constitution to expand rights and address new challenges. The 19th Amendment gave women the right to vote, and the Civil Rights Movement of the 1960s led to laws ending segregation and protecting voting rights for all citizens. Understanding these historical foundations helps us appreciate the ongoing effort to create a more just and equal society.",
                    type: .text,
                    duration: 5,
                    questions: [
                        QuizQuestion(
                            question: "What were the Federalist Papers?",
                            options: [
                                "War treaties",
                                "Letters supporting independence",
                                "Essays supporting the Constitution",
                                "State constitutions"
                            ],
                            correctAnswer: 2,
                            explanation: "The Federalist Papers were essays supporting the Constitution."
                        ),
                        QuizQuestion(
                            question: "Who was one of the authors of the Federalist Papers?",
                            options: [
                                "Abraham Lincoln",
                                "James Madison",
                                "George Washington",
                                "Thomas Jefferson"
                            ],
                            correctAnswer: 1,
                            explanation: "James Madison was one of the authors."
                        ),
                        QuizQuestion(
                            question: "What was one major cause of the Civil War?",
                            options: [
                                "Immigration",
                                "Slavery",
                                "Taxation",
                                "Voting rights"
                            ],
                            correctAnswer: 1,
                            explanation: "Slavery was a major cause of the Civil War."
                        ),
                        QuizQuestion(
                            question: "What did the Emancipation Proclamation do?",
                            options: [
                                "Ended the war",
                                "Freed all U.S. slaves",
                                "Freed slaves in Confederate states",
                                "Created the Bill of Rights"
                            ],
                            correctAnswer: 2,
                            explanation: "The Emancipation Proclamation freed slaves in Confederate states."
                        ),
                        QuizQuestion(
                            question: "What does the “rule of law” mean?",
                            options: [
                                "Laws only apply to citizens",
                                "Leaders do not have to follow the law",
                                "Everyone must follow the law",
                                "Only judges interpret the law"
                            ],
                            correctAnswer: 2,
                            explanation: "The rule of law means everyone must follow the law."
                        )
                    ],
                    order: 1
                )
            ]
        )
    ]
    
    @State private var showingLessonDetail = false
    @State private var selectedTopic: LearningTopic?
    @State private var showingDailyChallenge = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Learn & Grow")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Build your civic knowledge with interactive lessons")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Progress Overview
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Progress")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(completedTopics)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(ColorUtilities.patrioticBlue)
                                Text("Topics Completed")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("\(totalPoints)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(ColorUtilities.patrioticRed)
                                Text("Points Earned")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Daily Challenge
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Daily Challenge")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: challengeManager.isChallengeAvailable() ? "star.fill" : "checkmark.circle.fill")
                                    .foregroundColor(challengeManager.isChallengeAvailable() ? .yellow : ColorUtilities.patrioticBlue)
                                Text(challengeManager.isChallengeAvailable() ? "Complete today's civic check" : "Challenge completed!")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            
                            if challengeManager.isChallengeAvailable() {
                                Text("Test your knowledge with a quick quiz about government and civics")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("Great job! Come back tomorrow for a new challenge")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Streak info
                            HStack {
                                Text("🔥 \(challengeManager.dailyStreak) Day Streak")
                                    .font(.caption)
                                    .foregroundColor(ColorUtilities.patrioticRed)
                                
                                Spacer()
                                
                                if let challenge = challengeManager.currentChallenge, challenge.isCompleted {
                                    Text("Score: \(challenge.score ?? 0)/\(challenge.questions.count)")
                                        .font(.caption)
                                        .foregroundColor(ColorUtilities.patrioticBlue)
                                }
                            }
                            
                            Button(action: {
                                showingDailyChallenge = true
                            }) {
                                Text(challengeManager.isChallengeAvailable() ? "Start Challenge" : "View Results")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(challengeManager.isChallengeAvailable() ? ColorUtilities.patrioticBlue : ColorUtilities.patrioticRed)
                                    .cornerRadius(8)
                            }
                            .disabled(!challengeManager.isChallengeAvailable() && challengeManager.currentChallenge?.isCompleted != true)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    // Learning Topics
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Topics")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(topics) { topic in
                                TopicCard(topic: topic)
                                    .onTapGesture {
                                        selectedTopic = topic
                                        showingLessonDetail = true
                                    }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingLessonDetail) {
            if let topic = selectedTopic {
                LessonDetailView(topic: topic)
            }
        }
        .sheet(isPresented: $showingDailyChallenge) {
            DailyChallengeView()
        }
    }
    
    private var completedTopics: Int {
        progressManager.getTotalCompletedTopics()
    }
    
    private var totalPoints: Int {
        progressManager.totalPoints
    }
}

struct TopicCard: View {
    let topic: LearningTopic
    @ObservedObject var progressManager = ProgressManager.shared
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(topic.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: topic.icon)
                    .font(.title2)
                    .foregroundColor(topic.color)
            }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(topic.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                HStack {
                    Text("\(topic.estimatedTime) min")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if topic.lessons.count > 0 {
                        Text("• \(topic.lessons.count) lessons")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Progress bar
                ProgressView(value: progressManager.getTopicProgress(topicId: topic.id))
                    .progressViewStyle(LinearProgressViewStyle(tint: topic.color))
                    .scaleEffect(x: 1, y: 0.5, anchor: .center)
            }
            
            Spacer()
            
            // Status indicator
            let progress = progressManager.getTopicProgress(topicId: topic.id)
            if progress >= 1.0 {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title2)
            } else if progress > 0 {
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(topic.color)
            } else {
                Image(systemName: "play.circle")
                    .foregroundColor(topic.color)
                    .font(.title2)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView()
    }
} 