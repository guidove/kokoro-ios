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
        // Strip all .npy extensions from keys for consistent lookup
        return voices.keys.map { stripNpy($0) }.sorted()
    }

    /// Check if a voice is available
    public func hasVoice(_ name: String) -> Bool {
        return findKey(for: name) != nil
    }

    /// Get the MLXArray for a voice (for use with KokoroTTS.generateAudio)
    public func voiceEmbedding(for name: String) -> MLXArray? {
        guard let key = findKey(for: name) else { return nil }
        return voices[key]
    }

    /// Number of loaded voices
    public var count: Int { voices.count }

    /// All available voice names (without .npy extension)
    public var voiceNames: [String] {
        voices.keys.map { stripNpy($0) }.sorted()
    }

    /// Clear MLX GPU memory cache to prevent OOM on iPhone
    public static func clearGPUCache() {
        GPU.clearCache()
    }

    /// Set MLX GPU cache limit in bytes. Essential on iOS to prevent jetsam kills.
    /// MLX docs recommend ~2MB for constrained devices.
    public static func setGPUCacheLimit(_ bytes: Int) {
        GPU.set(cacheLimit: bytes)
    }

    // MARK: - Private

    /// Find the actual dictionary key for a voice name, handling .npy/.npy.npy variations
    private func findKey(for name: String) -> String? {
        let bare = stripNpy(name)
        // Try: bare, bare.npy, bare.npy.npy (handles different npz formats)
        for candidate in [bare, bare + ".npy", bare + ".npy.npy"] {
            if voices[candidate] != nil { return candidate }
        }
        return nil
    }

    /// Remove all trailing .npy extensions
    private func stripNpy(_ name: String) -> String {
        var result = name
        while result.hasSuffix(".npy") {
            result = String(result.dropLast(4))
        }
        return result
    }
}
