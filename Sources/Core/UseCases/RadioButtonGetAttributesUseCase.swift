//
//  RadioButtonGetAttributesUseCase.swift
//  SparkRadioButton
//
//  Created by michael.zimmermann on 18.09.23.
//  Copyright © 2023 Adevinta. All rights reserved.
//

import Foundation
import SparkTheming

protocol RadioButtonGetAttributesUseCaseable {
    func execute(theme: Theme,
                 intent: RadioButtonIntent,
                 state: RadioButtonStateAttribute,
                 alignment: RadioButtonLabelAlignment
    ) -> RadioButtonAttributes
}

struct RadioButtonGetAttributesUseCase: RadioButtonGetAttributesUseCaseable {
    let colorsUseCase: RadioButtonGetColorsUseCaseable

    init(colorsUseCase: RadioButtonGetColorsUseCaseable = RadioButtonGetColorsUseCase()) {
        self.colorsUseCase = colorsUseCase
    }
    func execute(theme: Theme,
                 intent: RadioButtonIntent,
                 state: RadioButtonStateAttribute,
                 alignment: RadioButtonLabelAlignment
    ) -> RadioButtonAttributes {
        return RadioButtonAttributes(
            colors: self.colorsUseCase.execute(
                theme: theme,
                intent: intent,
                isSelected: state.isSelected),
            opacity: state.isEnabled ? 1 : theme.dims.dim3,
            spacing: theme.layout.spacing.medium,
            font: theme.typography.body1)
    }
}
