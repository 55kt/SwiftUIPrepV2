//
//  TestView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI
import CoreData

struct TestView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var testViewModel: TestViewModel
    @State private var isShowingStopAlert: Bool = false
    @State private var shouldNavigateToResults: Bool = false
    
    @FetchRequest(
        entity: Question.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Question.question, ascending: true)],
        predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "category != nil"),
            NSPredicate(format: "isAnswered == false")
        ])
    ) private var allQuestions: FetchedResults<Question>
    
    // MARK: - Initialization
    init(numberOfQuestions: Int) {
        self.numberOfQuestions = numberOfQuestions
    }
    
    private let numberOfQuestions: Int
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Image("hourglass-icon")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.3)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        TimeRemainingHolder(timeDuration: testViewModel.testDuration)
                            .padding()
                        
                        if !testViewModel.questions.isEmpty && !testViewModel.isTestFinished {
                            // Display the current question
                            VStack(spacing: 20) {
                                ProgressBarLine(
                                    currentQuestion: testViewModel.currentQuestionIndex + 1,
                                    totalQuestions: testViewModel.questions.count
                                )
                                
                                Text(testViewModel.questions[testViewModel.currentQuestionIndex].question)
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                
                                // Display answer options
                                ForEach(testViewModel.answers, id: \.self) { answer in
                                    AnswerCellButton(
                                        isCorrect: testViewModel.showCorrectAnswer ? (answer == testViewModel.questions[testViewModel.currentQuestionIndex].correctAnswer) : nil,
                                        answerText: answer
                                    ) {
                                        testViewModel.selectAnswer(answer, for: testViewModel.questions[testViewModel.currentQuestionIndex])
                                    }
                                } // ForEach
                                
                                Spacer()
                            } // VStack
                            .padding()
                        } else if testViewModel.questions.isEmpty {
                            Text("No questions available")
                                .font(.title2)
                                .foregroundStyle(.gray)
                                .padding()
                        } // if - else
                    } // VStack
                } // ScrollView
                // Loading indicator
                
                .navigationTitle("Current Test")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $shouldNavigateToResults) {
                    // Navigate to ResultTestView when the test is finished
                    ResultTestView(
                        totalQuestions: testViewModel.questions.count,
                        correctAnswers: testViewModel.correctAnswers,
                        testDuration: testViewModel.testDuration,
                        progressResult: testViewModel.progressResult
                    )
                    .environmentObject(testViewModel)
                    .navigationBarBackButtonHidden(true)
                } // navigationDestination
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(role: .destructive) {
                            isShowingStopAlert = true
                        } label: {
                            Image(systemName: "wrongwaysign.fill")
                                .font(.title2)
                                .bold()
                        } // Button
                    } // ToolbarItem
                } // toolbar
                .alert("Stop Test?", isPresented: $shouldNavigateToResults) {
                    Button("Cancel", role: .cancel) {}
                    Button("Stop", role: .destructive) {
                        testViewModel.stopTest()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    } // Button
                } message: {
                    Text("Are you sure you want to stop the test? All progress will be lost.")
                } // alert
                .onAppear {
                    // Setup the test when the view appears
                    testViewModel.setupTest(
                        numberOfQuestions: numberOfQuestions,
                        allQuestions: allQuestions,
                        viewContext: viewContext
                    )
                } // onAppear
                .onChange(of: testViewModel.isTestFinished) {oldValue, value in
                    if value {
                        shouldNavigateToResults = true
                    }
                } // onChange
            } // ZStack
        } // NavigationStack
    } // body
} // View

// MARK: - Preview
#Preview {
    TestView(numberOfQuestions: 10)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(TestViewModel())
} // Preview
