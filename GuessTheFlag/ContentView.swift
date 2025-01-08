import SwiftUI

struct FlagImage: View {
    var country: String

    var body: some View {
        Image(country)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct RotateModifier: ViewModifier {
    let amount: Double

    func body(content: Content) -> some View {
        content.rotation3DEffect(.degrees(amount), axis: (x: 0, y: 1, z: 0))
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var currentScore = 0
    @State private var wrongAns = ""
    @State private var resetFlag = false
    @State private var count = 0
    @State private var rotationAmount = [0.0, 0.0, 0.0]
    @State private var tappedFlag = -1
    @State private var opacityAmount = [1.0, 1.0, 1.0]
    @State private var scaleAmount = [1.0,1.0,1.0]

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    func flagTapped(_ number: Int) {
        count += 1
        if count >= 8 {
            resetFlag = true
        } else {
            showingScore = true
        }

        if number == correctAnswer {
            currentScore += 1
            scoreTitle = "Correct"
            wrongAns = ""
        } else {
            currentScore -= 1
            wrongAns = countries[number]
            scoreTitle = "Wrong"
        }

        tappedFlag = number

        withAnimation {
            for i in 0..<3 {
                opacityAmount[i] = i == tappedFlag ? 1.0 : 0.25
                
                scaleAmount[i] = i == tappedFlag ? 1.0 : 0.8
            }
            rotationAmount[tappedFlag] += 360
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        tappedFlag = -1
        opacityAmount = [1.0, 1.0, 1.0]
        rotationAmount = [0.0, 0.0, 0.0]
        scaleAmount = [1.0, 1.0, 1.0]
    }

    func resetGame() {
        count = 0
        currentScore = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        resetFlag = false
        opacityAmount = [1.0, 1.0, 1.0]
        rotationAmount = [0.0, 0.0, 0.0]
        scaleAmount = [1.0, 1.0, 1.0]
    }

    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
                ],
                center: .top,
                startRadius: 200,
                endRadius: 700
            )
            .ignoresSafeArea()

            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                                .opacity(opacityAmount[number])
                                .rotation3DEffect(.degrees(rotationAmount[number]), axis: (x: 0, y: 1, z: 0))
                                .scaleEffect(scaleAmount[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(currentScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                if scoreTitle == "Correct" {
                    Text("Your score is \(currentScore)")
                } else {
                    Text("That's the flag of \(wrongAns). Your score is \(currentScore)")
                }
            }
            .alert("Game Over", isPresented: $resetFlag) {
                Button("Reset", action: resetGame)
            } message: {
                Text("Your final score is \(currentScore)")
            }
        }
    }
}

#Preview {
    ContentView()
}
