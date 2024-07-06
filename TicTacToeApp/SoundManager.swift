import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(named soundName: String, withExtension ext: String = "mp3", loop: Bool = false) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else {
            print("Sound file not found: \(soundName).\(ext)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            if loop {
                audioPlayer?.numberOfLoops = -1
            }
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
    }
}
