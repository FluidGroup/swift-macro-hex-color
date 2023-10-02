import HexColorMacro
import SwiftUI

#hexColor("#BA43F1")

#hexColor("#BA43F1", colorSpace: .displayP3)

#hexColor("#BA43F1", opacity: 1, colorSpace: .displayP3)

#if canImport(UIKit)

#hexUIColorSRGB("#556421")

#hexUIColorSRGB("#556421", opacity: 1)

#hexUIColorP3("#556421")

#hexUIColorP3("#556421", opacity: 1)

#endif
