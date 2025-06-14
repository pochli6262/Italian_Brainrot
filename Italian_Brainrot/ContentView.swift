import SwiftUI
import AVFoundation

// MARK: - Model
struct CharacterCard: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let audioFile: String
    let script: String
}

// MARK: - Audio Player
class AudioPlayer: ObservableObject {
    private var player: AVAudioPlayer?

    func playSound(named fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
            print("Audio file \(fileName).mp3 not found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }

    func stop() {
        player?.stop()
    }
}

// MARK: - ViewModel
class BrainRotViewModel: ObservableObject {
    @Published private(set) var cards: [CharacterCard] = [
        CharacterCard(
            name: "Tralalero Tralala",
            imageName: "tralalero_tralala",
            audioFile: "tralalero_tralala",
            script: "Trallallero Trallalla, porco dio e porco Allah. Ero con il mio fottuto figlio merdardo a giocare a Fortnite, quando a un punto arriva mia nonna, Ornella Leccacappella, a avvisarci che quello stronzo di Burger ci aveva invitato a cena per mangiare un purè di cazzi."
        ),
        CharacterCard(
            name: "Bombardiro Crocodilo",
            imageName: "bombardiro_crocodilo",
            audioFile: "bombardiro_crocodilo",
            script: "Bombardillo Coccodrillo, un fottuto alligatore volante, che vola e bombarda i bambini a Gaza, in Palestina. Non crede in Allah e ama le bombe. Si nutre dello spirito di tua madre. E se hai tradotto tutto questo, allora sei uno stronzo. Non rompere la battuta, prostituta."
        ),
        CharacterCard(
            name: "Tung Tung Tung Sahur",
            imageName: "tung_tung_sahur",
            audioFile: "tung_tung_sahur",
            script: "Tung tung tung tung sahur. Anomali mengerikan yang hanya keluar pada sahur. Konon katanya kalau ada orang yang dipanggil Sahur tiga kali dan tidak nyaut maka makhluk ini datang di rumah kalian. Hi seremnya. Tung tung ini biasanya bersuara layaknya pukulan kentungan seperti ini. Share ke teman kalian yang susah Sahur."
        ),
        CharacterCard(
            name: "Brr Brr Patapim",
            imageName: "brr_brr_patapim",
            audioFile: "brr_brr_patapim",
            script: "Brr brrr Patapim, il mio cappello è pieno di Slim! Nel bosco fitto e misterioso viveva un essere assai curioso. Con radici intrecciate e gambe incrociate, mani sottili, braccia agitate. Il suo naso lungo come un prosciutto, un po' babbuino, un po' cespugliotto. Si chiamava Patapim, oh che strano, e parlava Italiano… ma con accento arcanol. Un giorno trovo un cappello dorato, \"Perfetto!\" grido, \"che bel risultato!\" Ma dentro c'era Slim, il ranocchio blu, che faceva \"Brrr brrr!\" senza un perche in piu. Patapim piangeva: \"Mio caro cappello! Ora c'e Slim, che guaio, che duello!\" Saltave, rideva, si disperava, ma il ranocchio mai se ne andava. Con fogile sui gomiti e muschio sul mento corse nel bosco spinto dal vento. Ando dal mago Tiramisu, chiedendo aluto con un gran \"Ciuu ciuu!\" Il mago rispose, mangiando un panino: \"Per togliere Slim, serve un palloncino!\" Cosi Patapim, con gran confusione, soffio nel pallone con emozione. Slim volo, con un grande BOOM, sparendo nel cielo come un bel fungo di fumo! Ora Patapim balla nel vento."
        ),
        CharacterCard(
            name: "Cappuccino Assassino",
            imageName: "cappuccino_assassino",
            audioFile: "cappuccino_assassino",
            script: "Capu capu cappuccino, assassino assasini! Cappuccini questo killer furtivo si infiltra tra i nemici approfittando della notte attento odiatore di caffè senondeiona tastari capuchino alma tino amelio noincro charqeusto tidso."
        ),
    ]
    @Published var currentIndex: Int = 0

    var currentCard: CharacterCard { cards[currentIndex] }

//    隨機
    func randomCard() {
        guard cards.count > 1 else { return }
        var newIndex: Int
        repeat { newIndex = Int.random(in: 0..<cards.count) }
        while newIndex == currentIndex
        currentIndex = newIndex
    }

    func nextCard() { currentIndex = (currentIndex + 1) % cards.count }
    func previousCard() { currentIndex = (currentIndex - 1 + cards.count) % cards.count }
}

// MARK: - ContentView
struct ContentView: View {
    @StateObject private var viewModel = BrainRotViewModel()
    @StateObject private var audioPlayer = AudioPlayer()
    @State private var isFlipped = false

    private let cardSize = CGSize(width: 340, height: 420)
    private let backHeight: CGFloat = 360

    var body: some View {
        ZStack {
            // 背景漸層：綠-白-黃配色
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.3), Color.white, Color.yellow.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                ZStack {
                    let card = viewModel.currentCard

                    // 卡片視圖
                    ZStack {
                        if !isFlipped {
                            VStack(spacing: 20) {
                                // 顯示原始完整圖片
                                Image(card.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)

                                Text(card.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)

                                Button(action: { audioPlayer.playSound(named: card.audioFile) }) {
                                    Label("播放語音", systemImage: "play.fill")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        } else {
                            ScrollView {
                                Text(card.script)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                            }
                            .frame(width: cardSize.width - 40, height: backHeight - 40)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        }
                    }
                    .frame(width: cardSize.width, height: isFlipped ? backHeight : cardSize.height)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.green, Color.white, Color.yellow]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 4
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    )
                    .rotation3DEffect(
                        .degrees(isFlipped ? 180 : 0),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            isFlipped.toggle()
                        }
                    }
                }

                Spacer()

                HStack(spacing: 40) {
                    Button(action: previous) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.green)
                    }
                    Button(action: random) {
                        Text("隨機")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    Button(action: next) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.yellow)
                    }
                }
                .padding(.bottom)
            }
            .padding()
        }
    }

    // Actions
    private func random() {
        audioPlayer.stop()
        withAnimation { viewModel.randomCard(); isFlipped = false }
        audioPlayer.playSound(named: viewModel.currentCard.audioFile)
    }
    private func next() {
        audioPlayer.stop()
        viewModel.nextCard(); isFlipped = false
        audioPlayer.playSound(named: viewModel.currentCard.audioFile)
    }
    private func previous() {
        audioPlayer.stop()
        viewModel.previousCard(); isFlipped = false
        audioPlayer.playSound(named: viewModel.currentCard.audioFile)
    }
}

#Preview {
    ContentView()
}
