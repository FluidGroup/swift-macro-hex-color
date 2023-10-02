import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(HexColorMacroMacros)
import HexColorMacroMacros

let testMacros: [String: Macro.Type] = [
  "hexColor": HexToColorMacro.self,
  "hexRGB": HexToRGBMacro.self,
  "hexUIColorSRGB": HexToUIColorSRGBMacro.self,
  "hexUIColorP3": HexToUIColorP3Macro.self,
]
#endif

final class HexColorMacroTests: XCTestCase {
  func testMacro() throws {
    #if canImport(HexColorMacroMacros)
    assertMacroExpansion(
      """
      #hexColor("#FFFFFF", opacity: 1)
      """,
      expandedSource: """
        Color(.sRGB, red: 1.0, green: 1.0, blue: 1.0, opacity: 1)
        """,
      macros: testMacros
    )
    #else
    throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
  }

  func testHexToUIColorSRGB() throws {

#if canImport(HexColorMacroMacros)
    assertMacroExpansion(
      """
      #hexUIColorSRGB("#FFFFFF", opacity: 1)
      """,
      expandedSource: """
        UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        """,
      macros: testMacros
    )
#else
    throw XCTSkip("macros are only supported when running tests for the host platform")
#endif

  }

  func testHexToUIColorP3() throws {
#if canImport(HexColorMacroMacros)
    assertMacroExpansion(
      """
      #hexUIColorP3("#FFFFFF", opacity: 1)
      """,
      expandedSource: """
        UIColor(displayP3Red: 1.0, green: 1.0, blue: 1.0, alpha: 1)
        """,
      macros: testMacros
    )
#else
    throw XCTSkip("macros are only supported when running tests for the host platform")
#endif

  }


  func testHexToRGB() throws {

#if canImport(HexColorMacroMacros)
    assertMacroExpansion(
      """
      #hexRGB("#0600FF")
      """,
      expandedSource: """
        (r: 0.023529411764705882, g: 0.0, b: 1.0)
        """,
      macros: testMacros
    )
#else
    throw XCTSkip("macros are only supported when running tests for the host platform")
#endif


  }
}
