# Radio-button
Component used when only one choice may be selected in a series of options.

## Specifications
The radio button specifications on Zeroheight are [here](https://spark.adevinta.com/1186e1705/p/98058f-radio-button).

![Figma anatomy](https://github.com/adevinta/spark-ios-component-radio-button/blob/main/.github/assets/anatomy.png)

## Usage
Radio buttons are available both in UIKit and SwiftUI. It is possible to create a standalone radio button with  `RadioButtonUIView` and `RadioButtonView`, but it is not advised since radio buttons really only have a value in a group. 
For grouped usage - `RadioButtonUIGroupView` and `RadioButtonGroupView`.

### RadioButtonUIView/RadioButtonView
Radio button has customizable parameters in initialization:
* `theme`: The current Spark-Theme. [You always can define your own theme.](https://github.com/adevinta/spark-ios/wiki/Theming#your-own-theming)
* `intent`: The intent used to define the colors.
* `id`: A unique ID identifying the value of the item
* `label`: A text describing the value
* `selectedID: Binding<ID>`: A binding to which the id of the radio button will be assigned when selected.
* `labelAlignment; RadioButtonLabelAlignment ` is either leading or trailing. `.trailing` by default

### RadioButtonUIView Properties
* `theme: Theme`. The general theme
* `intent: RatioButtonIntent`. The intent defining the colors.
* `isEnabled: Bool`. Enable/Disable the current item.
* `isSelected: Bool`. A bool with which the current item can be selected.
* `text: String`. THe label of the radio button.
* `attributedText: NSAttributedString`. The label of radio button 
* `labelAlignment: RadioButtonLabelAlignment`. The label position, leading of trailing of the toggle.
* `id`: Fetch the current id of the item.

### RadioButtonUIGroupView
Group view has the following parameters:
* `theme`: The theme defining colors and layout options.
* `title`: An option string. The title is rendered above the radio button items, if it is not empty.
* `selectedID`: a binding to the selected value.
* `items`: A list of `RadioButtonItem` — simple struct for defining radio buttons.

### RadioButtonUIGroupView Initialization 
Parameters:
* `theme: Theme`. The current theme.
* `intent: RadioButtonIntent`. The intent defining the colors.
* `selectedID: ID`. The current selected value of the radio button group.
* `items: [RadioButtonUIItem]`. A list which represents each item in the radio button group.
* `labelAlignment: RadioButtonLabelAlignment`. The position of the label in each radio button item according to the toggle. The default value is, that the label is to the `right` of the toggle (trailing).
* `groupLayout: RadioButtonGroupLayout`. The layout of the items within the group. These can be `horizontal` or `vertical`. The defalt is `vertical`.

### RadioButtonUIGroupView Properties
* `theme: Theme`. The current theme
* `intent: RadioButtonIntent`. The intent defining the colors of the radio buttons.
* `items: [RadioButtonUIItem<ID>]`. All the items `RadioButtonUIItem` of the radio button group
* `numberOfItems: Int`. The number of radio button items in the group.
* `radioButtonViews: [RadioButtonUIView]`. All radio button views (read only).
* `isEnabled: Bool`. A boolean with which the enabled state may be toggled.
* `title: String?`. An optional title of the radio button group
* `supplementaryText: String?`. An optional supplementary text of the radio button group rendered at the bottom of the group. This is NOT well defined for the states `enabled` and `disabled`.
* `selectedID: ID`. The current selected ID. 
* `labelAlignment: RadioButtonLabelAlignment`,  The label position according to the toggle, either `leading` or `trailing`. The default value is `trailing`. 
* `groupLayout: RadioButtonGroupLayout`. The group layout `RadioButtonGroupLayout` of the radio buttons, either `horizontal` or `vertical`. The default is `vertical`. 
* `delegate: (some RadioButtonUIGroupViewDelegate)?`. A delegate which can be set, to be notified of the changed selected item of the radio button. An alternative is to subscribe to the `publisher`.
* `publisher: some Publisher<ID, Never>.` A change of the selected item will be published. This is an alternative method to the `delegate` of being notified of changes to the selected item.
* `accessibilityIdentifier: String.` Set the accessibilityIdentifier. This identifier will be used as the accessibility identifier prefix of each radio button item, the suffix of that accessibility identifier being the index of the item within it's array.


## Examples
### RadioButtonUIGroupView

```swift
private lazy var radioButtonItems: [RadioButtonItem<String>] = [
        RadioButtonItem(id: "1",
                        label: "1 Lorem Ipsum is dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard"),
        RadioButtonItem(id: "2",
                        label: "2 Radio button / Enabled",
                        state: .enabled),
        RadioButtonItem(id: "3",
                        label: "3 Radio button / Disabled",
                        state: .disabled),
        RadioButtonItem(id: "4",
                        label: "4 Radio button / Accent",
                        state: .accent),
        RadioButtonItem(id: "5",
                        label: "5 Radio button / Basic",
                        state: .basic),
        RadioButtonItem(id: "6",
                        label: "6 Radio button / Error",
                        state: .error(message: "Error")),
        RadioButtonItem(id: "7",
                        label: "7 Radio button / Success",
                        state: .success(message: "Success")),
        RadioButtonItem(id: "8",
                        label: "8 Radio button / Warning",
                        state: .warning(message: "Warning")),
]

let groupView = RadioButtonUIGroupView(
            theme: self.theme,
            intent: .basic,
            selectedID: self.selectedId,
            items: self.radioButtonItems,
            labelAlignment: .trailing
        )

let stackView = UIStackView()
stackView.axis = .vertical
stackView.alignment = .leading
stackView.translatesAutoresizingMaskIntoConstraints = false
stackView.addArrangedSubview(groupView)
```

### RadioButtonGroupView

```swift
@State var selectedID: Int = 1
var body: some View {
    VStack {
        RadioButtonGroupView(
            theme: self.theme,
            intent: .basic,
            selectedID: self.$selectedID,
            items: [
                RadioButtonItem(id: 1,
                                label: "1 Lorem Ipsum is dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard"),
                RadioButtonItem(id: 2,
                                label: "2 Radio button / Enabled",
                                state: .enabled),
                RadioButtonItem(id: 3,
                                label: "3 Radio button / Disabled",
                                state: .disabled),
                RadioButtonItem(id: 4,
                                label: "4 Radio button / Accent",
                                state: .accent),
                RadioButtonItem(id: 5,
                                label: "5 Radio button / Basic",
                                state: .basic),
                RadioButtonItem(id: 6,
                                label: "6 Radio button / Error",
                                state: .error(message: "Error")),
                RadioButtonItem(id: 7,
                                label: "7 Radio button / Success",
                                state: .success(message: "Success")),
                RadioButtonItem(id: 8,
                                label: "8 Radio button / Warning",
                                state: .warning(message: "Warning")),
            ])
    }
}
```

### RadioButtonUIView
```swift
var selectedIdValue: String = ""
var selectedId: Binding<String> = Binding<String>(
   get: {
       return self.selectedIdValue
   }
   set: {
       self.selectedIdValue = $0
   }
}

let radioButton = RadioButtonUIView(theme: self.theme, intent: .basic, id: "23", label: "Test Label", selectedID: self.selectedId)

let stackView = UIStackView()
stackView.axis = .vertical
stackView.alignment = .leading
stackView.translatesAutoresizingMaskIntoConstraints = false
stackView.addArrangedSubview(radioButton)
```

### RadioButtonView

```swift
@State var selectedID: Int = 1

var body: some View {
    VStack {
        RadioButtonView(theme: self.theme, intent: .basic, id: 1, label: "1 Lorem Ipsum is dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard", selectedID: self.$selectedID)
    }
}
```

## License

```
MIT License

Copyright (c) 2024 Adevinta

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