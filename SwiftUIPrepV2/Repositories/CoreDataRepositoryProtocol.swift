//
//  CoreDataRepositoryProtocol.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 14/4/25.
//

import CoreData

protocol CoreDataRepositoryProtocol {
    var viewContext: NSManagedObjectContext { get }
    
    func saveProgressResult(_ progressResult: ProgressResult)
    func saveQuestionResult(_ questionResult: QuestionResult, to progressResult: ProgressResult)
    func deleteProgressResults(_ progressResults: [ProgressResult])
    func saveContext()
}

class CoreDataRepository: CoreDataRepositoryProtocol {
    let viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func saveProgressResult(_ progressResult: ProgressResult) {
        progressResult.correctAnswers = Int32(progressResult.questionResults?.filter { ($0 as? QuestionResult)?.isAnsweredCorrectly == true }.count ?? 0)
        
        do {
            try viewContext.save()
            print("🔍 CoreDataRepository: saveProgressResult - Saved progress with \(progressResult.correctAnswers) correct answers")
        } catch {
            print("❌ CoreDataRepository: saveProgressResult - Error: \(error)")
        }
    }
    
    func saveQuestionResult(_ questionResult: QuestionResult, to progressResult: ProgressResult) {
        questionResult.progressResult = progressResult
        progressResult.addToQuestionResults(questionResult)
        
        do {
            try viewContext.save()
            print("🔍 CoreDataRepository: saveQuestionResult - Saved question result for question: \(questionResult.question?.question ?? "nil"), isAnsweredCorrectly: \(questionResult.isAnsweredCorrectly)")
        } catch {
            print("❌ CoreDataRepository: saveQuestionResult - Error: \(error)")
        }
    }
    
    func deleteProgressResults(_ progressResults: [ProgressResult]) {
        print("🔍 CoreDataRepository: deleteProgressResults - Deleting \(progressResults.count) progress results")
        
        for progressResult in progressResults {
            if let questionResults = progressResult.questionResults as? Set<QuestionResult> {
                for questionResult in questionResults {
                    viewContext.delete(questionResult)
                }
            }
            viewContext.delete(progressResult)
        }
        
        do {
            try viewContext.save()
            print("🔍 CoreDataRepository: deleteProgressResults - Successfully saved context after deletion")
        } catch {
            print("❌ CoreDataRepository: deleteProgressResults - Error: \(error)")
        }
        
        viewContext.refreshAllObjects()
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("❌ CoreDataRepository: saveContext - Error: \(error)")
        }
    }
}
