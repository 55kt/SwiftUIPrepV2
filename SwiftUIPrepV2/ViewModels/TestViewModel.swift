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
    @Published var progressResult: ProgressResult? // Для хранения результатов теста
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var numberOfQuestions: Int = 0
    private var allQuestions: FetchedResults<Question>?
    private var viewContext: NSManagedObjectContext?
    
    // MARK: - Computed Properties
    // Number of correct answers
    var correctAnswers: Int {
        questions.filter { $0.isAnswered && ($0.isAnsweredCorrectly ?? false) }.count
    }
    
    // MARK: - Public Methods
    func setupTest(numberOfQuestions: Int, allQuestions: FetchedResults<Question>, viewContext: NSManagedObjectContext) {
        self.numberOfQuestions = numberOfQuestions
        self.allQuestions = allQuestions
        self.viewContext = viewContext
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
        }
        
        do {
            try viewContext.save()
            print("✅ Saved test progress: \(correctAnswers)/\(questions.count), duration: \(testDuration)")
        } catch {
            print("❌ Error saving test progress: \(error.localizedDescription)")
        }
        
        // Store the progress result
        self.progressResult = progressResult
    }
    
    // MARK: - Private Methods
    private func startTest() {
        guard let allQuestions = allQuestions else { return }
        
        // Load and shuffle questions
        let shuffledQuestions = allQuestions.shuffled()
        
        // Take the required number of questions
        questions = Array(shuffledQuestions.prefix(numberOfQuestions))
        
        // Check if there are any questions
        if questions.isEmpty {
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
        if let incorrectAnswers = question.incorrectAnswers {
            answerOptions.append(contentsOf: incorrectAnswers.prefix(2)) // Take only 2 incorrect answers
        }
        answers = answerOptions.shuffled()
        
        // Reset state
        selectedAnswer = nil
        showCorrectAnswer = false
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
