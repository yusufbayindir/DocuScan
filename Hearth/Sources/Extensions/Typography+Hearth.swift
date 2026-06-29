import SwiftUI

extension Font {
    static let hearthDisplay       = Font.system(size: 34, weight: .bold, design: .rounded)
    static let hearthTitle1        = Font.system(size: 28, weight: .bold)
    static let hearthTitle2        = Font.system(size: 22, weight: .bold)
    static let hearthTitle3        = Font.system(size: 20, weight: .semibold)
    static let hearthHeadline      = Font.system(size: 17, weight: .semibold)
    static let hearthBody          = Font.system(size: 17, weight: .regular)
    static let hearthCallout       = Font.system(size: 16, weight: .regular)
    static let hearthSubheadline   = Font.system(size: 15, weight: .semibold)
    static let hearthFootnote      = Font.system(size: 13, weight: .regular)
    static let hearthCaption1      = Font.system(size: 12, weight: .regular)
    static let hearthCaption2      = Font.system(size: 11, weight: .regular)

    // Currency / amount display — SF Pro Rounded + monospacedDigit
    static let hearthAmount        = Font.system(size: 34, weight: .bold, design: .rounded).monospacedDigit()
    static let hearthMediumAmount  = Font.system(size: 22, weight: .semibold, design: .rounded).monospacedDigit()
    static let hearthSmallAmount   = Font.system(size: 15, weight: .semibold, design: .rounded).monospacedDigit()
}
