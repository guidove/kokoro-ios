//
//  KokoroSwift
//

#if canImport(eSpeakNGLib)

import Foundation
import eSpeakNGLib
import MLXUtilsLibrary

/// A G2P processor that uses the eSpeak NG library for phonemization.
final class eSpeakNGG2PProcessor : G2PProcessor {
  private var eSpeakEngine: eSpeakNG?

  func setLanguage(_ language: Language) throws {
    eSpeakEngine = try eSpeakNG()

    if let language = eSpeakNG.Language(rawValue: language.rawValue), let eSpeakEngine {
      try eSpeakEngine.setLanguage(language: language)
    } else {
      throw G2PProcessorError.unsupportedLanguage
    }
  }

  func process(input: String) throws -> (String, [MToken]?) {
    guard let eSpeakEngine else { throw G2PProcessorError.processorNotInitialized }
    let phonemizedText = try eSpeakEngine.phonemize(text: input)
    return (phonemizedText, nil)
  }
}

#endif
