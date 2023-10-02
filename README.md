# Swift Macro Hex Color

A macro that expands a hexadecimal string into a floating-point color value.

## Requirements

Swift 5.9

## SwiftUI

```swift
#hexColor("#BA43F1")

// Color(.sRGB, red: 0.7294117647058823, green: 0.2627450980392157, blue: 0.9450980392156862, opacity: 1)
```

```swift
#hexColor("#BA43F1", colorSpace: .displayP3)

// Color(.displayP3, red: 0.7294117647058823, green: 0.2627450980392157, blue: 0.9450980392156862, opacity: 1)
```

```swift
#hexColor("#BA43F1", opacity: 1, colorSpace: .displayP3)

// Color(.displayP3, red: 0.7294117647058823, green: 0.2627450980392157, blue: 0.9450980392156862, opacity: 1)
```

## UIKit

```swift
#hexUIColorSRGB("#556421")
// UIColor(red: 0.3333333333333333, green: 0.39215686274509803, blue: 0.12941176470588237, alpha: 1)

#hexUIColorSRGB("#556421", opacity: 1)

#hexUIColorP3("#556421")
// UIColor(displayP3Red: 0.3333333333333333, green: 0.39215686274509803, blue: 0.12941176470588237, alpha: 1)

#hexUIColorP3("#556421", opacity: 1)
```
