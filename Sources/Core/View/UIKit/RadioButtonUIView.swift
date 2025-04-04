//
//  RadioButtonUIView.swift
//  Spark
//
//  Created by michael.zimmermann on 18.04.23.
//  Copyright © 2023 Leboncoin. All rights reserved.
//

import Combine
import SwiftUI
import UIKit
@_spi(SI_SPI) import SparkCommon
import SparkTheming

// MARK: - Constants
private enum Constants {
    static let toggleViewHeight: CGFloat = 32
    static let textLabelTopSpacing: CGFloat = 5
    static let haloWidth: CGFloat = 4
}

/// A radio button view composed of a toggle item, a label and a possible sublabel.
/// The color of the view is determined by the state. A possible sublabel is also part of the state.
/// The value of the radio button is represented by the generic type ID.
/// When the radio button is selected, it will change the binding value.
public final class RadioButtonUIView<ID: Equatable & CustomStringConvertible>: UIControl {

    // MARK: - Injected Properties
    private let viewModel: RadioButtonViewModel<ID>

    // MARK: - Public Properties
    /// The general theme
    public var theme: Theme {
        get {
            return self.viewModel.theme
        }
        set {
            self.viewModel.set(theme: newValue)
        }
    }

    /// The current groupState
    @available(*, deprecated, message: "Use intent and isEnabled instead.")
    public var groupState: RadioButtonGroupState {
        get {
            if self.viewModel.state.isEnabled {
                return .enabled
            } else {
                return .disabled
            }
        }
        set {
            self.viewModel.set(enabled: newValue != .disabled)
        }
    }

    public var intent: RadioButtonIntent {
        get {
            return self.viewModel.intent
        }
        set {
            self.viewModel.set(intent: newValue)
        }
    }

    public override var isEnabled: Bool {
        didSet {
            self.viewModel.set(enabled: self.isEnabled)
            if self.isEnabled {
                self.accessibilityTraits.remove(.notEnabled)
            } else {
                self.accessibilityTraits.insert(.notEnabled)
            }
        }
    }

    public override var isSelected: Bool {
        didSet {
            self.viewModel.set(selected: self.isSelected)
            if self.isSelected {
                self.accessibilityTraits.insert(.selected)
            } else {
                self.accessibilityTraits.remove(.selected)
            }
        }
    }

    public override var isHighlighted: Bool {
        get {
            return self.toggleView.isPressed
        }
        set {
            self.toggleView.isPressed = newValue
        }
    }

    /// The label of radio button
    public var text: String? {
        get {
            return self.textLabel.text
        }
        set {
            self.viewModel.label = .left(newValue.map(NSAttributedString.init))
            self.updateLabel()
        }
    }

    /// The ID of the radio button
    public var id: ID {
        get {
            return self.viewModel.id
        }
    }

    /// The label of radio button
    public var attributedText: NSAttributedString? {
        get {
            return self.textLabel.attributedText
        }
        set {
            self.viewModel.label = .left(newValue)
            self.updateLabel()
        }
    }

    /// The label of radio button
    @available(*, deprecated, renamed: "attributedText")
    public var label: NSAttributedString {
        get {
            return self.attributedText ?? NSAttributedString(string: "")
        }
        set {
            self.attributedText = newValue
        }
    }

    /// The label position, right of left of the toggle
    @available(*, deprecated, renamed: "labelAlignment", message: "Please use labelAlignment intead.")
    public var labelPosition: RadioButtonLabelPosition {
        get {
            return self.viewModel.alignment.position
        }
        set {
            self.viewModel.set(alignment: newValue.alignment)
        }
    }

    /// The label position according to the toggle
    public var labelAlignment: RadioButtonLabelAlignment {
        get {
            return self.viewModel.alignment
        }
        set {
            self.viewModel.set(alignment: newValue)
        }
    }

    /// Changes of the selection state is posted to the publisher.
    public var publisher: some Publisher<Bool, Never> {
        return self.subject
    }

    // MARK: - Private Properties
    @ScaledUIMetric private var toggleSize = Constants.toggleViewHeight
    @ScaledUIMetric private var spacing: CGFloat
    @ScaledUIMetric private var textLabelTopSpacing = Constants.textLabelTopSpacing
    @ScaledUIMetric private var haloWidth = Constants.haloWidth

