
@freestanding(expression)
public macro hexToRGB(_ hexString: StaticString) -> (r: Double, g: Double, b: Double) = #externalMacro(module: "HexColorMacroMacros", type: "HexToRGBMacro")

#if canImport(SwiftUI)
import SwiftUI

@freestanding(expression)
public macro hexColor(_ hexString: StaticString, opacity: Double = 1, colorSpace: Color.RGBColorSpace = .sRGB) -> SwiftUI.Color = #externalMacro(module: "HexColorMacroMacros", type: "HexToColorMacro")

#endif

#if canImport(UIKit)
import UIKit

@freestanding(expression)
public macro hexUIColorSRGB(_ hexString: StaticString, opacity: CGFloat = 1) -> UIColor = #externalMacro(module: "HexColorMacroMacros", type: "HexToUIColorSRGBMacro")

@freestanding(expression)
public macro hexUIColorP3(_ hexString: StaticString, opacity: CGFloat = 1) -> UIColor = #externalMacro(module: "HexColorMacroMacros", type: "HexToUIColorP3Macro")

#endif
