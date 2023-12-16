//
//  ContentView.swift
//  Challenge_2_RockPaperScissors
//
//  Created by Daniel Freire on 12/15/23.
//

import SwiftUI

struct LargeTextModifier: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
    }
}

extension View {
    func largeText(size: CGFloat = 150) -> some View {
        modifier(LargeTextModifier(size: size))
    }
}

struct ContentView: View {
    let possibleMoves = ["🪨", "📄", "✂️"]
    @State private var appChoice = "🪨"
    @State private var shouldWin = Bool.random()
    @State private var score = 0
    @State private var turn = 1
    @State private var myChoice = ""
    @State private var isCorrect = false
    @State private var showingScore = false
    
    var alertMessage: String {
        if turn == 10 {
            return "Your score is \(score)"
        }
        if shouldWin {
            return isCorrect ? "\(myChoice) > \(appChoice)" : "\(appChoice) > \(myChoice)"
        } else {
            return isCorrect ? "\(appChoice) > \(myChoice)" : "\(myChoice) > \(appChoice)"
        }
    }
    
    var body: some View {
        VStack {
            Text("Turn \(turn)")
            Text("Score \(score)")
            Text(appChoice)
                .largeText()
            Text("You must \(shouldWin ? "win" : "loose")")
            Spacer()
            Text("Possible moves")
            ForEach(possibleMoves, id: \.self) { move in
                Button(move) {
                    makeMove(move: move)
                }
                .largeText(size: 100)
            }
            Spacer()
        }
        .alert(isCorrect ? "Correct" : "Wrong", isPresented: $showingScore) {
            Button(turn == 10 ? "Restart" : "Continue", action: restartContinue)
        } message: {
            Text(alertMessage)
        }
    }
    
    func makeMove(move: String) {
        myChoice = move
        if shouldWin {
            if appChoice == "🪨" {
                isCorrect = move == "📄"
            }
            if appChoice == "✂️" {
                isCorrect = move == "🪨"
            }
            if appChoice == "📄" {
                isCorrect = move == "✂️"
            }
        } else {
            if appChoice == "🪨" {
                isCorrect = move != "📄"
            }
            if appChoice == "✂️" {
                isCorrect = move != "🪨"
            }
            if appChoice == "📄" {
                isCorrect = move != "✂️"
            }
        }
        setScore(isCorrect)
        showingScore = true
    }
    
    func setScore(_ isCorrect: Bool) {
        if isCorrect {
            score += 1
        } else {
            score = score == 0 ? score : score - 1
        }
    }
    
    func restartContinue() {
        appChoice = possibleMoves[Int.random(in: 0..<possibleMoves.count)]
        shouldWin.toggle()
        showingScore = false
        score = turn == 10 ? 0 : score
        turn = turn == 10 ? 1 : turn + 1
    }
}

#Preview {
    ContentView()
}