    private var subscriptions = Set<AnyCancellable>()
    private let subject = PassthroughSubject<Bool, Never>()
    // Only needed as a binding for the single radio button
    private var singleRadioButtonBinding: ValueBinding<ID>?

    // MARK: - View properties
    private lazy var toggleView: RadioButtonToggleUIView = {
        let toggleView = RadioButtonToggleUIView()
        toggleView.isUserInteractionEnabled = false
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        toggleView.backgroundColor = .clear
        toggleView.sizeToFit()
        toggleView.setContentCompressionResistancePriority(
            .required,
            for: .vertical)
        toggleView.setContentCompressionResistancePriority(
            .required,
            for: .horizontal)

        return toggleView
    }()

    private lazy var textLabel = UILabel.standard

    // MARK: - Constraint properties
    private var toggleViewWidthConstraint: NSLayoutConstraint?
    private var toggleViewHeightConstraint: NSLayoutConstraint?
    private var toggleViewSpacingConstraint: NSLayoutConstraint?
    private var labelViewTopConstraint: NSLayoutConstraint?
    private var toggleViewTopConstraint: NSLayoutConstraint?
    private var toggleViewLeadingConstraint: NSLayoutConstraint?
    private var toggleViewTrailingConstraint: NSLayoutConstraint?
    private var labelPositionConstraints: [NSLayoutConstraint] = []

    public override var accessibilityLabel: String? {
        get { return self.textLabel.accessibilityLabel }
        set { self.textLabel.accessibilityLabel = newValue }
    }

    // MARK: - Initialization

    /// The radio button component takes a theme, an id, a label and a binding
    ///
    /// Parameters:
    /// - theme: The current theme
    /// - id: The value of the radio button
    /// - label: The text rendered to describe the value
    /// - selectedID: A binding which is triggered when the radio button is selected
    /// - groupState: the state of the radiobutton group
    @available(*, deprecated, message: "Please use init with intent instead.")
    public convenience init(
        theme: Theme,
        id: ID,
        label: NSAttributedString,
        selectedID: Binding<ID?>,
        groupState: RadioButtonGroupState = .enabled,
        labelPosition: RadioButtonLabelPosition = .right
    ) {
        let viewModel = RadioButtonViewModel(
            theme: theme,
            intent: groupState.intent,
            id: id,
            label: .left(label),
            selectedID: selectedID,
            alignment: labelPosition.alignment)

        self.init(viewModel: viewModel)
    }

    /// A radio button component which can be used as a standalone component.
    /// This convenience init, avoids needing to use a binding. Changes to the selection state are published to the publisher.
    ///
    /// Parameters:
    /// - theme: The current theme
    /// - intent: The intent defining the color
    /// - id: The value of the radio button
    /// - label: The text rendered to describe the value
    /// - isSelected: Bool, defining whether the radiobutton is selected or not.
    /// - labelAlignment: the alignment of the label according to the toggle
    public convenience init(
        theme: Theme,
        intent: RadioButtonIntent,
        id: ID,
        label: NSAttributedString,
        isSelected: Bool,
        labelAlignment: RadioButtonLabelAlignment = .trailing
    ) {
        let valueBinding = ValueBinding(selectedID: isSelected ? id : nil)

        let viewModel = RadioButtonViewModel(
            theme: theme,
            intent: intent,
            id: id,
            label: .left(label),
            selectedID: valueBinding.binding,
            alignment: labelAlignment)

        self.init(viewModel: viewModel)
        self.singleRadioButtonBinding = valueBinding
    }

    /// The radio button component takes a theme, an id, a label and a binding
    ///
    /// Parameters:
    /// - theme: The current theme
    /// - intent: The intent defining the color
    /// - id: The value of the radio button
    /// - label: The text rendered to describe the value
    /// - selectedID: A binding which is triggered when the radio button is selected
    /// - labelAlignment: the alignment of the label according to the toggle
    public convenience init(
        theme: Theme,
        intent: RadioButtonIntent = .basic,
        id: ID,
        label: NSAttributedString,
        selectedID: Binding<ID?>,
        labelAlignment: RadioButtonLabelAlignment = .trailing
    ) {
        let viewModel = RadioButtonViewModel(
            theme: theme,
            intent: intent,
            id: id,
            label: .left(label),
            selectedID: selectedID,
            alignment: labelAlignment)

        self.init(viewModel: viewModel)
    }

