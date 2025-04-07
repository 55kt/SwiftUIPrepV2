//
//  ProgressViewModel.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

class ProgressViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var progressResult: ProgressResult?
    
    // MARK: - Private Properties
    private var viewContext: NSManagedObjectContext?
    
    // MARK: - Computed Properties
    // Calculates the number of correct answers from the current progress result
    var correctAnswers: Int {
        guard let progressResult = progressResult,
              let questionResults = progressResult.questionResults as? Set<QuestionResult> else {
            return 0
        }
        return questionResults.filter { $0.isAnsweredCorrectly }.count
    }
    
    // Calculates the percentage of correct answers for the current progress result
    var scorePercentage: Double {
        guard progressResult?.totalQuestions ?? 0 > 0 else { return 0.0 }
        return (Double(correctAnswers) / Double(progressResult?.totalQuestions ?? 1)) * 100
    }
    
    // Determines the medal details based on the percentage of correct answers
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
    // Sets up the view context for Core Data operations
    func setup(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    // Saves the test progress to Core Data
    func saveTestProgress(questions: [Question], duration: String) {
        guard let viewContext = viewContext else { return }
        
        let progressResult = ProgressResult(context: viewContext)
        progressResult.id = UUID()
        progressResult.date = Date()
        progressResult.totalQuestions = Int32(questions.count)
        progressResult.duration = duration
        
        for question in questions {
            let questionResult = QuestionResult(context: viewContext)
            questionResult.isAnsweredCorrectly = question.isAnsweredCorrectly ?? false
            questionResult.question = question
            questionResult.progressResult = progressResult
            progressResult.addToQuestionResults(questionResult)
        }
        
        progressResult.correctAnswers = Int32(progressResult.questionResults?.filter { ($0 as! QuestionResult).isAnsweredCorrectly }.count ?? 0)
        
        do {
            try viewContext.save()
        } catch {
            print("❌ Error saving test progress: \(error.localizedDescription)") // delete this code in final commit
        }
        
        self.progressResult = progressResult
    }
    
    // Calculates the percentage of correct answers for a progress result
    func calculateCorrectPercentage(for progressResult: ProgressResult) -> Double {
        guard progressResult.totalQuestions > 0 else { return 0.0 }
        return (Double(progressResult.correctAnswers) / Double(progressResult.totalQuestions)) * 100
    }
    
    // Determines the medal color based on the percentage of correct answers
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
    
    // Deletes all progress results
    func deleteAllProgressResults(progressResults: [ProgressResult]) {
        guard let viewContext = viewContext else { return }
        for progressResult in progressResults {
            viewContext.delete(progressResult)
        }
        do {
            try viewContext.save()
        } catch {
            print("❌ Error resetting progress: \(error)") // delete this code in final commit
        }
    }
} // ProgressViewModel
