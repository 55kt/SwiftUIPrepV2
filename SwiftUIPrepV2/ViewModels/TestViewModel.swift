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
    
    // MARK: - Private Properties
    private var timer: Timer?
    private var numberOfQuestions: Int = 0
    private var allQuestions: FetchedResults<Question>?
    private var viewContext: NSManagedObjectContext?
    private let progressViewModel: ProgressViewModel
    
    // MARK: - Initialization
    init(progressViewModel: ProgressViewModel = ProgressViewModel()) {
        self.progressViewModel = progressViewModel
    }
    
    // MARK: - Public Methods
    func setupTest(numberOfQuestions: Int, allQuestions: FetchedResults<Question>, viewContext: NSManagedObjectContext) {
        self.numberOfQuestions = numberOfQuestions
        self.allQuestions = allQuestions
        self.viewContext = viewContext
        progressViewModel.setup(viewContext: viewContext)
        reset()
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
        
        question.isAnswered = true
        question.isAnsweredCorrectly = (answer == question.correctAnswer)
        do {
            try viewContext?.save()
        } catch {
            print("❌ Error saving answer: \(error.localizedDescription) ❌") // delete this code in final commit
        }
        
        if currentQuestionIndex < questions.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.currentQuestionIndex += 1
                self.loadQuestion()
            }
        } else {
            progressViewModel.saveTestProgress(questions: questions, duration: testDuration)
            isTestFinished = true
        }
    }
    
    // MARK: - Private Methods
    private func reset() {
        currentQuestionIndex = 0
        questions = []
        answers = []
        selectedAnswer = nil
        showCorrectAnswer = false
        testStartTime = Date()
        testDuration = "00:00"
        isTestFinished = false
        timer?.invalidate()
        timer = nil
    }
    
    private func startTest() {
        guard let allQuestions = allQuestions, let viewContext = viewContext else { return }
        
        let shuffledQuestions = allQuestions.shuffled()
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
            newQuestion.iconName = originalQuestion.iconName ?? "unknown-icon"
            print("🔍 Original question: \(originalQuestion.question), iconName: \(originalQuestion.iconName ?? "nil")") // delete this code in final commit
            print("🔍 New question: \(newQuestion.question), iconName: \(newQuestion.iconName ?? "nil")") // delete this code in final commit
            return newQuestion
        }
        
        do {
            try viewContext.save()
        } catch {
            print("❌ Error saving questions: \(error)") // delete this code in final commit
        }
        
        if questions.isEmpty {
            return
        }
        
        loadQuestion()
        
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
        
        var answerOptions = [question.correctAnswer]
        if let incorrectAnswers = question.incorrectAnswers, !incorrectAnswers.isEmpty {
            let shuffledIncorrect = incorrectAnswers.shuffled()
            answerOptions.append(contentsOf: shuffledIncorrect.prefix(2))
        } else {
            answerOptions.append("Incorrect Option 1")
            answerOptions.append("Incorrect Option 2")
        }
        answers = answerOptions.shuffled()
        
        selectedAnswer = nil
        showCorrectAnswer = false
    }
    
    private func resetTestProgress() {
        for question in questions {
            question.isAnswered = false
            question.isAnsweredCorrectlyRaw = nil
        }
        do {
            try viewContext?.save()
        } catch {
            print("❌ Error resetting test progress: \(error.localizedDescription) ❌") // delete this code in final commit
        }
    }
} // TestViewModel
