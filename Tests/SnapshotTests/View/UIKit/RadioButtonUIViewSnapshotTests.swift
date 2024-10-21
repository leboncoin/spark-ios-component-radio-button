//
//  RadioButtonUIViewSnapshotTests.swift
//  SparkRadioButton
//
//  Created by louis.borlee on 21/10/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import XCTest
import UIKit
@testable import SparkRadioButton
@testable import SparkTheme
@testable import SparkTheming
@_spi(SI_SPI) @testable import SparkCommon
@_spi(SI_SPI) @testable import SparkCommonTesting
@_spi(SI_SPI) @testable import SparkCommonSnapshotTesting

final class RadioButtonUIViewSnapshotTests: UIKitComponentSnapshotTestCase  {

    private let theme: Theme = SparkTheme.shared

    func test1() {
        self._test(.test1)
    }

    func test2() {
        self._test(.test2)
    }

    func test3() {
        self._test(.test3)
    }

    private func _test(_ scenario: RadioButtonScenario) {
        for configuration in scenario.configurations {
            let view = RadioButtonUIGroupView(
                theme: self.theme,
                intent: configuration.intent,
                selectedID: configuration.radioButtons.firstIndex(where: \.isSelected),
                items: configuration.radioButtons.enumerated().map { index, radioButton in
                    return .init(id: index, label: radioButton.text)
                },
                labelAlignment: configuration.labelAlignment,
                groupLayout: configuration.groupLayout
            )
            view.translatesAutoresizingMaskIntoConstraints = false
            for (index, radioButton) in configuration.radioButtons.enumerated() {
                view.radioButtonViews[index].isEnabled = radioButton.isEnabled
                view.radioButtonViews[index].isHighlighted = radioButton.isHighlighted
            }
            view.backgroundColor = self.theme.colors.base.surface.uiColor
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = self.theme.colors.base.surfaceInverse.uiColor
            containerView.addSubview(view)
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
                view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
                view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ])

            if configuration.groupLayout == .vertical {
                containerView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            }

            self.assertSnapshot(
                matching: containerView,
                modes: configuration.modes,
                sizes: configuration.sizes,
                testName: configuration.testName
            )
        }
    }
}