    init(viewModel: RadioButtonViewModel<ID>) {
        self.viewModel = viewModel
        self._spacing = ScaledUIMetric(wrappedValue: viewModel.spacing)

        super.init(frame: CGRect.zero)

        self.isSelected = self.viewModel.state.isSelected

        self.accessibilityTraits.insert(.button)
        self.isAccessibilityElement = true
        self.accessibilityValue = self.viewModel.id.description

        self.arrangeViews()
        self.setupButtonActions()
        self.updateViewAttributes()
        self.enableTouch()
        self.setupSubscriptions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions
    public func toggleNeedsRedisplay() {
        self.viewModel.updateViewAttributes()
        self.isSelected = self.viewModel.state.isSelected
        self.updateColors(self.viewModel.colors)
        self.updateLabel()
        self.toggleView.setNeedsDisplay()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self._toggleSize.update(traitCollection: self.traitCollection)
        self._spacing.update(traitCollection: self.traitCollection)
        self._textLabelTopSpacing.update(traitCollection: self.traitCollection)
        self._haloWidth.update(traitCollection: self.traitCollection)

        toggleViewSpacingConstraint?.constant = -self.spacing + self.haloWidth
        toggleViewWidthConstraint?.constant = self.toggleSize
        toggleViewHeightConstraint?.constant = self.toggleSize

        labelViewTopConstraint?.constant = self.textLabelTopSpacing

        toggleViewTopConstraint?.constant = -self.haloWidth
        toggleViewLeadingConstraint?.constant = -self.haloWidth
        toggleViewTrailingConstraint?.constant = self.haloWidth
    }

    // MARK: - Private Functions

    private func setupSubscriptions() {

        self.viewModel.$opacity.subscribe(in: &self.subscriptions) { [weak self] opacity in
            self?.alpha = opacity
        }

        self.viewModel.$colors.subscribe(in: &self.subscriptions) { [weak self] colors in
            guard let self else { return }
            self.updateColors(colors)
            self.updateLabel()
        }

        self.viewModel.$font.subscribe(in: &self.subscriptions) { [weak self] font in
            guard let self else { return }
            self.textLabel.font = font.uiFont
            self.updateLabel()
        }

        self.viewModel.$alignment.subscribe(in: &self.subscriptions) { [weak self] _ in
            self?.updatePositionConstraints()
        }

        self.viewModel.$spacing.subscribe(in: &self.subscriptions) { [weak self] spacing in
            guard let self else { return }
            self._spacing = ScaledUIMetric(wrappedValue: spacing)
            self.updatePositionConstraints()
        }
    }

    private func arrangeViews() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(self.toggleView)
        self.addSubview(self.textLabel)

        self.setupConstraints()
        self.updateLabel()
    }

    private func updateViewAttributes() {
        self.updateColors(self.viewModel.colors)

        self.updateLabel()

        self.alpha = self.viewModel.opacity
    }

    private func updateLabel() {
        self.textLabel.font = self.viewModel.font.uiFont
        self.textLabel.textColor = self.viewModel.colors.label.uiColor
        self.textLabel.attributedText = self.viewModel.label.leftValue

        self.textLabel.accessibilityIdentifier = RadioButtonAccessibilityIdentifier.radioButtonTextLabel
    }

    private func updateColors(_ colors: RadioButtonColors) {
        self.toggleView.setColors(colors)
        self.textLabel.textColor = colors.label.uiColor
    }

