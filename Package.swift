// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Spark___COMPONENT_NAME___",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Spark___COMPONENT_NAME___",
            targets: ["Spark___COMPONENT_NAME___"]
        ),
        .library(
            name: "Spark___COMPONENT_NAME___Testing",
            targets: ["Spark___COMPONENT_NAME___Testing"]
        )
    ],
    dependencies: [
       .package(
           url: "https://github.com/adevinta/spark-ios-common.git",
           // path: "../spark-ios-common"
           /*version*/ "0.0.1"..."999.999.999"
       ),
       .package(
           url: "https://github.com/adevinta/spark-ios-theming.git",
           // path: "../spark-ios-theming"
           /*version*/ "0.0.1"..."999.999.999"
       )
    ],
    targets: [
        .target(
            name: "Spark___COMPONENT_NAME___",
            dependencies: [
                .product(
                    name: "SparkCommon",
                    package: "spm-poc-common"
                ),
                .product(
                    name: "SparkTheming",
                    package: "spm-poc-theming"
                )
            ]
        ),
        .target(
            name: "Spark___COMPONENT_NAME___Testing",
            dependencies: [
                "Spark___COMPONENT_NAME___",
                .product(
                    name: "SparkCommon",
                    package: "spm-poc-common"
                ),
                .product(
                    name: "SparkCommonTesting",
                    package: "spm-poc-common"
                ),
                .product(
                    name: "SparkThemingTesting",
                    package: "spm-poc-theming"
                ),
                .product(
                    name: "SparkTheme",
                    package: "spm-poc-theming"
                )
            ]
        ),
        .testTarget(
            name: "Spark___COMPONENT_NAME___UnitTests",
            dependencies: [
                "Spark___COMPONENT_NAME___",
                "Spark___COMPONENT_NAME___Testing",
                .product(
                    name: "SparkCommonTesting",
                    package: "spm-poc-common"
                ),
                .product(
                    name: "SparkThemingTesting",
                    package: "spm-poc-theming"
                )
            ]
        ),
        .testTarget(
            name: "Spark___COMPONENT_NAME___SnapshotTests",
            dependencies: [
                "Spark___COMPONENT_NAME___",
                "Spark___COMPONENT_NAME___Testing",
                .product(
                    name: "SparkCommonSnapshotTesting",
                    package: "spm-poc-common"
                ),
            ]
        ),
    ]
)
