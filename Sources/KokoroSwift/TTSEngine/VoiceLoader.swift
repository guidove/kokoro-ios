//
//  KokoroSwift — Voice loading helper
//
import Foundation
import MLX
import MLXUtilsLibrary

/// Helper to load voices and generate audio without exposing MLXArray to the app
public final class VoiceLoader {
    private var voices: [String: MLXArray] = [:]

    public init() {}

    /// Load voices from a .npz file
    public func loadVoices(from url: URL) -> [String] {
        voices = NpyzReader.read(fileFromPath: url) ?? [:]
        return voices.keys.map { String($0.split(separator: ".")[0]) }.sorted()
    }

    /// Check if a voice is available
    public func hasVoice(_ name: String) -> Bool {
        let key = name.hasSuffix(".npy") ? name : name + ".npy"
        return voices[key] != nil
    }

    /// Get the MLXArray for a voice (for use with KokoroTTS.generateAudio)
    public func voiceEmbedding(for name: String) -> MLXArray? {
        let key = name.hasSuffix(".npy") ? name : name + ".npy"
        return voices[key]
    }

    /// Number of loaded voices
    public var count: Int { voices.count }

    /// All available voice names (without .npy extension)
    public var voiceNames: [String] {
        voices.keys.map { String($0.split(separator: ".")[0]) }.sorted()
    }

    /// Clear MLX GPU memory cache to prevent OOM on iPhone
    public static func clearGPUCache() {
        GPU.clearCache()
    }
}
