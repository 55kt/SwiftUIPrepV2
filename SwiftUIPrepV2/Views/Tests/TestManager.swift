//
//  TestManager.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/3/25.
//

import SwiftUI
import CoreData

class TestManager: ObservableObject {
    // MARK: - Properties
    @Published var currentQuestionIndex: Int = 0
    @Published var questions: [Question] = []
    @Published var answers: [String] = []
    @Published var selectedAnswer: String? = nil
    @Published var showCorrectAnswer: Bool = false
    @Published var testStartTime: Date = Date()
    @Published var testDuration: String = "00:00"
    @Published var isShowingStopAlert: Bool = false
    @Published var isTestFinished: Bool = false
    
    private var timer: Timer?
    private var numberOfQuestions: Int = 0
    private var allQuestions: FetchedResults<Question>?
    private var viewContext: NSManagedObjectContext?
    
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
    
    // MARK: - Private Methods
    private func startTest() {
        guard let allQuestions = allQuestions else { return }
        
        // Загружаем все вопросы и перемешиваем их
        let shuffledQuestions = allQuestions.shuffled()
        
        // Берём нужное количество вопросов
        questions = Array(shuffledQuestions.prefix(numberOfQuestions))
        
        // Проверяем, что вопросы есть
        if questions.isEmpty {
            return
        }
        
        // Инициализируем первый вопрос
        loadQuestion()
        
        // Запускаем таймер
        testStartTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let elapsedTime = Int(Date().timeIntervalSince(self.testStartTime))
            let minutes = elapsedTime / 60
            let seconds = elapsedTime % 60
            self.testDuration = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    private func loadQuestion() {
        guard currentQuestionIndex < questions.count else { return }
        let question = questions[currentQuestionIndex]
        
        // Рандомизируем варианты ответа
        var answerOptions = [question.correctAnswer]
        if let incorrectAnswers = question.incorrectAnswers {
            answerOptions.append(contentsOf: incorrectAnswers.prefix(2)) // Берём только 2 неправильных ответа
        }
        answers = answerOptions.shuffled()
        
        // Сбрасываем состояние
        selectedAnswer = nil
        showCorrectAnswer = false
    }
    
    private func resetTestProgress() {
        // Сбрасываем прогресс текущего теста
        for question in questions {
            question.isAnswered = false
            question.isAnsweredCorrectlyRaw = nil
        }
        do {
            try viewContext?.save()
            print("🗑️ Test progress reset successfully 🗑️")
        } catch {
            print("❌ Error resetting test progress: \(error) ❌")
        }
    }
}