    private func setupButtonActions() {
        self.addTarget(self, action: #selector(self.actionTapped(sender:)), for: .touchUpInside)
    }

    private func setupConstraints() {
        let toggleViewWidthConstraint = self.toggleView.widthAnchor.constraint(equalToConstant: self.toggleSize)
        let toggleViewHeightConstraint = self.toggleView.heightAnchor.constraint(equalToConstant: self.toggleSize)

        let toggleViewSpacingConstraint = self.calculateToggleViewSpacingConstraint()

        let labelViewTopConstraint = self.textLabel.topAnchor.constraint(
            equalTo: self.toggleView.topAnchor, constant: self.textLabelTopSpacing)
        let toggleViewTopConstraint = self.toggleView.topAnchor.constraint(
            equalTo: self.topAnchor, constant: -(self.haloWidth))
        let labelBottomViewConstraint = self.textLabel.bottomAnchor.constraint(
            lessThanOrEqualTo: self.bottomAnchor)
        let toggleViewBottomConstraint = self.toggleView.bottomAnchor.constraint(
            lessThanOrEqualTo: self.bottomAnchor,
            constant: self.haloWidth
        )

        let labelPositionConstraints = calculatePositionConstraints()

        let constraints = [
            toggleViewWidthConstraint,
            toggleViewHeightConstraint,
            toggleViewSpacingConstraint,
            toggleViewTopConstraint,
            toggleViewBottomConstraint,
            labelViewTopConstraint,
            labelBottomViewConstraint
        ] + labelPositionConstraints

        NSLayoutConstraint.activate(constraints)

        self.toggleViewWidthConstraint = toggleViewWidthConstraint
        self.toggleViewHeightConstraint = toggleViewHeightConstraint
        self.toggleViewSpacingConstraint = toggleViewSpacingConstraint
        self.labelViewTopConstraint = labelViewTopConstraint
        self.labelPositionConstraints = labelPositionConstraints
        self.toggleViewTopConstraint = toggleViewTopConstraint
    }

    private func calculatePositionConstraints() -> [NSLayoutConstraint] {
        if self.viewModel.alignment == .trailing {

            let toggleViewLeadingConstraint = self.toggleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -self.haloWidth)
            self.toggleViewLeadingConstraint = toggleViewLeadingConstraint

            return [
                toggleViewLeadingConstraint,
                self.textLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ]
        } else {
            let toggleViewTrailingConstraint = self.toggleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: self.haloWidth)
            self.toggleViewTrailingConstraint = toggleViewTrailingConstraint

            return [
                toggleViewTrailingConstraint,
                self.textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            ]
        }
    }

    private func calculateToggleViewSpacingConstraint() -> NSLayoutConstraint {
        if self.viewModel.alignment == .trailing {
            return self.toggleView.trailingAnchor.constraint(
                equalTo: self.textLabel.leadingAnchor, constant: -self.spacing + self.haloWidth)
        } else {
            return self.textLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: self.toggleView.leadingAnchor, constant: -self.spacing + self.haloWidth)
        }
    }

    private func updatePositionConstraints() {
        NSLayoutConstraint.deactivate([self.toggleViewSpacingConstraint].compactMap{ return $0 } + self.labelPositionConstraints)

        let toggleViewSpacingConstraint = calculateToggleViewSpacingConstraint()
        let positionConstraints = self.calculatePositionConstraints()

        NSLayoutConstraint.activate([toggleViewSpacingConstraint] + positionConstraints)

        self.toggleViewSpacingConstraint = toggleViewSpacingConstraint
        self.labelPositionConstraints = positionConstraints
    }

    // MARK: - Control functions
    @IBAction func actionTapped(sender: Any?)  {
        if !self.isSelected {
            self.isSelected = true
            self.subject.send(true)
            self.sendActions(for: .valueChanged)
        }
        self.toggleView.isPressed = false
    }
}

// MARK: - Private Helpers

private extension UILabel {
    static var standard: UILabel {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.required,
                                                      for: .vertical)
        return label
    }
}

// MARK: - Label Priorities
public extension RadioButtonUIView {
    func setLabelContentCompressionResistancePriority(_ priority: UILayoutPriority,
                                                      for axis: NSLayoutConstraint.Axis) {
        self.textLabel.setContentCompressionResistancePriority(priority,
                                                               for: axis)
    }

    func setLabelContentHuggingPriority(_ priority: UILayoutPriority,
                                        for axis: NSLayoutConstraint.Axis) {
        self.textLabel.setContentHuggingPriority(priority,
                                                 for: axis)
    }
}
