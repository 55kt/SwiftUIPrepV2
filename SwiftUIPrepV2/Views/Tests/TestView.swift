//
//  TestView.swift
//  SwiftUIPrepV2
//
//  Created by Vlad on 27/2/25.
//

import SwiftUI

struct TestView: View {
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: TestViewModel
    @State private var isShowingStopAlert: Bool = false
    @State private var shouldNavigateToResults: Bool = false // State to control navigation
    
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
        let viewModel = TestViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
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
                        TimeRemainingHolder(timeDuration: viewModel.testDuration)
                            .padding()
                        
                        if !viewModel.questions.isEmpty && !viewModel.isTestFinished {
                            // Display the current question
                            VStack(spacing: 20) {
                                ProgressBarLine(
                                    currentQuestion: viewModel.currentQuestionIndex + 1,
                                    totalQuestions: viewModel.questions.count
                                )
                                
                                Text(viewModel.questions[viewModel.currentQuestionIndex].question)
                                    .font(.title2)
                                    .fontWeight(.heavy)
                                
                                // Display answer options
                                ForEach(viewModel.answers, id: \.self) { answer in
                                    AnswerCellButton(
                                        isCorrect: viewModel.showCorrectAnswer ? (answer == viewModel.questions[viewModel.currentQuestionIndex].correctAnswer) : nil,
                                        answerText: answer
                                    ) {
                                        viewModel.selectAnswer(answer, for: viewModel.questions[viewModel.currentQuestionIndex])
                                    }
                                }// ForEach
                                
                                Spacer()
                            } // VStack
                            .padding()
                        } else if viewModel.questions.isEmpty {
                            Text("No questions available")
                                .font(.title2)
                                .foregroundStyle(.gray)
                                .padding()
                        }// if - else
                    } // VStack
                } // ScrollView
                .navigationTitle("Current Test")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(isPresented: $shouldNavigateToResults) {
                    // Navigate to ResultTestView when the test is finished
                    ResultTestView(
                        totalQuestions: viewModel.questions.count,
                        correctAnswers: viewModel.correctAnswers,
                        testDuration: viewModel.testDuration,
                        progressResult: viewModel.progressResult
                    )// ResultTestView
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
                        }
                    }
                } // toolbar
                .alert("Stop Test?", isPresented: $isShowingStopAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Stop", role: .destructive) {
                        viewModel.stopTest()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                } message: {
                    Text("Are you sure you want to stop the test? All progress will be lost.")
                } // alert
                .onAppear {
                    // Setup the test when the view appears
                    viewModel.setupTest(
                        numberOfQuestions: numberOfQuestions,
                        allQuestions: allQuestions,
                        viewContext: viewContext
                    )
                }// onAppear
                .onChange(of: viewModel.isTestFinished) {oldValue, newValue in
                    print("🔍 isTestFinished changed to: \(newValue)")
                    if newValue {
                        shouldNavigateToResults = true
                    }
                }// onChange
            } // ZStack
        } // NavigationStack
    } // body
} // View

// MARK: - Preview
#Preview {
    TestView(numberOfQuestions: 10)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
