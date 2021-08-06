//
//  ContentView.swift
//  fourthProject
//
//  Created by Артем Хлопцев on 15.07.2021.
//

import SwiftUI
struct FlagImage: View {
    var fileName: String
    var body: some View {
        Image(fileName).renderingMode(.original).frame(width: 250, height: 130).clipShape(Capsule()).overlay(Capsule().stroke(Color.black, lineWidth: 2)).shadow(color: Color.black,radius: 5)
    }
    
}
struct ContentView: View {
    @State private var countries = ["Bangladesh", "Brazil", "Canada", "Germany", "Greece", "Russia", "Sweden", "UK", "USA"].shuffled()
    @State private var correct = Int.random(in: 0...2)
    @State private var result = 0
    @State private var shown = false
    @State private var scoreTitle = ""
    @State private var wrong = 0
    @State private var animationAmount = 0.0
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.init(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),.init(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), Color.blue, .orange, .purple,.blue,.purple]), center: .bottomTrailing, startRadius: 90, endRadius: 5500)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    if shown != true {
                        Text("Choose a flag of: ")
                            .font(.title)
                            .fontWeight(.medium)
                            .padding(.top,50)
                    } else {
                        Text("").font(.title)
                            .fontWeight(.medium)
                            .padding(.top,50)
                    }
                    Text(countries[correct])
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                        .padding(.bottom,30)
                }.foregroundColor(.white)
                
                ForEach(0..<3) {number in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            self.tapped(number)
                            self.animationAmount += 360
                        }
                        
                    }) {
                        FlagImage(fileName: self.countries[number])
                        
                    }.rotation3DEffect(.degrees(number == self.correct ? animationAmount : 0.0), axis: (x: 0, y: 1, z: 0)).opacity(number != correct && shown == true ? 0.25 : 1)
                }
                Spacer(minLength: 10)
                ZStack {
                    RoundedRectangle(cornerRadius: 25).strokeBorder(Color.black, lineWidth: 0.3).shadow(radius: 5).frame(width: 300, height: 120)
                Text("Total: \(result)").font(.largeTitle).fontWeight(.black).foregroundColor(.white)
                }
                Spacer()
            }
        }.alert(isPresented: $shown) {
            if scoreTitle == "Correct" {
                return Alert(title: Text(scoreTitle), message: Text("Your score \(result), All right"), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            } else {
                return Alert(title: Text(scoreTitle), message: Text("That's flag of \(countries[wrong])"), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            }
        }
    }
    func askQuestion() {
        countries.shuffle()
        correct = Int.random(in: 0...2)
    }
    func tapped(_ number: Int) {
        if number == correct {
            scoreTitle = "Correct"
            result += 1
            
        } else {
            scoreTitle = "Wrong"
            result -= 1
            wrong = number
        }
        self.shown = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
