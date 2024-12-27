//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Anurag on 17/12/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false;
    @State private var scoreTilte = ""
    @State private var currentScore = 0;
    @State private var wrongAns = ""
    @State private var resetFlag = false;
    @State private var count = 0;
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    func flagTapped(_ number:Int){
        count+=1;
        if(count >= 8){
            resetFlag = true;
        }
        else{
            showingScore = true
        }
        if number == correctAnswer{
            currentScore+=1;
            scoreTilte = "Correct"
            wrongAns=""
        } else {
            currentScore-=1;
            wrongAns = countries[number]
            scoreTilte = "Wrong"
        }
        
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame(){
              count = 0;
              currentScore = 0
              countries.shuffle()
              correctAnswer = Int.random(in: 0...2)
              resetFlag = false
    }
    
    var body: some View {
        
        ZStack{
           
            RadialGradient(stops:[
                .init(color: Color(red:0.1,green:0.2,blue:0.45), location: 0.3),
                .init(color: Color(red:0.76,green:0.15,blue:0.26), location: 0.3),
            ],center:.top, startRadius: 200,endRadius: 700)
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing:15){
                    VStack{
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                           
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            flagTapped(number)
                        } label:{
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                        }.alert(scoreTilte,isPresented: $showingScore){
                            Button("Continue",action:askQuestion)
                        } message: {
                            if(scoreTilte == "Correct"){
                                Text("Your score is \(currentScore)")
                            }
                            else{
                                Text("Thats the flag of \(wrongAns) Your score is \(currentScore)")
                            }
                            
                        }
                        .alert("Game Over",isPresented: $resetFlag){
                            Button("Reset",action:resetGame)
                        } message:{
                            Text("Your final score is \(currentScore)")
                        }
                        
                    }
                }
                .frame(maxWidth:.infinity)
                .padding(.vertical,20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius:20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(currentScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                    
                
                Spacer()
                
            }
            .padding()
            
            
        }
       
       
    }
   
}

#Preview {
    ContentView()
}
