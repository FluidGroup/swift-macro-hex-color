import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

enum MacroError: Error {
  case notFoundHex
  case failedToParseHex
}

func hexStringToRGB(_ hex: String) -> (r: Double, g: Double, b: Double)? {

  // https://stackoverflow.com/a/27203691

  var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

  if (cString.hasPrefix("#")) {
    cString.remove(at: cString.startIndex)
  }

  if ((cString.count) != 6) {
    return nil
  }

  var rgbValue: UInt64 = 0
  Scanner(string: cString).scanHexInt64(&rgbValue)

  return (
    Double((rgbValue & 0xFF0000) >> 16) / 255.0,
    Double((rgbValue & 0x00FF00) >> 8) / 255.0,
    Double(rgbValue & 0x0000FF) / 255.0
  )

}

func hexString(from stringLiteral: StringLiteralExprSyntax) -> String {
  guard case .stringSegment(let segment) = stringLiteral.segments.first else {
    fatalError("macro signature is wrong")
  }

  // easier way, no safety.
  let hexString = segment.content.text
  return hexString
}

public struct HexToRGBMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {

    guard let argument = node.argumentList.first?.expression else {
      fatalError("compiler bug: the macro does not have any arguments")
    }

    guard let stringLiteral = argument.as(StringLiteralExprSyntax.self) else {
      fatalError("macro signature is wrong")
    }

    // easier way, no safety.
    let hexString = hexString(from: stringLiteral)
    guard let rgb = hexStringToRGB(hexString) else {
      fatalError("invalid hex string")
    }

    #if false
    // using bit-pattern
    return "(r: Double(bitPattern: \(raw: rgb.r.bitPattern)), g: Double(bitPattern: \(raw: rgb.g.bitPattern)), b: Double(bitPattern: \(raw: rgb.b.bitPattern)))"
    #else
    return "(r: \(raw: rgb.r.description), g: \(raw: rgb.g.description), b: \(raw: rgb.b.description))"
    #endif
  }
}

public struct HexToColorMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {

    var args = node.argumentList.makeIterator()
    guard let arg_hex = args.next()?.expression else {
      context.addDiagnostics(from: MacroError.notFoundHex, node: node)
      return ""
    }
    let arg_opacity = argument(for: "opacity", in: node.argumentList)?.expression
    let arg_colorSpace = argument(for: "colorSpace", in: node.argumentList)?.expression

    guard let stringLiteral = arg_hex.as(StringLiteralExprSyntax.self) else {
      context.addDiagnostics(from: MacroError.notFoundHex, node: node)
      return ""
    }

    let hexString = hexString(from: stringLiteral)
    guard let rgb = hexStringToRGB(hexString) else {
      context.addDiagnostics(from: MacroError.failedToParseHex, node: node)
      return ""
    }

    return "Color(\(arg_colorSpace ?? ".sRGB"), red: \(raw: rgb.r.description), green: \(raw: rgb.g.description), blue: \(raw: rgb.b.description), opacity: \(arg_opacity ?? "1"))"
  }
}

public struct HexToUIColorSRGBMacro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {

    var args = node.argumentList.makeIterator()
    let arg_hex = args.next()!.expression
    let arg_opacity = argument(for: "opacity", in: node.argumentList)?.expression

    guard let stringLiteral = arg_hex.as(StringLiteralExprSyntax.self) else {
      fatalError("macro signature is wrong")
    }

    let hexString = hexString(from: stringLiteral)
    guard let rgb = hexStringToRGB(hexString) else {
      context.addDiagnostics(from: MacroError.failedToParseHex, node: node)
      return ""
    }

    return "UIColor(red: \(raw: rgb.r.description), green: \(raw: rgb.g.description), blue: \(raw: rgb.b.description), alpha: \(arg_opacity ?? "1"))"
  }
}

public struct HexToUIColorP3Macro: ExpressionMacro {
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) -> ExprSyntax {

    var args = node.argumentList.makeIterator()
    let arg_hex = args.next()!.expression
    let arg_opacity = argument(for: "opacity", in: node.argumentList)?.expression

    guard let stringLiteral = arg_hex.as(StringLiteralExprSyntax.self) else {
      fatalError("macro signature is wrong")
    }

    let hexString = hexString(from: stringLiteral)
    guard let rgb = hexStringToRGB(hexString) else {
      context.addDiagnostics(from: MacroError.failedToParseHex, node: node)
      return ""
    }

    return "UIColor(displayP3Red: \(raw: rgb.r.description), green: \(raw: rgb.g.description), blue: \(raw: rgb.b.description), alpha: \(arg_opacity ?? "1"))"
  }
}

func argument(for label: String, in arugments: LabeledExprListSyntax) -> LabeledExprListSyntax.Element? {
  arugments.first { $0.label?.description == label }
}

@main
struct HexColorMacroPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    HexToColorMacro.self,
    HexToRGBMacro.self,
    HexToUIColorSRGBMacro.self,
    HexToUIColorP3Macro.self,

  ]
}
