import AVFoundation
import Combine

class GlobalSound: ObservableObject {
    @Published var soundManager: SoundManager = SoundManager.shared
}

enum VolumeType {
    case main
    case music
    case effects
}

class SoundManager: ObservableObject {
    static let shared = SoundManager()
    
    private var mainAudioPlayer: AVAudioPlayer?
    private var musicAudioPlayer: AVAudioPlayer?
    private var effectsAudioPlayer: AVAudioPlayer?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var mainVolume: Double = 0.5 {
        didSet {
            updateVolume(for: .main)
        }
    }
    @Published var musicVolume: Double = 0.5 {
        didSet {
            updateVolume(for: .music)
        }
    }
    @Published var effectsVolume: Double = 0.5 {
        didSet {
            updateVolume(for: .effects)
        }
    }

    private init() {
        
        // Set the audio session category to allow sound to play in silent mode
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
        
        // Subscribe to changes in volume properties
        $mainVolume
            .sink { [weak self] _ in
                self?.updateAllVolumes()
            }
            .store(in: &cancellables)
        
        $musicVolume
            .sink { [weak self] _ in
                self?.updateVolume(for: .music)
            }
            .store(in: &cancellables)
        
        $effectsVolume
            .sink { [weak self] _ in
                self?.updateVolume(for: .effects)
            }
            .store(in: &cancellables)
    }
    
    func playSound(named soundName: String, withExtension ext: String = "mp3", loop: Bool = false, volumeType: VolumeType) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: ext) else {
            print("Sound file not found: \(soundName).\(ext)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            if loop {
                player.numberOfLoops = -1
            }
            setVolume(for: volumeType, player: player)
            player.play()
            
            switch volumeType {
            case .main:
                mainAudioPlayer = player
            case .music:
                musicAudioPlayer = player
            case .effects:
                effectsAudioPlayer = player
            }
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }
    
    func stopSound(volumeType: VolumeType) {
        switch volumeType {
        case .main:
            mainAudioPlayer?.stop()
        case .music:
            musicAudioPlayer?.stop()
        case .effects:
            effectsAudioPlayer?.stop()
        }
    }
    
    private func setVolume(for volumeType: VolumeType, player: AVAudioPlayer) {
        switch volumeType {
        case .main:
            player.volume = Float(mainVolume)
        case .music:
            player.volume = Float(musicVolume * mainVolume)
        case .effects:
            player.volume = Float(effectsVolume * mainVolume)
        }
    }
    
    func updateVolume(for volumeType: VolumeType) {
        switch volumeType {
        case .main:
            mainAudioPlayer?.volume = Float(mainVolume)
            updateAllVolumes()
        case .music:
            musicAudioPlayer?.volume = Float(musicVolume * mainVolume)
        case .effects:
            effectsAudioPlayer?.volume = Float(effectsVolume * mainVolume)
        }
    }
    
    private func updateAllVolumes() {
        musicAudioPlayer?.volume = Float(musicVolume * mainVolume)
        effectsAudioPlayer?.volume = Float(effectsVolume * mainVolume)
    }
}
