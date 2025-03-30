//
//  TestViewModel.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

class TestViewModel: ObservableObject {
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
    @Published var progressResult: ProgressResult? // Для хранения результатов теста
    
    private var timer: Timer?
    private var numberOfQuestions: Int = 0
    private var allQuestions: FetchedResults<Question>?
    private var viewContext: NSManagedObjectContext?
    
    // Количество правильных ответов
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
        
        // Сохраняем результат ответа
        question.isAnswered = true
        question.isAnsweredCorrectly = (answer == question.correctAnswer)
        do {
            try viewContext?.save()
            print("💾 Saved answer for question: \(question.question), correct: \(question.isAnsweredCorrectly ?? false) 💾")
        } catch {
            print("❌ Error saving answer: \(error) ❌")
        }
        
        // Переходим к следующему вопросу с задержкой
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.currentQuestionIndex < self.questions.count - 1 {
                self.currentQuestionIndex += 1
                self.loadQuestion()
            } else {
                // Тест завершён, сохраняем прогресс
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
        progressResult.totalQuestions = Int32(numberOfQuestions)
        progressResult.correctAnswers = Int32(correctAnswers)
        progressResult.duration = testDuration
        
        // Добавляем вопросы в отношение
        for question in questions {
            progressResult.addToQuestions(question)
        }
        
        do {
            try viewContext.save()
            self.progressResult = progressResult // Сохраняем объект ProgressResult
            print("💾 Saved test progress: \(correctAnswers)/\(numberOfQuestions), duration: \(testDuration) 💾")
        } catch {
            print("❌ Error saving test progress: \(error) ❌")
        }
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
