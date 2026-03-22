//
//  RadioButtonState.swift
//  SparkRadioButton
//
//  Created by michael.zimmermann on 28.06.23.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

import Foundation

@frozen
@available(*, deprecated, message: "Use RadioButtonIntent and the attribute isEnabled instead. ")
public enum RadioButtonGroupState: Equatable, Hashable, CaseIterable {
    case enabled
    case disabled
    case accent
    case basic

    case success
    case warning
    case error
}

extension RadioButtonGroupState {
    var intent: RadioButtonIntent {
        switch self {
        case .enabled: return .support
        case .disabled: return .support
        case .accent: return .accent
        case .basic: return .support
        case .success: return .success
        case .warning: return .alert
        case .error: return .danger
        }
    }
}
