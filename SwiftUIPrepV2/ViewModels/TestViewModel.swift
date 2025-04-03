//
//  TestViewModel.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

class TestViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentQuestionIndex: Int = 0
    @Published var questions: [Question] = []
    @Published var answers: [String] = []
    @Published var selectedAnswer: String? = nil
    @Published var showCorrectAnswer: Bool = false
    @Published var testStartTime: Date = Date()
    @Published var testDuration: String = "00:00"
    @Published var isShowingStopAlert: Bool = false
    @Published var isTestFinished: Bool = false
    @Published var progressResult: ProgressResult?
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var numberOfQuestions: Int = 0
    private var allQuestions: FetchedResults<Question>?
    private var viewContext: NSManagedObjectContext?
    
    // MARK: - Computed Properties
    var correctAnswers: Int {
        questions.filter { $0.isAnswered && ($0.isAnsweredCorrectly ?? false) }.count
    }
    
    // MARK: - Public Methods
    func setupTest(numberOfQuestions: Int, allQuestions: FetchedResults<Question>, viewContext: NSManagedObjectContext) {
        self.numberOfQuestions = numberOfQuestions
        self.allQuestions = allQuestions
        self.viewContext = viewContext
        reset() // Reset state before starting a new test
        startTest()
    }
    
    func stopTest() {
        resetTestProgress()
        timer?.invalidate()
        isShowingStopAlert = false
    }
    
    func selectAnswer(_ answer: String, for question: Question) {
        selectedAnswer = answer
        showCorrectAnswer = true
        
        // Save the answer result
        question.isAnswered = true
        question.isAnsweredCorrectly = (answer == question.correctAnswer)
        do {
            try viewContext?.save()
            print("💾 Saved answer for question: \(question.question), correct: \(question.isAnsweredCorrectly ?? false) 💾")
        } catch {
            print("❌ Error saving answer: \(error.localizedDescription) ❌")
        }
        
        // Move to the next question with a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.currentQuestionIndex < self.questions.count - 1 {
                self.currentQuestionIndex += 1
                self.loadQuestion()
            } else {
                // Test is finished, save progress
                self.saveTestProgress()
                self.isTestFinished = true
                print("🏁 Test finished, isTestFinished set to true")
            }
        }
    }
    
    func saveTestProgress() {
        guard let viewContext = viewContext else { return }
        
        let progressResult = ProgressResult(context: viewContext)
        progressResult.id = UUID()
        progressResult.date = Date()
        progressResult.totalQuestions = Int32(questions.count)
        progressResult.correctAnswers = Int32(correctAnswers)
        progressResult.duration = testDuration
        
        // Create QuestionResult for each question and add to progressResult
        for question in questions {
            let questionResult = QuestionResult(context: viewContext)
            questionResult.isAnsweredCorrectly = question.isAnsweredCorrectly ?? false
            questionResult.question = question
            questionResult.progressResult = progressResult
            progressResult.addToQuestionResults(questionResult)
            print("🔍 Added QuestionResult for question: \(question.question)")
        }
        
        do {
            try viewContext.save()
            print("✅ Saved test progress: \(correctAnswers)/\(questions.count), duration: \(testDuration)")
        } catch {
            print("❌ Error saving test progress: \(error.localizedDescription)")
        }
        
        self.progressResult = progressResult
    }
    
    // MARK: - Private Methods
    private func reset() {
        // Reset all state for a new test
        currentQuestionIndex = 0
        questions = []
        answers = []
        selectedAnswer = nil
        showCorrectAnswer = false
        testStartTime = Date()
        testDuration = "00:00"
        isTestFinished = false
        progressResult = nil
        timer?.invalidate()
        timer = nil
    }
    
    private func startTest() {
        guard let allQuestions = allQuestions, let viewContext = viewContext else { return }
        
        // Load and shuffle questions
        let shuffledQuestions = allQuestions.shuffled()
        
        // Take the required number of questions and create copies
        let selectedQuestions = Array(shuffledQuestions.prefix(numberOfQuestions))
        questions = selectedQuestions.map { originalQuestion in
            let newQuestion = Question(context: viewContext)
            newQuestion.id = UUID()
            newQuestion.question = originalQuestion.question
            newQuestion.correctAnswer = originalQuestion.correctAnswer
            newQuestion.incorrectAnswers = originalQuestion.incorrectAnswers
            newQuestion.questionDescription = originalQuestion.questionDescription
            newQuestion.isFavorite = false
            newQuestion.isAnswered = false
            newQuestion.isAnsweredCorrectlyRaw = nil
            newQuestion.categoryIconName = originalQuestion.category?.iconName // Copy iconName
            // Do not set category to avoid adding to the original category
            return newQuestion
        }
        
        // Check if there are any questions
        if questions.isEmpty {
            print("⚠️ No questions available to start the test")
            return
        }
        
        // Initialize the first question
        loadQuestion()
        
        // Start the timer
        testStartTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let elapsedTime = Int(Date().timeIntervalSince(self.testStartTime))
            let minutes = elapsedTime / 60
            let seconds = elapsedTime % 60
            self.testDuration = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func loadQuestion() {
        guard currentQuestionIndex < questions.count else { return }
        let question = questions[currentQuestionIndex]
        
        // Randomize answer options
        var answerOptions = [question.correctAnswer]
        if let incorrectAnswers = question.incorrectAnswers, !incorrectAnswers.isEmpty {
            // Take up to 2 incorrect answers, shuffle them to ensure variety
            let shuffledIncorrect = incorrectAnswers.shuffled()
            answerOptions.append(contentsOf: shuffledIncorrect.prefix(2))
        } else {
            // Fallback if no incorrect answers are available
            answerOptions.append("Incorrect Option 1")
            answerOptions.append("Incorrect Option 2")
        }
        answers = answerOptions.shuffled()
        
        // Reset state
        selectedAnswer = nil
        showCorrectAnswer = false
        
        print("🔍 Loaded question: \(question.question), answers: \(answers)")
    }
    
    private func resetTestProgress() {
        // Reset the progress of the current test
        for question in questions {
            question.isAnswered = false
            question.isAnsweredCorrectlyRaw = nil
        }
        do {
            try viewContext?.save()
            print("🗑️ Test progress reset successfully 🗑️")
        } catch {
            print("❌ Error resetting test progress: \(error.localizedDescription) ❌")
        }
    }
}
