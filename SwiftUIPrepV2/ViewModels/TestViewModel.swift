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
    private let coreDataRepository: CoreDataRepositoryProtocol
    
    // MARK: - Initialization
    init(coreDataRepository: CoreDataRepositoryProtocol) {
        self.coreDataRepository = coreDataRepository
        print("🔍 TestViewModel: Initialized with coreDataRepository")
    }
    
    // MARK: - Computed Properties
    var correctAnswers: Int {
        guard let progressResult = progressResult,
              let questionResults = progressResult.questionResults as? Set<QuestionResult> else {
            return 0
        }
        return questionResults.filter { $0.isAnsweredCorrectly }.count
    }
    
    var scorePercentage: Double {
        guard progressResult?.totalQuestions ?? 0 > 0 else { return 0.0 }
        return (Double(correctAnswers) / Double(progressResult?.totalQuestions ?? 1)) * 100
    }
    
    var medalDetails: (color: Color, text: String) {
        switch scorePercentage {
        case 80...100:
            return (.yellow, "Gold Medal")
        case 50..<80:
            return (.gray, "Silver Medal")
        default:
            return (.brown, "Bronze Medal")
        }
    }
    
    // MARK: - Public Methods
    func setupTest(numberOfQuestions: Int, allQuestions: FetchedResults<Question>) {
        self.numberOfQuestions = numberOfQuestions
        self.allQuestions = allQuestions
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
        
        // Store the answer in a temporary ProgressResult until the test is finished
        if progressResult == nil {
            progressResult = ProgressResult(context: coreDataRepository.viewContext)
            progressResult?.id = UUID()
            progressResult?.date = Date()
            progressResult?.totalQuestions = Int32(questions.count)
            progressResult?.duration = testDuration
        }
        
        let questionResult = QuestionResult(context: coreDataRepository.viewContext)
        questionResult.isAnsweredCorrectly = (answer == question.correctAnswer)
        questionResult.question = question
        coreDataRepository.saveQuestionResult(questionResult, to: progressResult!)
        
        if currentQuestionIndex < questions.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.currentQuestionIndex += 1
                self.loadQuestion()
            }
        } else {
            saveTestProgress()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isTestFinished = true
            }
        }
    }
    
    func saveTestProgress() {
        guard let progressResult = progressResult else { return }
        coreDataRepository.saveProgressResult(progressResult)
    }
    
    func calculateCorrectPercentage(for progressResult: ProgressResult) -> Double {
        guard progressResult.totalQuestions > 0 else { return 0.0 }
        return (Double(progressResult.correctAnswers) / Double(progressResult.totalQuestions)) * 100
    }
    
    func calculateMedalColor(for progressResult: ProgressResult) -> Color {
        let percentage = calculateCorrectPercentage(for: progressResult)
        if percentage >= 80 {
            return .yellow
        } else if percentage >= 50 {
            return .gray
        } else {
            return .brown
        }
    }
    
    func deleteAllProgressResults(progressResults: [ProgressResult]) {
        coreDataRepository.deleteProgressResults(progressResults)
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
        progressResult = nil // Reset progressResult
        timer?.invalidate()
        timer = nil
    }
    
    private func startTest() {
        guard let allQuestions = allQuestions else { return }
        
        let shuffledQuestions = allQuestions.shuffled()
        let selectedQuestions = Array(shuffledQuestions.prefix(numberOfQuestions))
        questions = selectedQuestions // Use original questions directly
        
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
        // No need to reset isAnswered or isAnsweredCorrectlyRaw since we're not using them
        progressResult = nil
    }
} // TestViewModel
