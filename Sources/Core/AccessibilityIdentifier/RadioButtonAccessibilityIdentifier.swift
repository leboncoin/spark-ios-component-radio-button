//
//  RadioButtonAccessibilityIdentifier.swift
//  SparkComponentRadioButton
//
//  Created by michael.zimmermann on 14.04.23.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

public enum RadioButtonAccessibilityIdentifier {

    // MARK: - Properties

    public static let radioButton = "spark-radio-button"

    /// The radio group title accessibility identifier.
    public static let radioButtonGroupTitle = "spark-radio-button-group-title"

    /// The radio button text label accessibility identifier.
    public static let radioButtonTextLabel = "spark-radio-button-text-label"

    public static func radioButtonIdentifier<ID: CustomStringConvertible>(id: ID) -> String {
        return "\(radioButton)-\(id)"
    }
}
