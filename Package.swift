// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "HexColorMacro",
  platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "HexColorMacro",
      targets: ["HexColorMacro"]
    ),
    .executable(
      name: "HexColorMacroClient",
      targets: ["HexColorMacroClient"]
    ),
  ],
  dependencies: [
    // Depend on the Swift 6.0 release of SwiftSyntax
    .package(url: "https://github.com/apple/swift-syntax.git", "600.0.0"..<"602.0.0")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    // Macro implementation that performs the source transformation of a macro.
    .macro(
      name: "HexColorMacroMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
      ]
    ),

    // Library that exposes a macro as part of its API, which is used in client programs.
    .target(name: "HexColorMacro", dependencies: ["HexColorMacroMacros"]),

    // A client of the library, which is able to use the macro in its own code.
    .executableTarget(name: "HexColorMacroClient", dependencies: ["HexColorMacro"]),

    // A test target used to develop the macro implementation.
    .testTarget(
      name: "HexColorMacroTests",
      dependencies: [
        "HexColorMacroMacros",
        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
      ]
    ),
  ],
  swiftLanguageModes: [.v6]
)
