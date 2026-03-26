//
//  Kokoro-tts-lib — extended with multilingual support
//
import Foundation

/// Supported languages for text-to-speech synthesis.
public enum Language: String, CaseIterable {
  case none = ""
  case enUS = "en-us"
  case enGB = "en-gb"
  case ja = "ja"
  case zh = "zh"
  case es = "es"
  case fr = "fr"
  case hi = "hi"
  case it = "it"
  case pt = "pt-br"
}
