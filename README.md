# Radio Button

**Spark** is the [Leboncoin](https://www.leboncoin.fr/)'s _Design System_.

The repository here contains only the **iOS RadioButton** for _SwiftUI_ and _UIKit_.

You can also see all of our Spark iOS repositories on [Github](https://github.com/orgs/leboncoin/repositories?q=spark-ios+sort%3Aname-asc).

## Specifications

The radio-button specifications on Zeroheight is [here](https://spark.adevinta.com/1186e1705/p/295e88-radio-button).

![Figma anatomy](https://github.com/leboncoin/spark-ios-component-radio-button/blob/main/.github/assets/anatomy.png)

## Technical Documentation

You are a developer ? A technical documentation in _DocC_ is available [here](https://leboncoin.github.io/spark-ios-component-radio-button/).

### Swift Package Manager

_Note: Instructions below are for using **SPM** without the Xcode UI. It's the easiest to go to your Project Settings -> Swift Packages and add SparkRadioButton from there._

To integrate using Apple's Swift package manager, without Xcode integration, add the following as a dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/leboncoin/spark-ios-component-radio-button.git", .upToNextMajor(from: "1.0.0"))
```

and then specify `SparkRadioButton` as a dependency of the Target in which you wish to use the SparkRadioButton.

Here's an example `Package.swift`:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MyPackage",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "MyPackage",
            targets: ["MyPackage"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/leboncoin/spark-ios-component-radio-button.git",
            .upToNextMajor(from: "1.0.0")
        )
    ],
    targets: [
        .target(
            name: "MyPackage",
            dependencies: [
                .product(
                    name: "SparkRadioButton",
                    package: "spark-ios-component-radio-button"
                ),
            ]
        )
    ]
)
```

## License

```
MIT License

Copyright (c) 2024 Leboncoin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
