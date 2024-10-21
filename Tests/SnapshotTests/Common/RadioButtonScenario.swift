//
//  RadioButtonScenario.swift
//  SparkRadioButton
//
//  Created by louis.borlee on 21/10/2024.
//  Copyright © 2024 Adevinta. All rights reserved.
//

import Foundation
@testable import SparkRadioButton
@_spi(SI_SPI) @testable import SparkCommonSnapshotTesting

enum RadioButtonScenario: String {
    case test1
    case test2
    case test3

    var configurations: [RadioButtonScenarioConfiguration] {
        switch self {
        case .test1:
            return self.createTest1Configurations()
        case .test2:
            return self.createTest2Configurations()
        case .test3:
            return self.createTest3Configurations()
        }
    }

    private func createTest1Configurations() -> [RadioButtonScenarioConfiguration] {
        var configurations = [RadioButtonScenarioConfiguration]()
        let radioButtons = self.createRadioButtonConfigurations()
        for intent in RadioButtonIntent.allCases {
            configurations.append(
                .init(
                    description: "Test1",
                    intent: intent,
                    radioButtons: radioButtons,
                    groupLayout: .vertical,
                    labelAlignment: .trailing,
                    modes: [.light],
                    sizes: [.medium]
                )
            )
        }
        return configurations
    }

    private func createTest2Configurations() -> [RadioButtonScenarioConfiguration] {
        var configurations = [RadioButtonScenarioConfiguration]()
        let radioButtons = self.createRadioButtonConfigurations()
        for groupLayout in [RadioButtonGroupLayout.horizontal, .vertical] {
            for labelAlignment in [RadioButtonLabelAlignment.leading, .trailing] {
                configurations.append(
                    .init(
                        description: "Test2",
                        intent: .main,
                        radioButtons: radioButtons,
                        groupLayout: groupLayout,
                        labelAlignment: labelAlignment,
                        modes: [.dark],
                        sizes: [.medium]
                    )
                )
            }
        }
        return configurations
    }

    private func createTest3Configurations() -> [RadioButtonScenarioConfiguration] {
        var configurations = [RadioButtonScenarioConfiguration]()
        let radioButtons = self.createRadioButtonConfigurations()
        for groupLayout in [RadioButtonGroupLayout.horizontal, .vertical] {
            configurations.append(
                .init(
                    description: "Test3",
                    intent: .danger,
                    radioButtons: radioButtons,
                    groupLayout: groupLayout,
                    labelAlignment: .trailing,
                    modes: [.light],
                    sizes: [.extraSmall, .extraExtraExtraLarge]
                )
            )
        }
        return configurations
    }

    private func createRadioButtonConfigurations() -> [RadioButtonScenarioConfiguration.SingleRadioButtonConfiguration] {
        return [
            .init(
                text: "Donec ut quam a lacus vehicula sagittis venenatis eu lacus. Integer at dui viverra, mollis ligula nec, imperdiet tortor. Praesent commodo urna justo, quis pulvinar libero fringilla at.",
                isSelected: true,
                isEnabled: true,
                isHighlighted: false
            ),
            .init(
                text: "Enabled + highlighted",
                isSelected: false,
                isEnabled: true,
                isHighlighted: true
            ),
            .init(
                text: "Disabled",
                isSelected: false,
                isEnabled: false,
                isHighlighted: false
            ),
            .init(
                text: "",
                isSelected: false,
                isEnabled: false,
                isHighlighted: true
            ),
        ]
    }
}
