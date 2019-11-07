// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "ARKitura",
    dependencies: [
      .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.8.0")),
      .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.1"),
      .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.8.3"),
      .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", from: "9.0.0"),
      .package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", from: "2.0.0"),
      .package(url: "https://github.com/IBM-Swift/Health.git", from: "1.0.0"),
    ],
    targets: [
      .target(name: "ARKitura", dependencies: [ .target(name: "Application") ]),
      .target(name: "Application", dependencies: [ "Kitura", "HeliumLogger", "KituraStencil", "CloudEnvironment","SwiftMetrics", "Health",

      ]),

      .testTarget(name: "ApplicationTests" , dependencies: [.target(name: "Application"), "Kitura", "HeliumLogger", "KituraStencil" ])
    ]
)
