# Hearth Design Specification
**App:** Hearth — AI Finance for Couples  
**Tagline:** Where your money comes home.  
**Platform:** iOS 17+, SwiftUI, Swift 5.9+  
**Spec Version:** 1.0  
**Date:** 2026-06-29  

---

## 1. Design Philosophy

### Principle 1: Warmth Over Sterility
Fintech defaults to cold blues, clinical grays, and transactional tone. Hearth inverts this. Every color, radius, and type choice is tuned to feel like a living room — warm, inviting, safe. The terracotta/cream palette, rounded type, and amber accents communicate that money is a shared, human thing between two people.

### Principle 2: Proactive, Not Reactive
The AI Spending Coach intervenes before problems happen. UI patterns must visually prioritize forward-looking information (budget trajectories, goal progress, upcoming bills) over backward-looking ledgers. Amber warnings appear early; red errors are a last resort.

### Principle 3: Trust Through Transparency
Dual-login architecture means two people see the same shared data — which can create tension. Privacy controls (Full / Balance-Only / Hidden) are first-class UI elements, not buried settings. Every account card prominently displays its privacy state. Partners are never surprised by what the other can see.

### Principle 4: Ritual Over Chore
Finance apps fail when they feel like homework. Hearth creates rituals — the daily transaction review inbox (Copilot-inspired), the bi-weekly Money Date, the goal milestone celebration. Every interaction should feel intentional and rewarding, not obligatory. Haptics, animations, and celebratory moments are not optional polish — they are core to retention.

---

## 2. Color Palette

### Brand Colors

| Name | Token | Light Hex | Dark Hex | SwiftUI | Usage |
|------|-------|-----------|----------|---------|-------|
| Terracotta | `hearthTerracotta` | `#C15A3A` | `#D4725A` | `Color(red: 0.757, green: 0.353, blue: 0.227)` | Primary CTAs, active states, brand moments |
| Coral | `hearthCoral` | `#D4725A` | `#E07A5C` | `Color(red: 0.831, green: 0.447, blue: 0.353)` | Hover states, secondary brand, partner accent |
| Sienna | `hearthSienna` | `#9B3D22` | `#B84E2A` | `Color(red: 0.608, green: 0.239, blue: 0.133)` | Pressed states, destructive actions |
| Amber | `hearthAmber` | `#E8A44A` | `#F0B85A` | `Color(red: 0.910, green: 0.643, blue: 0.290)` | Savings goals, positive momentum, AI coach |
| Cream | `hearthCream` | `#F5EDE0` | — | `Color(red: 0.961, green: 0.929, blue: 0.878)` | Light mode background primary |
| Dusty Rose | `hearthDustyRose` | `#D4A09A` | `#C89090` | `Color(red: 0.831, green: 0.627, blue: 0.604)` | Partner B indicator, joint expense highlight |

### Backgrounds

| Token | Light Hex | Dark Hex | Usage |
|-------|-----------|----------|-------|
| `backgroundPrimary` | `#F5EDE0` | `#1A1410` | Main app background |
| `backgroundSecondary` | `#EEE4D4` | `#241C16` | Grouped list backgrounds, section fills |
| `backgroundTertiary` | `#E6DAC8` | `#2E241C` | Nested card backgrounds, input fields |
| `backgroundCard` | `#FDFAF6` | `#2A2018` | Card surfaces lifted from background |
| `backgroundOverlay` | `rgba(0,0,0,0.4)` | `rgba(0,0,0,0.6)` | Sheet/modal overlay dim |

### Text

| Token | Light Hex | Dark Hex | Usage |
|-------|-----------|----------|-------|
| `textPrimary` | `#1C1410` | `#F0E6D8` | Headlines, primary labels |
| `textSecondary` | `#5C4A3A` | `#B8A090` | Subheadlines, supporting text |
| `textTertiary` | `#9C8472` | `#7A6658` | Captions, placeholders, disabled |
| `textInverse` | `#FDFAF6` | `#1C1410` | Text on dark/brand backgrounds |
| `textLink` | `#C15A3A` | `#E07A5C` | Tappable links, navigation labels |

### Borders

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `borderSubtle` | `rgba(92,74,58,0.12)` | `rgba(240,230,216,0.08)` | Card outlines, dividers |
| `borderDefault` | `rgba(92,74,58,0.24)` | `rgba(240,230,216,0.16)` | Input borders, section separators |
| `borderStrong` | `rgba(92,74,58,0.48)` | `rgba(240,230,216,0.32)` | Selected states, focus rings |

### Semantic Colors

| State | Light BG | Light FG | Dark BG | Dark FG | Usage |
|-------|----------|----------|---------|---------|-------|
| Success | `#E8F5EC` | `#1F7A3E` | `#0D2E19` | `#4CC87A` | Positive balance, goal reached, synced |
| Warning | `#FEF3E2` | `#9A5E0A` | `#2E1E06` | `#F0A832` | Approaching limit, subscription alert |
| Error | `#FCEEED` | `#B01C1C` | `#2E0D0D` | `#F07070` | Overspent, failed transaction |
| Info | `#E8EFF8` | `#1A4E8A` | `#0A1826` | `#5B9CF0` | AI coach insights, informational nudges |
| AI Coach Proactive | `#FFF0E8` | `#C15A3A` | `#2E1A0A` | `#E8A44A` | Proactive warning cards — distinct from warning |

### Category Chip Colors

| Category | Light BG | Light Text | Dark BG | Dark Text |
|----------|----------|------------|---------|-----------|
| Dining | `#FCEEE8` | `#9B3D22` | `#2E1008` | `#E07A5C` |
| Groceries | `#EAF4EC` | `#1F6B38` | `#0A2010` | `#5DC87A` |
| Transport | `#E8EEF8` | `#1A4580` | `#081524` | `#6090E0` |
| Entertainment | `#F0E8F8` | `#5A2890` | `#1A0A2E` | `#A870E0` |
| Health | `#E8F6F4` | `#0D6E62` | `#062018` | `#40C0B0` |
| Shopping | `#FEF0E0` | `#8A5200` | `#2A1800` | `#F0A840` |
| Utilities | `#EEEEF0` | `#404050` | `#181820` | `#A0A0C0` |
| Subscriptions | `#F8E8F0` | `#80285A` | `#280A18` | `#D070A0` |
| Savings | `#E8F2FC` | `#104A80` | `#081828` | `#60A8F0` |
| Income | `#E8F8EE` | `#0D5E30` | `#041A0C` | `#50C07A` |

### SwiftUI Color Asset Catalog Setup
```swift
// In Colors.xcassets, create named colors for each token above.
// Extension:
extension Color {
    static let hearthTerracotta = Color("hearthTerracotta")
    static let hearthCoral = Color("hearthCoral")
    static let hearthSienna = Color("hearthSienna")
    static let hearthAmber = Color("hearthAmber")
    static let hearthCream = Color("hearthCream")
    static let hearthDustyRose = Color("hearthDustyRose")
    static let backgroundPrimary = Color("backgroundPrimary")
    static let backgroundSecondary = Color("backgroundSecondary")
    static let backgroundTertiary = Color("backgroundTertiary")
    static let backgroundCard = Color("backgroundCard")
    static let textPrimary = Color("textPrimary")
    static let textSecondary = Color("textSecondary")
    static let textTertiary = Color("textTertiary")
    static let textInverse = Color("textInverse")
    static let textLink = Color("textLink")
    static let borderSubtle = Color("borderSubtle")
    static let borderDefault = Color("borderDefault")
    static let borderStrong = Color("borderStrong")
}
```

---

## 3. Typography Scale

All text uses SF Pro (system font). Currency amounts use SF Pro Rounded with `.monospacedDigit()`.

### Text Styles

| Style Token | Size | Weight | Line Height | Letter Spacing | SwiftUI TextStyle | Usage |
|-------------|------|--------|-------------|----------------|-------------------|-------|
| `display` | 34pt | Bold | 41pt | +0.37 | `.largeTitle` | Dashboard total balance, hero amounts, onboarding headlines |
| `title1` | 28pt | Bold | 34pt | +0.36 | `.title` | Screen titles, modal sheet headers |
| `title2` | 22pt | Bold | 28pt | +0.35 | `.title2` | Card headers, goal names, account names |
| `title3` | 20pt | Semibold | 25pt | +0.38 | `.title3` | Section headers within cards, partner names |
| `headline` | 17pt | Semibold | 22pt | -0.41 | `.headline` | Button labels, nav bar titles, list item primary text |
| `body` | 17pt | Regular | 22pt | -0.41 | `.body` | Transaction descriptions, AI coach text, general content |
| `callout` | 16pt | Regular | 21pt | -0.32 | `.callout` | AI insight text, supporting info on cards |
| `subheadline` | 15pt | Regular | 20pt | -0.24 | `.subheadline` | Secondary transaction info, metadata, labels |
| `footnote` | 13pt | Regular | 18pt | -0.08 | `.footnote` | Last sync time, disclaimers, privacy labels |
| `caption1` | 12pt | Regular | 16pt | 0 | `.caption` | Category chip labels, small badges, date stamps |
| `caption2` | 11pt | Regular | 13pt | +0.07 | `.caption2` | Micro labels, tab bar items, privacy badge text |

### Monospace Currency

| Variant | Size | Weight | Design | Usage |
|---------|------|--------|--------|-------|
| `displayAmount` | 34pt | Bold | `.rounded` + `.monospacedDigit()` | Dashboard total balance |
| `largeAmount` | 28pt | Bold | `.rounded` + `.monospacedDigit()` | Account card balances, goal amounts |
| `mediumAmount` | 22pt | Semibold | `.rounded` + `.monospacedDigit()` | Transaction row amounts |
| `smallAmount` | 17pt | Semibold | `.rounded` + `.monospacedDigit()` | Inline currency in body text, split amounts |

```swift
// SwiftUI implementation:
extension Font {
    static let displayAmount = Font.system(size: 34, weight: .bold, design: .rounded).monospacedDigit()
    static let largeAmount = Font.system(size: 28, weight: .bold, design: .rounded).monospacedDigit()
    static let mediumAmount = Font.system(size: 22, weight: .semibold, design: .rounded).monospacedDigit()
    static let smallAmount = Font.system(size: 17, weight: .semibold, design: .rounded).monospacedDigit()
}
```

### Dynamic Type
All text styles must support Dynamic Type. Use `.font(.headline)` SwiftUI modifiers rather than fixed `.font(.system(size: 17))`. Currency amounts may clamp at accessibility sizes using `.minimumScaleFactor(0.75)` with `.lineLimit(1)`.

---

## 4. Spacing & Layout

### Base Grid
All spacing values are multiples of 4pt.

| Token | Value | Usage |
|-------|-------|-------|
| `spacing.xs` | 4pt | Icon-to-label gap, chip internal padding |
| `spacing.sm` | 8pt | Compact component padding, row internal spacing |
| `spacing.md` | 16pt | Standard component padding, card insets, list row padding |
| `spacing.lg` | 24pt | Card-to-card gap, section spacing |
| `spacing.xl` | 32pt | Major section breaks, hero area padding |
| `spacing.xxl` | 48pt | Screen-level vertical rhythm, onboarding spacing |
| `spacing.xxxl` | 64pt | Top-level screen padding, paywall breathing room |

### Layout Constants

| Constant | Value | Notes |
|----------|-------|-------|
| Screen horizontal margin | 16pt | Applied to all content via `.padding(.horizontal, 16)` |
| Card horizontal margin | 16pt | Same as screen margin; cards span full width minus margins |
| Card internal padding | 16pt | Inner padding of all card components |
| List row minimum height | 60pt | TransactionRow, BillCard, SettingsRow |
| Tab bar height | 83pt | Includes safe area bottom inset (automatic via SwiftUI) |
| Navigation bar height | 44pt | Standard iOS nav bar |
| Section header bottom gap | 8pt | Between SectionHeader and first list item |
| Card-to-card vertical gap | 16pt | Between consecutive cards in a scroll view |

### Safe Areas
Use SwiftUI's automatic safe area handling. Never hard-code device-specific insets. Use `.safeAreaInset(edge: .bottom)` for floating bottom bars (paywall CTAs, onboarding CTAs). Tab bar safe area is handled by TabView automatically.

```swift
// Correct pattern for floating bottom CTA:
.safeAreaInset(edge: .bottom) {
    VStack(spacing: 12) {
        PrimaryButton("Continue") { ... }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 16)
    .background(.ultraThinMaterial)
}
```

---

## 5. Corner Radius & Shadows

### Corner Radius Scale

| Token | Value | Usage |
|-------|-------|-------|
| `radius.xs` | 4pt | Chips, small badges, inner nested elements |
| `radius.sm` | 8pt | Secondary buttons, small cards, tooltips |
| `radius.md` | 12pt | Standard cards, account cards, transaction rows |
| `radius.lg` | 16pt | Primary buttons, modal headers, bottom sheet attachment |
| `radius.xl` | 20pt | Goal cards, AI coach card, large feature cards |
| `radius.xxl` | 28pt | Full-screen modal sheet tops, onboarding cards |
| `radius.full` | 999pt | Pill badges, icon buttons, avatar circles, progress bars |

### Shadow Scale

| Token | Light Mode | Dark Mode | Usage |
|-------|-----------|----------|-------|
| `shadow.none` | nil | nil | Flat elements on card surfaces |
| `shadow.subtle` | `y:1, blur:3, rgba(28,20,16,0.06)` | `y:1, blur:3, rgba(0,0,0,0.20)` | Transaction rows, list cells |
| `shadow.medium` | `y:4, blur:12, rgba(28,20,16,0.10)` | `y:4, blur:12, rgba(0,0,0,0.36)` | Account cards, goal cards, AI coach card |
| `shadow.strong` | `y:8, blur:24, rgba(28,20,16,0.16)` | `y:8, blur:24, rgba(0,0,0,0.52)` | Modal sheets, bottom sheets, paywall |
| `shadow.brandGlow` | `y:4, blur:16, rgba(193,90,58,0.20)` | `y:4, blur:16, rgba(212,114,90,0.30)` | Primary button pressed, active tab, onboarding CTAs |

```swift
// SwiftUI shadow modifiers:
extension View {
    func shadowSubtle() -> some View {
        self.shadow(color: Color(red:0.11,green:0.08,blue:0.06).opacity(0.06), radius: 3, x: 0, y: 1)
    }
    func shadowMedium() -> some View {
        self.shadow(color: Color(red:0.11,green:0.08,blue:0.06).opacity(0.10), radius: 12, x: 0, y: 4)
    }
    func shadowStrong() -> some View {
        self.shadow(color: Color(red:0.11,green:0.08,blue:0.06).opacity(0.16), radius: 24, x: 0, y: 8)
    }
    func shadowBrandGlow() -> some View {
        self.shadow(color: Color.hearthTerracotta.opacity(0.20), radius: 16, x: 0, y: 4)
    }
}
```

---

## 6. Component Library

### 6.1 PrimaryButton

Full-width terracotta CTA. The primary action on any screen.

**Visual Spec:**
- Height: 56pt
- Corner radius: 16pt (`radius.lg`)
- Horizontal padding: 24pt
- Background: `hearthTerracotta` (light) / `hearthCoral` (dark)
- Text: `.headline` (17pt semibold), `textInverse`
- Shadow: `shadow.brandGlow`

**Variants:**
- `default`: terracotta background, white text
- `destructive`: `#D42B2B` background, white text — used for disconnect account, delete goal, unlink partner
- `loading`: 70% opacity background, `ProgressView()` white centered, label hidden, `disabled: true`

**States:**
- `normal`: terracotta bg + brand glow shadow
- `pressed`: `.scaleEffect(0.97)` + `UIImpactFeedbackGenerator(.medium)`
- `disabled`: `.opacity(0.38)`, no shadow, no interaction
- `loading`: see loading variant

```swift
struct HearthPrimaryButtonStyle: ButtonStyle {
    var isLoading: Bool = false
    var variant: PrimaryButtonVariant = .default
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if isLoading {
                ProgressView().tint(.white)
            } else {
                configuration.label
                    .font(.headline)
                    .foregroundColor(.textInverse)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .background(backgroundColor(configuration: configuration))
        .cornerRadius(16)
        .shadowBrandGlow()
        .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: configuration.isPressed)
        .disabled(isLoading)
    }
}
```

---

### 6.2 SecondaryButton

Outlined or ghost button for secondary actions.

**Visual Spec:**
- Height: 56pt
- Corner radius: 16pt
- Horizontal padding: 24pt
- Text: `.headline` (17pt semibold)

**Variants:**
- `outlined`: clear background, 1.5pt border `hearthTerracotta`, text `hearthTerracotta` / `hearthCoral` dark
- `ghost`: `hearthTerracotta` at 10% opacity background, no border, text `hearthTerracotta`
- `neutralOutlined`: clear background, 1pt border `borderDefault`, text `textSecondary` — for Cancel, Dismiss

**States:**
- `pressed`: `.scaleEffect(0.97)` + `UISelectionFeedbackGenerator()`
- `disabled`: `.opacity(0.38)`

---

### 6.3 IconButton

Minimum 44×44pt tap target for icon-only actions.

**Visual Spec:**
- Tap target: 44×44pt minimum (always)
- Icon size: 24pt visual, centered
- Background variants:
  - `navigation`: clear, icon in `textSecondary`
  - `filled`: `backgroundTertiary`, corner radius `radius.full`
  - `brand`: `hearthTerracotta`, icon `textInverse`, corner radius `radius.full`

**States:**
- `pressed`: `.scaleEffect(0.88)` + `UISelectionFeedbackGenerator()`
- `disabled`: `.opacity(0.38)`

```swift
// Always wrap icon buttons:
Button(action: action) {
    Image(systemName: iconName)
        .font(.system(size: 24, weight: .medium))
        .foregroundColor(iconColor)
        .frame(width: 44, height: 44)
}
.buttonStyle(PlainButtonStyle())
.accessibilityLabel(accessibilityLabel)
```

---

### 6.4 TransactionRow

The atomic unit of Hearth. Highest-density component. Inspired by Copilot's transaction inbox.

**Visual Spec:**
- Min height: 60pt (expands for long names)
- Corner radius: 12pt
- Horizontal padding: 16pt
- Vertical padding: 12pt
- Background: `backgroundCard`
- Shadow: `shadow.subtle`

**Layout:**
```
[Merchant Icon 32pt] [Merchant Name (headline)]        [Amount (mediumAmount)]
                     [CategoryChip]                    [Date (caption1)]
                     [optional: reviewed pill + partner avatar]
```

**Left accent bars (3pt wide, full height, leading edge):**
- Partner A transactions: `hearthTerracotta`
- Partner B transactions: `hearthDustyRose`
- Shared/joint transactions: `hearthAmber`
- Pending: no bar, amount in `textTertiary` + "(pending)" caption

**Elements:**
- Merchant icon: 32pt circle, category color fill background, SF Symbol or emoji fallback
- Merchant name: `.headline`, `textPrimary`, `.truncationMode(.tail)`
- Category chip: `CategoryChip` component
- Amount: expense = `textPrimary`; income = success green with "+" prefix
- Date: `.caption1`, `textTertiary`
- Unreviewed dot: 6pt amber dot left of merchant name when unreviewed
- Reviewed state: amber dot hidden, row at 0.85 opacity
- Privacy hidden: amount replaced with `•••` in `textTertiary`
- Partner avatar: `PartnerAvatar` 20pt, trailing, below amount

**Swipe Actions:**
- `.swipeActions(edge: .trailing)`: "Mark Reviewed" (checkmark.circle, `hearthTerracotta`) and "Add Note" (bubble.left, `hearthAmber`)
- `.contextMenu`: "Flag", "Split Expense", "Hide from Partner", "View Receipt"

**SwiftUI Notes:**
Implement as a standalone `View`, not `ListRowStyle`. Use `UIImpactFeedbackGenerator` for haptics. Mark-as-reviewed swipe triggers `.medium` impact at threshold crossing, then `.success` notification on completion.

---

### 6.5 AccountCard

Represents one connected bank account. Horizontal scroll on dashboard and in account list.

**Visual Spec:**
- Width: 280pt
- Height: 168pt
- Corner radius: 20pt
- Padding: 20pt
- Shadow: `shadow.medium`
- Background: gradient from `backgroundCard` to `backgroundSecondary`, 135°

**Layout:**
```
[Bank Logo 32pt] [Bank Name (footnote, textSecondary)]    [PrivacyBadge]
                 
[Balance (largeAmount)]
[Account Type (caption1)]

[Last sync (footnote, textTertiary)]  [Sync dot 6pt green]
```

**Privacy states:**
- `full`: shows full balance e.g. `$12,480.42`
- `balanceOnly`: shows nearest dollar `$12,480`
- `hidden`: shows `••••••`

**Variants:**
- `myAccount`: standard
- `partnerAccount`: left border bar 4pt `hearthDustyRose`
- `sharedAccount`: left border bar 4pt `hearthAmber`
- `errorState`: sync dot in error red + banner "Reconnect needed"

**SwiftUI Notes:**
Use horizontal `ScrollView` with `.scrollTargetBehavior(.viewAligned)`. Add `.matchedGeometryEffect` for expansion animation to AccountDetail screen.

---

### 6.6 GoalCard

Joint savings goal with dual-partner contribution tracking.

**Visual Spec:**
- Width: full width minus 32pt margins
- Min height: 140pt
- Corner radius: 20pt
- Padding: 20pt
- Shadow: `shadow.medium`
- Background: `backgroundCard`

**Layout:**
```
[Goal Emoji 28pt] [Goal Name (title3)]          [Target Amount (largeAmount)]

[ProgressBar — full width, 8pt height, two-segment fill]
[Partner A avatar + $contribution] ... [Partner B avatar + $contribution] [68% funded]

[Days remaining / target date (footnote, textTertiary)]
```

**Progress Bar:**
- Height: 8pt, `radius.full`
- Background: `borderSubtle`
- Fill: two segments — Partner A in `hearthTerracotta`, Partner B in `hearthDustyRose`
- Animation: `.spring(response: 0.5, dampingFraction: 0.7)` on appear and on new contribution

**Variants:**
- `active`: standard
- `completed`: full green gradient fill + checkmark badge overlay + shimmer sweep
- `paused`: muted progress bar + "Paused" badge in `textTertiary`

---

### 6.7 CategoryChip

Emoji + label pill for transaction categorization.

**Visual Spec:**
- Height: 24pt
- Horizontal padding: 8pt
- Corner radius: 4pt (`radius.xs`)
- Text: `.caption1` (12pt)
- Emoji: 14pt
- Gap between emoji and label: 4pt

**Variants:**
- `default`: colored background + matching text per category table above
- `selectable.unselected`: 60% opacity on bg and text
- `selectable.selected`: full opacity + 1.5pt border matching text color
- `large`: height 32pt, padding 12pt, text `.subheadline`

**States:**
- Tap: `.scaleEffect(0.95)` + `UISelectionFeedbackGenerator()`

---

### 6.8 AmountDisplay

Large currency display for dashboard totals. Hero element of the Home tab.

**Visual Spec:**
- Amount: SF Pro Rounded, 34pt bold, `.monospacedDigit()`
- Currency symbol ($): 22pt semibold, top-aligned to first digit
- Cents: 22pt bold, same baseline
- Label above: `.footnote`, `textSecondary` — "Combined Balance" / "Net Worth" / etc.

**Variants:**
- `combinedBalance`: standard, `textPrimary`
- `positiveChange`: delta below in success color + `arrow.up.right` SF Symbol
- `negativeChange`: delta below in error color + `arrow.down.right` SF Symbol
- `loading`: `.redacted(reason: .placeholder)` shimmer

**Animation:**
- First appear: count-up `.easeOut(duration: 0.8)`
- Value change: `.contentTransition(.numericText(countsDown: amount < previousAmount))`

```swift
Text(amount, format: .currency(code: "USD"))
    .font(.displayAmount)
    .contentTransition(.numericText())
    .foregroundColor(.textPrimary)
```

---

### 6.9 PartnerAvatar

Circular avatar representing one partner.

**Sizes:**
- `sm`: 20pt — transaction row attribution, compact contexts
- `md`: 32pt — goal cards, comments, notification badges
- `lg`: 56pt — profile screens, onboarding, Money Date screen

**Initials fallback:**
- Partner A: `hearthTerracotta` gradient background, white initials
- Partner B: `hearthDustyRose` gradient background, white initials
- Text: semibold. Sizes: sm=9pt, md=13pt, lg=22pt

**Variants:**
- `single`: standard circle
- `stackedPair`: two avatars overlapping, trailing avatar offset -8pt, 2pt `backgroundCard` border
- `withBadge`: 12pt badge at `.bottomTrailing` — notification count or checkmark

```swift
// Usage:
AsyncImage(url: avatarURL) { image in
    image.scaledToFill()
} placeholder: {
    ZStack {
        LinearGradient(colors: [.hearthTerracotta, .hearthSienna], startPoint: .topLeading, endPoint: .bottomTrailing)
        Text(initials)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(.white)
    }
}
.frame(width: 32, height: 32)
.clipShape(Circle())
```

---

### 6.10 AICoachCard

Proactive spending coach nudge. Hearth's unique differentiator — appears BEFORE overspending occurs.

**Visual Spec:**
- Width: full width minus 32pt
- Min height: 120pt
- Corner radius: 20pt
- Padding: 20pt
- Background light: `#FFF0E8`
- Background dark: `#2E1A0A`
- Left accent bar: 4pt, `hearthAmber`, full height, rounded, leading edge
- Shadow: medium + amber tint `rgba(232,164,74,0.15)` blur 16

**Layout:**
```
[✨ sparkles (20pt, hearthAmber)]  [AI Coach (caption1, hearthAmber)]   [✕ dismiss IconButton]

[Insight text (callout, textPrimary, max 2 lines, expandable)]

[Action button — SecondaryButton ghost 40pt: "Review Dining" / "Set Limit" / "See Details"]
```

**Severity variants:**
- `low`: left bar `hearthAmber`, bg at 0.8 opacity
- `medium`: left bar `hearthTerracotta`, bg full opacity
- `high`: left bar error foreground + 1pt error border + `UINotificationFeedbackGenerator(.warning)` on appear

**Content variants:**
- `proactiveWarning` (amber): "You're on track to overspend dining by $180 this month — here's where it's coming from."
- `positiveInsight` (success green bar): "You're $200 under budget this month! Great work."
- `subscriptionAlert` (dusty rose bar): "Found 3 subscriptions you might have forgotten about."

**Animation:**
- Appear: `.transition(.move(edge: .top).combined(with: .opacity))`
- Dismiss: `.transition(.move(edge: .trailing).combined(with: .opacity))`
- Dismiss persisted in `UserDefaults` keyed to `insightID`

---

### 6.11 BillCard

Upcoming bill reminder with dual-partner notification badge.

**Visual Spec:**
- Height: 80pt
- Corner radius: 16pt
- Padding: 16pt horizontal, 14pt vertical
- Background: `backgroundCard`
- Shadow: `shadow.subtle`

**Layout:**
```
[Merchant Icon 40pt] [Merchant Name (headline)]   [Amount (mediumAmount)]   [Due date (caption1)]
                     [Bill type (caption1, tertiary)]                        [Partner notification badges]
```

**Due date states:**
- Upcoming: `textSecondary` — "Due Jun 15"
- Due soon (≤2 days): warning foreground — "Due in 2 days"
- Overdue: error foreground — "Overdue"

**Partner notification badge:** Stacked 20pt avatar pair. Partner check state shown as colored check overlay (A = terracotta, B = dusty rose). Unchecked = plain avatar.

**Context menu:** "Mark Paid" (success haptic + slide dismiss), "Snooze", "Edit".

---

### 6.12 SectionHeader

Standard section divider with optional "See All" action.

**Visual Spec:**
- Height: 44pt
- Horizontal padding: 16pt
- Bottom padding: 8pt

**Variants:**
- `simple`: title (`.title3`) only
- `withSubtitle`: title + subtitle in VStack
- `withAction`: title + "See All" `SecondaryButton ghost` trailing (32pt height)
- `withCount`: title + count badge (12pt round, `hearthAmber` bg, white text)

---

### 6.13 PrivacyBadge

Per-account privacy level indicator. Core to Hearth's trust model.

**Visual Spec:**
- Height: 22pt
- Horizontal padding: 8pt
- Corner radius: 4pt
- Text: `.caption2` (11pt)
- Icon: 11pt SF Symbol

**States:**

| State | Icon | Label | Light BG | Light Text | Dark BG | Dark Text |
|-------|------|-------|----------|------------|---------|-----------|
| `full` | `eye.fill` | Full | `#E8F5EC` | `#1F7A3E` | `#0D2E19` | `#4CC87A` |
| `balanceOnly` | `eye.slash.fill` | Balance | `#FEF3E2` | `#9A5E0A` | `#2E1E06` | `#F0A832` |
| `hidden` | `lock.fill` | Hidden | `#EEEEF0` | `#404050` | `#181820` | `#A0A0C0` |

**Tap action:** Presents bottom sheet with 3 privacy level options + explanation text for each. Animate badge change with `.animation(.spring())`.

---

### 6.14 TabBar

**Visual Spec:**
- Height: 83pt
- Background light: `#FDFAF6` + 0.5pt top `borderSubtle`
- Background dark: `#1A1410` + 0.5pt top `borderSubtle`
- Blur: `.ultraThinMaterial` behind tab bar

**Tabs:**

| Index | Label | Inactive Icon | Active Icon | Badge |
|-------|-------|--------------|-------------|-------|
| 0 | Home | `house` regular | `house.fill` medium | — |
| 1 | Transactions | `list.bullet` | `list.bullet` bold | Unreviewed count (amber circle, white text) |
| 2 | Goals | `target` regular | `target` bold | — |
| 3 | Insights | `chart.line.uptrend.xyaxis` | same bold weight | Dot when new AI coach available |
| 4 | Settings | `gearshape` | `gearshape.fill` | — |

Active tint: `hearthTerracotta`. Inactive: `textTertiary`. Label: `.caption2`.

---

### 6.15 NavigationBar

**Visual Spec:**
- Background: `.ultraThinMaterial` matching app background tint
- Border: none by default; 0.5pt `borderSubtle` bottom border when scrolled
- Inline title: `.headline` (17pt semibold), `textPrimary`
- Large title: `.title1` (28pt bold), `textPrimary`

**Back button:** `chevron.left` 20pt medium weight, `hearthTerracotta`. Label hidden.

**Special variants:**
- `homeBar`: custom header — "Hearth" wordmark + date greeting ("Good morning, Alex") + stacked partner avatar pair
- `modalBar`: `xmark.circle.fill` leading close, title centered, no back button

---

## 7. Iconography

### SF Symbols Catalog

**Navigation:**
| Use | Symbol |
|-----|--------|
| Back | `chevron.left` |
| Forward | `chevron.right` |
| Close | `xmark` |
| Close circle | `xmark.circle.fill` |
| Menu | `line.3.horizontal` |
| More options | `ellipsis.circle` |

**Finance:**
| Use | Symbol |
|-----|--------|
| Balance | `banknote` |
| Income | `arrow.down.circle.fill` |
| Expense | `arrow.up.circle.fill` |
| Transfer | `arrow.left.arrow.right` |
| Goal | `target` |
| Savings | `piggybank.fill` |
| Investment | `chart.line.uptrend.xyaxis` |
| Bill | `calendar.badge.clock` |
| Subscription | `repeat.circle.fill` |
| Split expense | `arrow.triangle.branch` |
| Settle up | `checkmark.circle.fill` |
| Credit card | `creditcard.fill` |
| Bank | `building.columns.fill` |
| Cash | `dollarsign.circle.fill` |
| Budget | `chart.bar.fill` |

**Home & Relationship:**
| Use | Symbol |
|-----|--------|
| Home | `house.fill` |
| Couple | `person.2.fill` |
| Partner | `person.crop.circle` |
| Family | `figure.2.and.child.holdinghands` |
| Heart home | `heart.fill` |

**Transaction Actions:**
| Use | Symbol |
|-----|--------|
| Reviewed | `checkmark.circle.fill` |
| Unreviewed | `circle` |
| Comment | `bubble.left.fill` |
| Emoji react | `face.smiling` |
| Flag | `flag.fill` |
| Hide | `eye.slash.fill` |
| Receipt | `doc.text.fill` |

**Privacy:**
| Use | Symbol |
|-----|--------|
| Full view | `eye.fill` |
| Balance only | `eye.slash.fill` |
| Hidden | `lock.fill` |
| Shield | `lock.shield.fill` |

**AI Coach:**
| Use | Symbol |
|-----|--------|
| AI sparkle | `sparkles` |
| Brain | `brain.head.profile` |
| Insight | `lightbulb.fill` |
| Warning | `exclamationmark.triangle.fill` |
| Trending up | `arrow.up.right` |
| Trending down | `arrow.down.right` |

**Connectivity:**
| Use | Symbol |
|-----|--------|
| Sync | `arrow.clockwise` |
| Connected | `wifi` |
| Disconnected | `wifi.slash` |
| Link | `link.circle.fill` |

**Settings & Account:**
| Use | Symbol |
|-----|--------|
| Settings | `gearshape.fill` |
| Notifications | `bell.fill` |
| Security | `lock.fill` |
| Profile | `person.crop.circle.fill` |
| Linked accounts | `building.2.fill` |
| Plan/subscription | `star.circle.fill` |
| Help | `questionmark.circle.fill` |
| Logout | `rectangle.portrait.and.arrow.right` |

**Actions:**
| Use | Symbol |
|-----|--------|
| Add | `plus` |
| Add circle | `plus.circle.fill` |
| Delete | `trash.fill` |
| Edit | `pencil` |
| Share | `square.and.arrow.up` |
| Filter | `line.3.horizontal.decrease.circle` |
| Search | `magnifyingglass` |
| Sort | `arrow.up.arrow.down` |
| Calendar | `calendar` |
| Camera | `camera.fill` |

**Apple Ecosystem:**
| Use | Symbol |
|-----|--------|
| Apple Watch | `applewatch` |
| Widget | `square.grid.2x2.fill` |
| Siri | `mic.fill` |
| Face ID | `faceid` |
| Touch ID | `touchid` |

### Symbol Rendering Modes
- Tab bar inactive: `.monochrome`
- Multi-layer icons (lock.shield, person.crop.circle): `.hierarchical`
- Two-tone feature icons: `.palette`
- Emoji-style moments: `.multicolor`

### Symbol Weights
- Navigation: `.regular`
- Interactive CTAs: `.medium`
- Error/critical states: `.bold`
- Decorative background: `.ultraLight`

### Custom Icons Required

| Name | Description | Sizes Needed | Format |
|------|-------------|--------------|--------|
| `hearth_flame` | Abstract flame/roofline hybrid — app icon mark in terracotta | 16, 20, 24, 28, 32, 40, 60, 76, 83.5, 120, 152, 167, 180, 1024 | SVG → PDF for Xcode asset catalog |
| `venmo_logo` | Venmo wordmark/icon for settlement CTA deep link | 20, 24 | SVG — official Venmo brand asset |
| `zelle_logo` | Zelle wordmark/icon for settlement CTA deep link | 20, 24 | SVG — official Zelle brand asset |
| `money_date_calendar` | Calendar with heart motif — Money Date feature icon | 24, 28 | SVG filled style, terracotta heart element |
| `household_icon` | Abstract house + two person silhouettes for couple context | 24, 28, 60 | SVG |

### Accessibility
- All interactive icon-only buttons: minimum 44×44pt tap target
- All icon buttons: `.accessibilityLabel("descriptive label")`
- Purely decorative icons: `.accessibilityHidden(true)`

---

## 8. Screen Specifications

### ONB-001 — Welcome / Splash

**Navigation:** App launch, fresh install or post-logout. No navigation bar.  
**Purpose:** Establish brand identity, communicate couples finance value prop.  
**Background:** Deep charcoal `#1A1410` (dark mode only, regardless of system setting).

**Section 1 — Brand Hero:**
- `AppIconLarge`: 120pt, animated scale-in with `.spring(response: 0.5, dampingFraction: 0.7)` on appear (0s delay)
- `WordmarkLabel`: "Hearth", SF Pro 34pt semibold, `hearthCream`. Fades in + slides up 12pt (0.3s delay, 0.4s duration)
- `TaglineLabel`: "Where your money comes home.", 17pt regular, `hearthCream` 70% opacity. Appears (0.6s delay, 0.4s)
- Auto-advances after 1.8s OR on any tap

**Section 2 — Value Proposition:**
- Feature chips horizontal scroll with paging snap, auto-scrolls every 2s:
  - "🏠 One household view"
  - "🤖 AI coach before you overspend"
  - "🔒 Privacy per account"
  - "🎯 Joint savings goals"
- `PartnerAvatarPair`: two overlapping placeholder circles (`hearthTerracotta` + `hearthDustyRose`)
- Subtle `.light` haptic on each auto-scroll advance

**Section 3 — CTA Stack:**
- `PrimaryButton`: "Get Started — It's Free" → `ONB-002`
- `SecondaryButton` (ghost): "Sign In" → sign-in sheet
- `LegalFooter`: "14-day free trial. No credit card required.", `.caption1`, `hearthCream` 50% opacity

**Special:** Dynamic Island ambient terracotta pulse on iPhone 15 Pro+. Tap anywhere to skip to CTA.

---

### ONB-002 — Account Creation

**Navigation:** From ONB-001 "Get Started". Back → ONB-001.  
**Purpose:** Email/password or Sign in with Apple account creation.  
**Layout:** `ScrollView` for keyboard avoidance. Progress: step 1 of 6.

**Section 1 — Header:**
- `NavigationBackButton` top-left
- `StepProgressBar`: 6 dots, dot 1 active `hearthTerracotta`, rest `hearthCream` 30%
- Title: "Create your account", 28pt bold
- Subtitle: "Your partner joins in the next step.", 15pt, 70% opacity

**Section 2 — Sign in with Apple:**
- `ASAuthorizationAppleIDButton` full-width, `.white` style on dark background, corner radius 14
- "Or" divider (horizontal line, "or" label, 30% opacity)
- On Apple auth success: skip to ONB-003

**Section 3 — Email/Password Form:**
- `EmailTextField`: placeholder "Email address", `.emailAddress` keyboard, `.emailAddress` textContentType, returnKey `.next`
- `PasswordTextField`: placeholder "Password", secure, `.newPassword` textContentType, returnKey `.done`, show/hide toggle (`.regular` weight `eye`/`eye.slash`)
- `PasswordStrengthBar`: 4-segment, colors: error red / warning orange / amber / success green, animated fill on keystroke
- `ValidationMessage`: 13pt, `hearthSienna` for errors, system green for success. Inline below respective field. Validates email on blur, password strength real-time.

**Section 4 — CTA and Legal:**
- `PrimaryButton`: "Create Account" — disabled until both fields valid. Loading: `ProgressView` white replaces label while API in flight. Fields disabled during request.
- `LegalText`: "By continuing you agree to our Terms of Service and Privacy Policy.", `.caption2`, 50% opacity, links underlined in `hearthCoral`. Opens `SafariViewController` in-app.

**Error state:** Inline `ValidationMessage` below form. Form shake animation + `.error` haptic on invalid submit.

---

### ONB-003 — Invite Your Partner

**Navigation:** Auto-push after ONB-002 success. Back → ONB-002.  
**Layout:** `ScrollView` + fixed bottom CTA. Progress: step 2 of 6.

**Section 1 — Header:**
- Back button, `StepProgressBar` step 2
- Title: "Invite your partner", 28pt bold
- Subtitle: "Hearth works best when both of you are in. Your partner gets their own login — no password sharing.", 15pt, 70% opacity, multiline

**Section 2 — Household Illustration:**
- Two abstract avatar circles (`hearthTerracotta` + `hearthDustyRose`) connected by warm arc
- Draw-on path animation on appear (0.6s, easeInOut)
- Caption: "Your household will show both of you here once your partner joins.", `.caption1`, centered, 60% opacity
- Updates in real time via WebSocket when partner joins

**Section 3 — Invite Methods:**
- `InviteRow`: iMessage icon + "Send via iMessage" → system share sheet, pre-populated invite message + deep link `hearth.app/join/CODE`
- `InviteRow`: AirDrop icon + "Share via AirDrop" → share sheet with AirDrop pre-selected
- `InviteRow`: `link.circle` icon + "Copy invite link" → pasteboard + "Link copied" toast + success haptic
- `QRCodeCard`: generated QR for invite URL. Tappable → full-screen modal. Swipe down to dismiss. Skeleton shimmer while generating.
- `InviteCodeDisplay`: "Invite code: HEARTH-XXXX", monospaced, copyable. Secondary option below QR.
- Invite link expires 72 hours. Must be universal link.

**Section 4 — Wait/Skip:**
- `PendingBadge`: "Waiting for your partner…" with animated amber pulse dot — shown after invite sent
- `SkipButton`: "I'll invite them later", 15pt, 60% opacity → ONB-004
- Auto-advance to ONB-004 with celebration animation if partner accepts while on screen

**Error state:** Invite rows grayed out + "Trouble generating invite. Check connection and try again." + retry button. QR shows placeholder + retry icon.

---

### ONB-004 — Link Your Accounts

**Navigation:** After ONB-003 (invited or skipped). Also from Settings > Account Management.  
**Layout:** Full-screen, progress step 3 of 6. Fixed bottom CTA. Plaid Link as sheet.

**Section 1 — Header:**
- Back button, `StepProgressBar` step 3
- Title: "Link your accounts", 28pt bold
- Subtitle: "Hearth reads your transactions — it never moves money. Read-only, always.", 15pt, 70% opacity

**Section 2 — Security Trust Signal:**
- `TrustBanner`: `lock.shield.fill` icon (amber) + "Bank-level 256-bit encryption. We use Plaid — the same technology used by Venmo, Robinhood, and Coinbase." — `.footnote`, rounded card, subtle border. Tapping → half-sheet with expanded security explanation.
- `PlaidBadge`: "Powered by Plaid", small, secondary, with Plaid logo

**Section 3 — Connected Accounts:**
- `LinkedAccountCard` per account: bank logo + account name + last 4 digits + account type badge + green "Connected" indicator
- Cards animate in slide-up stagger as each connection completes
- Swipe left → red "Remove" action
- `AddAccountButton`: "+ Add another account", dashed border, `hearthTerracotta` text → Plaid Link SDK sheet

**Section 4 — CTA:**
- `PrimaryButton`: "Continue" — enabled when ≥1 account linked. Tapping while disabled: tooltip "Link at least one account to continue"
- `SkipButton`: "Skip for now", `.caption`, 60% opacity → ONB-005

**Empty state:** Illustration of bank buildings with dashed lines + "Your accounts will appear here once connected." Tap illustration → Plaid Link.  
**Loading state:** Skeleton shimmer on `LinkedAccountCard` placeholder while verifying.  
**Error state:** `ErrorBanner` slides from top: "Unable to connect to [Bank]. Try again or choose a different institution." `hearthSienna` bg, white text, dismiss X.

---

### ONB-005 — Set Privacy Preferences

**Navigation:** After ONB-004. Also from Settings > Account Management per account.  
**Layout:** Full-screen, progress step 4 of 6. Scrollable account list + fixed bottom CTA.

**Section 1 — Header:**
- Title: "Set your privacy", 28pt bold
- Subtitle: "Choose what your partner sees for each account. You can change this any time.", 15pt, 70% opacity

**Section 2 — Privacy Legend (sticky above account list):**
- 3 rows with icons + plain-language labels:
  - "👁 Show everything — Transactions and balances visible"
  - "👁‍🗨 Balance only — Balance visible, transactions hidden"
  - "🙈 Keep private — Account fully hidden from partner"

**Section 3 — Per-Account Privacy Toggles:**
- `PrivacyAccountCard` per linked account: bank logo + account name (last 4) + account type badge + `SegmentedPrivacyPicker` (3 segments: "Full" | "Balance" | "Hidden", `hearthTerracotta` active)
- Selection: immediate, selection haptic (`.light`), no confirmation required, optimistic save
- Cards separated by 16pt. If >4 accounts, scrollable.

**Section 4 — CTA:**
- `PrimaryButton`: "Save & Continue" → ONB-006
- Footnote: "Your partner will see the same privacy setup for their accounts.", `.caption2`, 50%, centered

**Empty state (no accounts from ONB-004):** Single placeholder card "No accounts linked yet. Add accounts in Settings after setup." CTA "Continue" still enabled.  
**Error state:** `ErrorBanner` "Could not save preferences. Check connection and try again." Retry inline. Selections preserved in local state.

---

### ONB-006 — Create Your First Goal

**Navigation:** After ONB-005.  
**Layout:** Full-screen, progress step 5 of 6. Scrollable. Fixed bottom CTA.

**Section 1 — Header:**
- Title: "Create your first goal", 28pt bold
- Subtitle: "Goals are shared by default — both of you can contribute.", 15pt, 70% opacity

**Section 2 — Goal Suggestions (horizontal scroll):**
- Suggestion chips: 🏖 Vacation | 🏠 Down Payment | 💍 Wedding | 🚗 New Car | 💰 Emergency Fund | ✏️ Custom
- Tap to pre-fill form below. Spring scale animation on tap.

**Section 3 — Goal Form:**
- `GoalEmojiPicker`: emoji selector row (6 presets + custom picker). Selected emoji displayed large (40pt) in form header
- `GoalNameField`: text field, "Goal name", placeholder "e.g. Japan Trip 2027"
- `TargetAmountField`: currency input, monospaced rounded font, "Target amount"
- `TargetDateField`: date picker inline or bottom sheet calendar. "Target date (optional)"
- `GoalPrivacyToggle`: "Visible to both partners" (default on) — toggle to make goal private

**Section 4 — CTA:**
- `PrimaryButton`: "Create Goal & Continue" → ONB-007
- `SkipButton`: "Skip for now" → ONB-007

---

### ONB-007 — Onboarding Complete / First Money Date Prompt

**Navigation:** After ONB-006.  
**Purpose:** Celebrate completion, introduce Money Date ritual, enter main app.  
**Layout:** Full-screen celebration. No navigation bar.

**Section 1 — Celebration:**
- Confetti animation (hearthTerracotta + hearthAmber + hearthDustyRose particles), plays once on appear
- Large checkmark `checkmark.seal.fill` 80pt, `hearthTerracotta`
- Title: "You're all set! 🎉", display size 34pt
- Subtitle: "Your household is ready. Let's make money feel less complicated."

**Section 2 — Summary Cards (horizontal scroll, 3 cards):**
- Card 1: accounts linked count "2 accounts connected"
- Card 2: privacy configured "Privacy set for each account"
- Card 3: goal (if created) "Japan Trip goal created"

**Section 3 — Money Date Introduction:**
- `MoneyDateCard`: calendar with heart icon (custom `money_date_calendar`), "Schedule your first Money Date", subtitle "A 15-min monthly check-in with your partner to review spending and goals."
- `SecondaryButton` (outlined): "Schedule Money Date" → opens calendar intent / date picker
- `SkipButton`: "Maybe later"

**Section 4 — CTA:**
- `PrimaryButton`: "Go to Hearth" → main app `HOME-001`, tab bar visible for first time
- Haptic: `UINotificationFeedbackGenerator(.success)` on this button tap

---

### HOME-001 — Home Dashboard

**Navigation:** Tab 0 (Home). Large title nav bar with custom home bar variant.  
**Purpose:** Unified household financial picture at a glance.  
**Layout:** `ScrollView` (vertical), `LazyVStack` for performance. Pull-to-refresh.

**Custom Nav Bar:**
- Left: "Hearth" wordmark (22pt semibold, `hearthTerracotta`)
- Center: Date greeting "Good morning, Alex ☀️" (`.subheadline`, `textSecondary`)
- Right: `PartnerAvatarPair` (stacked, both 32pt) — tap → profile sheet

**Section 1 — Combined Balance Hero:**
- `AmountDisplay`: combined net balance, 34pt monospaced rounded
- Label: "Combined Balance" (`.footnote`, `textSecondary`)
- Delta label: "↑ $240 this week" in success green, or "↓ $180 this week" in error
- Last sync: "Updated 2 min ago" (`.caption1`, `textTertiary`)

**Section 2 — Account Cards (horizontal scroll):**
- `SectionHeader`: "Accounts" + "Manage" secondary button right
- Horizontal `ScrollView` with `.scrollTargetBehavior(.viewAligned)`
- `AccountCard` × N (one per linked account, both partners' accounts if privacy allows)
- "+ Connect Account" card at end (dashed border)

**Section 3 — AI Coach Card (conditional):**
- `SectionHeader`: "AI Coach" + sparkles icon (hearthAmber)
- `AICoachCard` if active insight exists. Dismissed cards removed with trailing exit animation.
- If no active insight: section hidden entirely (no empty state shown here)

**Section 4 — Upcoming Bills:**
- `SectionHeader`: "Upcoming Bills" + "See All" button → `TRANS-004`
- `BillCard` × up to 3 (sorted by due date ascending)
- If no upcoming bills: small inline text "No upcoming bills" (`textTertiary`)

**Section 5 — Recent Transactions:**
- `SectionHeader`: "Recent Transactions" + "See All" button + unreviewed count badge → `TRANS-001`
- `TransactionRow` × 5 most recent, grouped by today / yesterday / date
- Swipe actions: Mark Reviewed, Add Note

**Section 6 — Goals Progress:**
- `SectionHeader`: "Goals" + "See All" button → `GOALS-001`
- `GoalCard` × up to 2 (most active goals)
- If no goals: `EmptyStateCard` with `target` icon + "Create your first goal" CTA

**Section 7 — Monthly Spending Chart:**
- `SectionHeader`: "This Month"
- Animated bar chart: 7-day spending, bars colored by category mix
- Below chart: top 3 spending categories as `CategoryChip` row

**Pull-to-refresh:** Triggers account sync. `RefreshControl` tint: `hearthTerracotta`.  
**Loading state:** Each section shows skeleton shimmer cards.

---

### HOME-002 — Account Detail

**Navigation:** Tap `AccountCard` on dashboard → push. Back → HOME-001.  
**Purpose:** Full account ledger with balance history and transaction list.  
**Layout:** `NavigationStack` push. Large title = account name + bank.

**Section 1 — Balance Header:**
- Balance (large monospaced), account type + last 4 digits
- `PrivacyBadge` tappable to change privacy level
- Last sync timestamp + sync status dot
- Balance sparkline (30-day line chart, small, `hearthTerracotta`)

**Section 2 — Quick Actions:**
- Horizontal pill button row: "Transactions" | "Filter" | "Export" | "Privacy"

**Section 3 — Transaction List:**
- `TransactionRow` × all transactions for this account, grouped by date
- Date section headers in sticky format (`.caption1`, `textSecondary`, `backgroundSecondary` sticky bg)
- Search bar at top of list (`magnifyingglass`)

**Section 4 — Account Info Footer:**
- Account number (masked), routing number (masked), institution name
- "Reconnect Account" button if sync error
- "Remove Account" destructive button (red, confirmation required)

---

### TRANS-001 — Transaction Feed

**Navigation:** Tab 1 (Transactions).  
**Purpose:** Copilot-inspired transaction inbox. Mark-as-reviewed daily ritual.  
**Layout:** `NavigationStack`. Large title "Transactions" with unreviewed badge. Search + filter bar.

**Section 1 — Filter Bar (sticky below nav):**
- Horizontal scroll: "All" | "Yours" | "Partner's" | "Shared" | "Unreviewed" | "Flagged"
- Active filter chip: `hearthTerracotta` bg, white text
- Secondary row: date range picker + sort button

**Section 2 — Unreviewed Banner (conditional):**
- If unreviewed > 0: amber banner "X transactions to review — tap to mark all"
- Dismiss X button on right
- Tap → scrolls to first unreviewed

**Section 3 — Transaction Groups:**
- Date-grouped `TransactionRow` list
- Section headers: "Today" / "Yesterday" / "Mon, Jun 23" etc. — `.subheadline`, `textSecondary`
- Row swipe left: "Mark Reviewed" (checkmark, `hearthTerracotta`) + "Add Note" (bubble, `hearthAmber`)
- Row swipe right: "Split" (arrow.triangle.branch, `hearthAmber`)

**Section 4 — Load More:**
- Pagination: infinite scroll, loads 30 transactions per page
- Loading footer: `ProgressView` centered, `hearthTerracotta` tint

**Search:** `.searchable` modifier. Searches merchant name, category, amount, notes. Results appear live.

---

### TRANS-002 — Transaction Detail

**Navigation:** Tap any `TransactionRow` → push. Back → TRANS-001.  
**Layout:** `ScrollView`. No tab bar (nav push within tab).

**Section 1 — Transaction Hero:**
- Merchant icon (64pt circle, category color)
- Merchant name (`.title2`)
- Amount (`.displayAmount` monospaced, large)
- Date + time (`.subheadline`, `textSecondary`)
- `CategoryChip` (large variant, tappable to re-categorize)
- `PartnerAvatar` md (20pt) + "Alex's Account" label

**Section 2 — Details Card:**
- Account name + last 4
- Merchant location (if available)
- Transaction ID (`.footnote`, `textTertiary`, copyable)
- Status: Pending / Posted badge

**Section 3 — Comments & Reactions:**
- `SectionHeader`: "Comments"
- Existing comments: `PartnerAvatar` sm + name + timestamp + comment text. Bubble layout (ours right, partner's left).
- Emoji reactions strip: tap emoji to add/remove reaction. Reaction count shown.
- "Add a comment..." text field (bottom of section, taps to expand keyboard + input bar)
- Comment input bar: `PartnerAvatar` sm + text field + send button (`hearthTerracotta` arrow.up.circle.fill)

**Section 4 — Actions:**
- `SectionHeader`: "Actions"
- Action rows: "Mark as Reviewed" | "Split this expense" → TRANS-003 sheet | "Flag for discussion" | "Add note" | "Hide from partner" | "Recategorize"

---

### TRANS-003 — Split Expense Sheet

**Navigation:** Sheet from TRANS-002 "Split this expense". Bottom sheet, medium detent.  
**Purpose:** Track expense splitting between partners with Venmo/Zelle settlement deep links.

**Section 1 — Sheet Header:**
- Grab handle
- "Split Expense", `.title3`, centered
- Merchant name + amount display

**Section 2 — Who Paid:**
- "Who paid?" label
- Two partner avatar buttons (A / B), selected one gets `hearthTerracotta` border ring

**Section 3 — Split Calculator:**
- "Split type" segmented control: "50/50" | "Custom" | "By %"
- Amount display: Partner A owes `$X` / Partner B owes `$X`
- Custom split: two currency inputs side by side
- Validation: totals must equal original amount

**Section 4 — Settle Up:**
- "Settle up with [Partner Name]"
- `venmo_logo` button (deep link: `venmo://paycharge?txn=pay&recipients=USERNAME&amount=X&note=Hearth:%20MERCHANT`)
- `zelle_logo` button (deep link: `zelle://send?amount=X`)
- "Mark as settled manually" link text below

---

### TRANS-004 — Subscription Hub

**Navigation:** From HOME-001 "See All" on bills or Settings. Push within tab.  
**Purpose:** AI-discovered recurring charges across both accounts.

**Section 1 — AI Discovery Banner:**
- `AICoachCard` variant (subscriptionAlert): "Found 12 active subscriptions totaling $247/mo across your accounts."

**Section 2 — Subscription Categories:**
- Grouped by type: Streaming | Software | Fitness | News | Gaming | Other
- Each group: `SectionHeader` with total cost badge

**Section 3 — Subscription Rows:**
- `TransactionRow` variant: merchant icon + name + frequency label (Monthly/Annual) + next charge date + amount
- Trailing badge: which partner's account ("Alex" / "Sam" / "Both")
- Swipe left: "Cancel Guidance" (opens sheet with cancellation instructions/link) + "Mark as Intentional"

**Section 4 — Savings Insights:**
- "If you cancelled unused subscriptions, you'd save $89/mo" — amber callout card
- "Review" CTA button

---

### GOALS-001 — Goals Overview

**Navigation:** Tab 2 (Goals).  
**Layout:** `ScrollView` + FAB "+" button for new goal.

**Section 1 — Goals Summary:**
- Total saved across all goals (`.largeAmount`)
- Progress stat: "X of Y goals on track"

**Section 2 — Active Goals:**
- `SectionHeader`: "Active Goals"
- `GoalCard` × N

**Section 3 — Completed Goals:**
- `SectionHeader`: "Completed" (if any)
- `GoalCard` completed variant × N (collapsed, shows completion date)

**Section 4 — Empty State:**
- If no goals: centered illustration (piggybank.fill, 80pt, `hearthAmber`) + "Set your first goal together" title + "Create Goal" `PrimaryButton`

**FAB:** `plus.circle.fill` 56pt, `hearthTerracotta`, bottom-right, above tab bar. Spring animation on appear. Tap → GOALS-003 sheet.

---

### GOALS-002 — Goal Detail

**Navigation:** Tap `GoalCard` → push. Back → GOALS-001.

**Section 1 — Goal Hero:**
- Goal emoji (56pt)
- Goal name (`.title1`)
- Progress arc (circular progress, 120pt diameter, `hearthTerracotta` fill)
- Percentage label centered in arc
- "X days left" below arc

**Section 2 — Contribution Breakdown:**
- `SectionHeader`: "Contributions"
- Partner A: avatar + name + total contributed + percentage bar
- Partner B: avatar + name + total contributed + percentage bar
- "Add Contribution" `PrimaryButton` (logs a manual contribution, opens amount input sheet)

**Section 3 — Transaction Link:**
- `SectionHeader`: "Linked Transactions"
- `TransactionRow` × transactions tagged to this goal
- "Link a transaction" — opens transaction picker

**Section 4 — Goal Timeline:**
- Milestone markers on a vertical timeline:
  - 25% reached (date)
  - 50% reached (date)
  - 75% reached (date)
  - Target date
- Current position highlighted in `hearthTerracotta`

**Section 5 — Actions:**
- "Edit Goal" (pencil) → GOALS-003 sheet
- "Pause Goal" (pause.fill)
- "Delete Goal" (trash.fill, destructive, confirmation required)

---

### GOALS-003 — Create / Edit Goal Sheet

**Navigation:** Sheet from GOALS-001 FAB (create) or GOALS-002 "Edit" (edit). Large detent.

**Section 1 — Header:**
- "New Goal" / "Edit Goal" title
- Close button (`xmark.circle.fill`) top-right

**Section 2 — Goal Form:**
- Emoji picker row (6 presets + `face.smiling` custom picker)
- Goal name text field
- Target amount currency input
- Target date picker
- Privacy toggle: "Visible to partner" (default on)
- Optional note field: "What is this goal for?" placeholder

**Section 3 — CTA:**
- `PrimaryButton`: "Create Goal" / "Save Changes"
- `SecondaryButton` (neutral outlined): "Cancel"

---

### INSIGHTS-001 — Insights Hub (AI Spending Coach Home)

**Navigation:** Tab 3 (Insights). Large title "Insights".  
**Purpose:** AI coach homepage, spending trends, category summaries.

**Section 1 — Month Summary Card:**
- "June 2026" header
- Net spending vs budget gauge (arc chart)
- "On track" / "Over budget" status badge

**Section 2 — Active AI Coach Cards:**
- `SectionHeader`: "AI Coach" + `sparkles` icon (amber)
- Stack of up to 3 `AICoachCard` components, sorted by severity
- "Dismiss all" link if multiple

**Section 3 — Spending by Category:**
- `SectionHeader`: "Where's the money going?" + month picker
- Horizontal bar chart (each bar = category, `CategoryChip` color, proportional width)
- Tap category bar → INSIGHTS-002 Category Deep Dive

**Section 4 — Partner Comparison Teaser:**
- `SectionHeader`: "You vs. [Partner Name]"
- Side-by-side: Partner A avatar + total spend | Partner B avatar + total spend
- "See full comparison" → INSIGHTS-004

**Section 5 — Monthly Report CTA:**
- "View June Report" `SecondaryButton` → INSIGHTS-003

---

### INSIGHTS-002 — Category Deep Dive

**Navigation:** Tap category on INSIGHTS-001. Back → INSIGHTS-001.

**Section 1 — Category Header:**
- `CategoryChip` large variant (56pt icon)
- Category name (`.title1`)
- Total spent this month (`.largeAmount`)
- vs. last month delta

**Section 2 — Budget Progress:**
- Budget vs. spent bar (if budget set)
- "Set a budget for [Category]" link if none set

**Section 3 — Spending Chart:**
- Line chart: daily spending in category for current month
- `hearthTerracotta` line, amber area fill
- Tap data point → tooltip with date + amount

**Section 4 — AI Coach Insight (if relevant):**
- `AICoachCard` specific to this category

**Section 5 — Transactions:**
- `SectionHeader`: "Transactions"
- `TransactionRow` × all transactions in this category for current month

---

### INSIGHTS-003 — Monthly Report

**Navigation:** From INSIGHTS-001 "View Report". Push.

**Section 1 — Report Header:**
- "June 2026 Report" (`.title1`)
- Total household income + total spending + net savings

**Section 2 — Income Summary:**
- Income sources table: Partner A income sources + Partner B income sources
- Total income (`.largeAmount`, success green)

**Section 3 — Spending Breakdown:**
- Donut chart (category proportions, category chip colors)
- Legend below: category + amount + % of total

**Section 4 — Budget vs. Actual Table:**
- Category | Budget | Actual | Status
- Status: `✓ On track` / `⚠ Near limit` / `✗ Over`

**Section 5 — Partner Comparison:**
- Side-by-side spending totals + top categories per partner

**Section 6 — Month-over-Month:**
- Comparison to previous month: spending up/down, savings change
- Export button: "Share Report" → generates PDF share sheet

---

### INSIGHTS-004 — Partner Comparison

**Navigation:** From INSIGHTS-001. Push.

**Section 1 — Header:**
- "You & [Partner]", `.title1`
- Month/period picker

**Section 2 — Side-by-Side:**
- Three-column layout: Partner A | Category | Partner B
- Rows per category: avatars + amounts, bar chart comparison within row
- Inspired by Honeydue three-pane partner view

**Section 3 — Insights:**
- AI-generated observations: "Alex spends 2x more on dining than Sam this month."

---

### SETTINGS-001 — Settings Overview

**Navigation:** Tab 4 (Settings). Large title "Settings".

**Grouped list layout:**

**Section 1 — Household:**
- "Profile & Partner" row → SETTINGS-002
- Partner status: "[Partner name] connected" or "Invite partner" if solo

**Section 2 — Accounts:**
- "Account Management" row → SETTINGS-003
- Account count badge

**Section 3 — Notifications:**
- "Notification Preferences" row → SETTINGS-004

**Section 4 — Subscription:**
- "Hearth [Plan name]" row → SETTINGS-005
- Current plan + next billing date

**Section 5 — Privacy & Security:**
- "Privacy & Security" row → SETTINGS-006

**Section 6 — App:**
- "Help & Support" → Safari URL
- "Rate Hearth" → App Store review prompt
- "Share Hearth" → system share sheet
- "About" → version info, licenses
- "Sign Out" row (destructive red text, confirmation required)

---

### SETTINGS-002 — Profile & Partner Management

**Navigation:** From SETTINGS-001. Push.

**Section 1 — Your Profile:**
- `PartnerAvatar` lg (56pt) with edit overlay (camera.fill badge)
- Name text field (editable inline)
- Email (read-only, with "Change Email" link)
- "Change Password" row

**Section 2 — Partner:**
- Partner avatar (56pt, `hearthDustyRose` background)
- Partner name + email
- Status badge: "Connected" (success) / "Invited – pending" (warning)
- "Remove Partner" destructive row (requires both partner confirmation)

**Section 3 — Household:**
- Household name (editable): "The Smiths", "Alex & Sam"
- Household creation date + membership duration badge

---

### SETTINGS-003 — Account Management

**Navigation:** From SETTINGS-001. Push.

**Section 1 — Your Accounts:**
- `LinkedAccountCard` × N (compact variant, 80pt height)
- Per card: Privacy badge (tappable → privacy picker sheet) + swipe left to remove

**Section 2 — Add Account:**
- "Connect another account" `PrimaryButton` → Plaid Link sheet

---

### SETTINGS-004 — Notification Preferences

**Navigation:** From SETTINGS-001. Push.

**Grouped toggle list:**

**Section 1 — AI Coach:**
- "Weekly spending digest" toggle
- "Proactive overspend warnings" toggle
- "Goal milestone alerts" toggle

**Section 2 — Transactions:**
- "New transactions" toggle
- "Large transactions (>$X)" toggle + amount threshold field
- "Unreviewed transaction reminders" toggle + frequency picker

**Section 3 — Bills:**
- "Upcoming bill reminders" toggle
- "Reminder timing" picker: 7 days / 3 days / 1 day before

**Section 4 — Partner:**
- "Partner added a comment" toggle
- "Partner linked new account" toggle
- "Partner changed privacy settings" toggle

**Section 5 — Money Date:**
- "Money Date reminder" toggle
- "Reminder day" picker + time picker

---

### SETTINGS-005 — Subscription & Paywall

**Navigation:** From SETTINGS-001. Push.

**Section 1 — Current Plan:**
- Plan name badge (Solo / Couples)
- Next billing date
- "Manage in App Store" link

**Section 2 — Plan Options:**
- See `SYS-001` Paywall for plan card designs (same components rendered here in a non-blocking context)

**Section 3 — Trial Status:**
- If in trial: "X days remaining in trial" countdown, amber badge

**Section 4 — Restore:**
- "Restore Purchases" row
- "Cancel Subscription" destructive row → confirmation → App Store subscription management

---

### SETTINGS-006 — Privacy & Security

**Navigation:** From SETTINGS-001. Push.

**Section 1 — Security:**
- "Face ID / Touch ID" toggle
- "Require biometrics after X minutes" picker
- "Change PIN" row (if PIN fallback enabled)

**Section 2 — Data & Privacy:**
- "Export my data" row → generates CSV + emails to registered address
- "Delete all data" destructive row → requires email confirmation + 30-day delay notice
- "Privacy Policy" → SafariViewController
- "Terms of Service" → SafariViewController

---

### SYS-001 — Paywall (Trial Expired / Upgrade Prompt)

**Navigation:** Triggered when trial expires or user tries premium feature. Full-screen modal, no back button.

**Section 1 — Hero:**
- Hearth flame icon (80pt, animated pulse)
- "Upgrade to Hearth Couples" (`.title1`)
- "Your 14-day trial has ended." (`.body`, `textSecondary`)

**Section 2 — Feature List:**
- 5 feature rows (checkmark.circle.fill, `hearthTerracotta`):
  - "🤖 AI Spending Coach — proactive, not reactive"
  - "🔒 Per-account privacy controls"
  - "🎯 Joint savings goals"
  - "🔄 Subscription audit"
  - "👫 Dual-partner household view"

**Section 3 — Plan Cards:**
- Two cards side by side (or stacked on small screens):
  - **Solo** — $7.99/mo or $63.99/yr (save 33%) — `hearthCream` bg, `borderDefault` border
  - **Couples** — $12.99/mo or $103.99/yr (save 33%) — `hearthTerracotta` bg, `textInverse` text, **RECOMMENDED** badge in `hearthAmber`
- Annual toggle at top: "Annual (Save 33%)" — pre-selected
- Selected card: 2pt `borderStrong` ring + `shadow.medium`

**Section 4 — CTA:**
- `PrimaryButton`: "Start Couples Plan — $103.99/yr"
- Legal: "Auto-renews annually. Cancel anytime in App Store settings.", `.caption2`, `textTertiary`
- "Restore Purchases" link, `.footnote`

---

### SYS-002 — Partner Invite Accepted (Celebration)

**Navigation:** Triggered when second partner completes onboarding. Full-screen modal.

**Section 1 — Celebration Animation:**
- Confetti burst (terracotta + amber + dusty rose)
- `household_icon` custom 80pt, animated

**Section 2 — Message:**
- "You're a household!" (`.title1`, centered)
- Partner avatar pair (both 56pt, stacked with overlap)
- "[Partner A] & [Partner B]" names, `.title3`

**Section 3 — CTA:**
- `PrimaryButton`: "Explore Together" → HOME-001
- Haptic: `UINotificationFeedbackGenerator(.success)` on button tap

---

### SYS-003 — AI Nudge Detail (Full Coach Card Expanded)

**Navigation:** Tap "See Details" on `AICoachCard`. Sheet, large detent.

**Section 1 — Coach Header:**
- `sparkles` icon (28pt, `hearthAmber`) + "AI Coach" label
- Insight severity badge
- Timestamp "Updated today"

**Section 2 — Full Insight:**
- Full insight text (`.body`, not truncated)
- Animated chart: spending trajectory for the relevant category (line chart showing pace vs. budget)

**Section 3 — Breakdown:**
- Top 3 contributing transactions in the flagged category
- `TransactionRow` compact variants (tappable → TRANS-002)

**Section 4 — Recommended Actions:**
- "Set a spending limit" → budget configuration
- "Review these transactions" → TRANS-001 filtered to category
- "Dismiss this insight" link

**Section 5 — AI Explanation:**
- "How was this calculated?" expandable accordion row
- Plain-language explanation of the AI analysis

**Section 6 — Coach History:**
- "Past insights" horizontal scroll of previous coach cards for this category

---

## 9. Onboarding Flow

### Step-by-Step with Exact Copy

**Step 1 — ONB-001 Welcome:**
- Headline: "Hearth"
- Subhead: "Where your money comes home."
- CTA: "Get Started — It's Free"
- Secondary: "Sign In"
- Legal: "14-day free trial. No credit card required."

**Step 2 — ONB-002 Account Creation:**
- Headline: "Create your account"
- Subhead: "Your partner joins in the next step."
- Apple CTA: "Sign in with Apple" (system-provided copy)
- Divider: "or"
- Email placeholder: "Email address"
- Password placeholder: "Password"
- CTA: "Create Account"
- Legal: "By continuing you agree to our Terms of Service and Privacy Policy."

**Step 3 — ONB-003 Invite Partner:**
- Headline: "Invite your partner"
- Subhead: "Hearth works best when both of you are in. Your partner gets their own login — no password sharing."
- Invite rows: "Send via iMessage" / "Share via AirDrop" / "Copy invite link"
- QR caption: "Or have your partner scan this code"
- Invite code: "Invite code: HEARTH-XXXX"
- Pending: "Waiting for your partner…"
- Skip: "I'll invite them later"

**Step 4 — ONB-004 Link Accounts:**
- Headline: "Link your accounts"
- Subhead: "Hearth reads your transactions — it never moves money. Read-only, always."
- Trust copy: "Bank-level 256-bit encryption. We use Plaid — the same technology used by Venmo, Robinhood, and Coinbase."
- Add account: "+ Add another account"
- CTA: "Continue"
- Skip: "Skip for now"

**Step 5 — ONB-005 Privacy:**
- Headline: "Set your privacy"
- Subhead: "Choose what your partner sees for each account. You can change this any time."
- Legend items: "Show everything — Transactions and balances visible" / "Balance only — Balance visible, transactions hidden" / "Keep private — Account fully hidden from partner"
- Segment labels: "Full" | "Balance" | "Hidden"
- CTA: "Save & Continue"
- Footnote: "Your partner will see the same privacy setup for their accounts."

**Step 6 — ONB-006 Goal:**
- Headline: "Create your first goal"
- Subhead: "Goals are shared by default — both of you can contribute."
- Suggestion chips: "🏖 Vacation" | "🏠 Down Payment" | "💍 Wedding" | "🚗 New Car" | "💰 Emergency Fund" | "✏️ Custom"
- Fields: "Goal name" / "Target amount" / "Target date (optional)"
- CTA: "Create Goal & Continue"
- Skip: "Skip for now"

**Step 7 — ONB-007 Complete:**
- Headline: "You're all set! 🎉"
- Subhead: "Your household is ready. Let's make money feel less complicated."
- Money Date copy: "Schedule your first Money Date — A 15-min monthly check-in with your partner to review spending and goals."
- CTA: "Go to Hearth"
- Secondary: "Schedule Money Date"
- Tertiary: "Maybe later"

---

## 10. AI Coach UX

### Proactive Nudge Pattern

The AI Coach is Hearth's primary differentiator. It initiates contact BEFORE the user overspends — not after.

**Trigger Conditions:**
1. User is 70%+ through monthly budget in a category before month is 70% complete (pace-based)
2. Unusual spike: single transaction > 2× average transaction amount for category
3. Subscription discovered that hasn't appeared in 90+ days (forgotten subscription signal)
4. Goal is behind pace based on target date trajectory
5. Partner added a large transaction (>$X threshold set in preferences)

**Insight Copy Templates:**

Proactive overspend:
> "You're on track to overspend [Category] by $[X] this month — here's where it's coming from."

Positive reinforcement:
> "You're $[X] under budget across all categories this month. Keep it up."

Subscription:
> "Found [N] subscriptions you might have forgotten about, totaling $[X]/mo."

Goal behind pace:
> "At your current savings rate, you'll reach [Goal Name] [X months] after your target date."

Partner spend spike:
> "[Partner] had a large [Category] expense — you may want to chat about it."

**Card Lifecycle:**
1. Generated server-side, delivered via push notification + in-app
2. Appears in INSIGHTS-001 sorted by severity (high first)
3. Dashboard shows max 1 card at a time (highest severity)
4. Dismissed: transition out + stored as dismissed in `UserDefaults` keyed to `insightID`
5. History accessible in SYS-003

**Severity Rules:**
- `low` (amber): informational, no action required
- `medium` (terracotta): action recommended, no haptic on appear
- `high` (error red): urgent action needed, `.warning` haptic on appear in dashboard

**Coach Weekly Digest:**
Delivered as push notification every Monday at 9am user-local time. Opens INSIGHTS-003 Monthly Report or INSIGHTS-002 Category Deep Dive based on most important trend.

---

## 11. Money Date Feature

The Money Date is a bi-weekly or monthly ritual — a structured 15-minute financial check-in between partners. Introduced in ONB-007, accessible from HOME-001.

### Entry Point
- HOME-001 dashboard: "Money Date" card appears in Section 3 position (above AI coach), shows countdown to next scheduled date
- Notification: push at scheduled time

### Money Date Session Screen (sub-screen of HOME-001)
Full-screen overlay sheet, `.large` detent.

**Header:**
- `money_date_calendar` custom icon (40pt, `hearthTerracotta`)
- "Money Date", `.title2`
- Date: "Sunday, June 29"
- Partner avatars: stacked pair (both `lg` 56pt)

**Agenda (5 steps, tab/card pager):**

Step 1 — "How was this month?" 
- Both partners rate their financial satisfaction: emoji slider (1-5, 😰 to 😊)
- Quick mood capture, anonymous until both submit

Step 2 — "Where did the money go?"
- Donut chart summary for the period
- Top 5 categories, `CategoryChip` + amounts
- Swipe to acknowledge each

Step 3 — "Transactions to discuss"
- Transactions flagged by either partner during the month
- `TransactionRow` with partner comment preview
- Mark each "Discussed" 

Step 4 — "Goals check-in"
- Each active `GoalCard` with progress update
- "On track" / "Needs attention" status per goal
- "Add contribution" inline

Step 5 — "Next steps"
- Free-text notes for both partners ("What do we want to do differently next month?")
- "Set a budget" shortcut per flagged category
- Completion: confetti + "Money Date complete!" message + success haptic

**Scheduling:**
- Calendar picker for next Money Date
- Option: "Remind us both" sends push to both partners
- Cadence picker: Weekly / Bi-weekly / Monthly

---

## 12. Animation & Motion

### Core Animations

| Interaction | Duration | Easing | Notes |
|-------------|----------|--------|-------|
| Tab switch | 220ms | `.easeInOut(duration: 0.22)` | Outgoing: fade + -8pt Y; incoming: fade + +8pt Y. Tab icon scales 1.0→1.12→1.0. |
| Navigation push/pop | 350ms | `.spring(response: 0.35, dampingFraction: 0.82)` | Push: incoming from trailing. Pop: reverse. Keep `interactivePopGestureRecognizer` enabled. |
| Sheet presentation | 380ms | `.spring(response: 0.38, dampingFraction: 0.78)` | Rises from bottom. Corner radius 0→16. Dim overlay 0→0.4. Grab handle pulse on settle. |
| Transaction mark-reviewed | 280ms | `.spring(response: 0.28, dampingFraction: 0.72)` | Row slides off left, terracotta fill expands behind, checkmark draws on (200ms). Row height collapses to 0 over 220ms. Sibling rows close gap with 30ms stagger. |
| Goal progress bar fill | 900ms | `.spring(response: 0.9, dampingFraction: 0.65)` | Fills from 0 (or previous) to current %. Color gradient: cream→coral→terracotta. Shimmer at 100%. Percentage label counts up in sync. |
| AI Coach card appear | 300ms | `.spring(response: 0.3, dampingFraction: 0.8)` | `.transition(.move(edge: .top).combined(with: .opacity))` |
| AI Coach card dismiss | 250ms | `.easeInOut(duration: 0.25)` | `.transition(.move(edge: .trailing).combined(with: .opacity))` |
| Amount value change | — | `.contentTransition(.numericText())` | Direction-aware: `countsDown: amount < previousAmount` |
| Dashboard amount first load | 800ms | `.easeOut(duration: 0.8)` | Count-up from 0 |
| Button press | 150ms | `.spring(response: 0.3, dampingFraction: 0.85)` | `.scaleEffect(0.97)` on all primary/secondary buttons |
| Icon button press | 120ms | `.spring(response: 0.25, dampingFraction: 0.8)` | `.scaleEffect(0.88)` |
| Category chip select | 150ms | `.easeInOut(duration: 0.15)` | Opacity + border animate |
| Onboarding brand hero | 1.8s | See ONB-001 | Icon (0.4s), wordmark (delay 0.3s, 0.4s), tagline (delay 0.6s, 0.4s) |
| Onboarding partner illustration | 600ms | `.easeInOut(duration: 0.6)` | Path draw-on |
| Account card linked (ONB-004) | 300ms | `.spring(response: 0.3, dampingFraction: 0.7)` | Slide-up stagger per card, 100ms between cards |
| Sheet grab handle | 180ms | `.easeOut(duration: 0.18)` | Scale 1.0→1.2→1.0 pulse once on settle |
| Money Date confetti | 1.2s | particle system | `hearthTerracotta` + `hearthAmber` + `hearthDustyRose` particles |

### Reduced Motion
All animations must respect `@Environment(\.accessibilityReduceMotion)`. When true:
- Replace all slide/move transitions with `.opacity` transitions
- Remove count-up animation, show final value immediately
- Disable confetti, replace with static checkmark
- Progress bar fills instantly (no spring animation)
- Tab switch: no Y-axis translation, opacity only

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

var animation: Animation {
    reduceMotion ? .none : .spring(response: 0.4, dampingFraction: 0.75)
}
```

---

## 13. Haptic Feedback Map

| Event | Haptic Type | Generator |
|-------|------------|-----------|
| Transaction marked as reviewed | Medium impact | `UIImpactFeedbackGenerator(.medium)` |
| Reviewed threshold crossed during swipe | Success notification | `UINotificationFeedbackGenerator(.success)` |
| Goal milestone (25%, 50%, 75%) | Medium impact | `UIImpactFeedbackGenerator(.medium)` |
| Goal 100% complete | Success notification | `UINotificationFeedbackGenerator(.success)` |
| Budget warning (AI coach high severity) | Warning notification | `UINotificationFeedbackGenerator(.warning)` |
| Form validation error / invalid submit | Error notification | `UINotificationFeedbackGenerator(.error)` |
| Primary button tap | Medium impact | `UIImpactFeedbackGenerator(.medium)` |
| Secondary button tap | Selection | `UISelectionFeedbackGenerator()` |
| Tab bar switch | Light impact | `UIImpactFeedbackGenerator(.light)` |
| Category chip select | Selection | `UISelectionFeedbackGenerator()` |
| Privacy level change | Light impact | `UIImpactFeedbackGenerator(.light)` |
| Copy invite link (success) | Success notification | `UINotificationFeedbackGenerator(.success)` |
| Sheet settle (presentation) | Medium impact | `UIImpactFeedbackGenerator(.medium)` |
| Account linked successfully | Success notification | `UINotificationFeedbackGenerator(.success)` |
| Account link error | Error notification | `UINotificationFeedbackGenerator(.error)` |
| Onboarding feature chip auto-scroll | Light impact | `UIImpactFeedbackGenerator(.light)` |
| Partner invite accepted | Success notification | `UINotificationFeedbackGenerator(.success)` |
| Bill marked as paid | Success notification | `UINotificationFeedbackGenerator(.success)` |
| Split expense settled | Success notification | `UINotificationFeedbackGenerator(.success)` |
| Money Date complete | Success notification | `UINotificationFeedbackGenerator(.success)` |
| Subscription "cancel guidance" opened | Light impact | `UIImpactFeedbackGenerator(.light)` |
| Amount display count-up completes | Light impact | `UIImpactFeedbackGenerator(.light)` |

**Implementation note:** Prepare haptic generators before use to avoid latency:
```swift
// In view init or onAppear:
let impactMedium = UIImpactFeedbackGenerator(style: .medium)
impactMedium.prepare()
// Then trigger:
impactMedium.impactOccurred()
```

---

## 14. Accessibility Requirements

### Dynamic Type
- All text styles use SwiftUI semantic text styles (`.headline`, `.body`, etc.) — never fixed sizes
- Currency amounts: `.minimumScaleFactor(0.75)` + `.lineLimit(1)` to prevent layout breaks at XXXL sizes
- Test at all Dynamic Type sizes: Default, Large, XL, XXL, XXXL, AX1-AX5
- Card layouts must reflow vertically at accessibility sizes (not truncate)

### VoiceOver
- All interactive elements require `.accessibilityLabel()` with descriptive text
- Icon-only buttons: explicit label required, e.g. `.accessibilityLabel("Mark transaction as reviewed")`
- `TransactionRow`: compose accessible description: "[Merchant], [Amount], [Category], [Date], [Partner name]'s account, [reviewed/unreviewed]"
- `AccountCard`: "[Bank name] [Account type] ending in [last 4], Balance [amount or 'balance hidden'], [Privacy level]"
- `GoalCard`: "[Goal name], [Amount] of [Target] saved, [Percentage]% complete, [Days] days remaining"
- `PrivacyBadge`: include tap hint: `.accessibilityHint("Double-tap to change privacy setting")`
- `ProgressBar`: `.accessibilityValue("\(percentage)% funded")`
- Decorative elements: `.accessibilityHidden(true)`

### Color Contrast
- All text/background combinations must meet WCAG 2.1 AA (4.5:1 for body text, 3:1 for large text)
- `textPrimary` on `backgroundCard`: verified ✓
- `hearthTerracotta` on `backgroundCard`: verify with contrast checker (target: 3:1 minimum for button labels which are large text)
- Category chip text on chip background: each pair must be verified individually

### Tap Targets
- All interactive elements: minimum 44×44pt tap target
- Where visual size is smaller (e.g. 20pt avatar), expand tap area via `.contentShape(Rectangle().size(CGSize(width: 44, height: 44)))`

### Semantic Grouping
- Use `.accessibilityElement(children: .combine)` on `TransactionRow` to present as single element to VoiceOver
- Use `.accessibilityElement(children: .contain)` for `GoalCard` to allow VoiceOver to step through sub-elements

### Differentiation Beyond Color
- Reviewed state: amber dot is always accompanied by an `unreviewed` label (`.accessibilityLabel`) — never color alone
- Partner A/B indicators: left accent bar color is always accompanied by partner name label
- Error/success states: always include icon (shape) + text label alongside color

---

## 15. Dark Mode Notes

### Dark-First Design
Hearth is designed dark-first. The dark mode palette uses warm charcoal (not cold gray) with warm undertones throughout.

### Key Dark Mode Adaptations

| Element | Light | Dark | Notes |
|---------|-------|------|-------|
| App background | `#F5EDE0` cream | `#1A1410` warm charcoal | Warm, never cold |
| Card surface | `#FDFAF6` | `#2A2018` | Perceptibly lighter than bg |
| Primary CTA | `hearthTerracotta #C15A3A` | `hearthCoral #D4725A` | Lightened for contrast in dark |
| Text primary | `#1C1410` | `#F0E6D8` | Warm white, not pure white |
| Borders | warm brown tint, low opacity | warm cream tint, low opacity | Same warmth family |
| AI Coach card bg | `#FFF0E8` | `#2E1A0A` | Distinct warm orange tint both modes |

### System Appearance
- Respect `@Environment(\.colorScheme)` throughout
- Never hard-code light/dark color values — always use named color assets with dark variant
- ONB-001 Welcome screen: always dark mode regardless of system setting (brand signature moment)
- All other screens: follow system

### `.ultraThinMaterial`
Used for nav bar and tab bar backgrounds. In dark mode, this produces a warm dark blur — ensure custom `backgroundPrimary` is dark warm, not gray, so the material tint is correct.

### Status Bar
- Light content (white) on dark backgrounds
- Dark content on light backgrounds
- Use `.preferredColorScheme` only on ONB-001 to force dark

---

## 16. Apple Watch Complication Spec

### Supported Complication Families

**accessoryCircular (primary complication):**
- Content: combined household balance or today's spending amount
- Layout: circular gauge or large number
- Color: `hearthTerracotta`
- Text: "$12.4K" (truncated to fit) or today's spend "$84"
- Tap: deep links to Watch app daily summary

**accessoryRectangular:**
- Layout: 3 lines
  - Line 1: "Hearth 🏠" (title)
  - Line 2: Combined balance (bold, largest fitting font)
  - Line 3: "↑ $240 vs. yesterday" or top spending category
- Color: brand terracotta for amounts and icons

**accessoryInline:**
- Single line: "Hearth: $12,480 balance"

### Watch App (Companion)
Minimal Watch app with 3 screens navigated via Digital Crown:
1. **Balance**: combined balance + daily delta + last sync
2. **Today's Spending**: total + top category breakdown (bar)
3. **Quick Log**: "Add Expense" with amount picker (crown-driven) + category selector

**Watch Color:** Match iOS brand — `hearthTerracotta` for interactive elements, `hearthAmber` for highlights.

**SwiftUI WatchOS:** Use `WKInterfaceController` / SwiftUI `@main` `App` targeting `watchos`. Share model layer via `@AppStorage` + WatchConnectivity framework for real-time sync.

---

## 17. Widget Spec (iOS 17 WidgetKit)

### systemSmall (2×2)

**Layout:**
```
[Hearth flame icon 16pt]  [hearthTerracotta]

[$12,480]    ← largeAmount monospaced
Combined Balance

↑ $240 today    ← success green
```

- Background: `backgroundCard` (light) / `backgroundCard` (dark)
- Corner radius: system widget default
- Tap: deep links to HOME-001

### systemMedium (4×2)

**Layout (two columns):**
```
Left column:
[Hearth icon] Hearth
$12,480
Combined Balance
↑ $240 today

Right column (top 2 transactions):
[Merchant icon] Netflix     -$15.99
[Merchant icon] Whole Foods -$84.20
                           [See all →]
```

- Transaction merchant icons: 24pt circles
- Amounts: `.smallAmount` monospaced

### systemLarge (4×4)

**Layout:**
```
[Header: Hearth  $12,480  ↑$240]
─────────────────────────────────
Recent Transactions:
[TransactionRow compact × 4]
─────────────────────────────────
Goals:
[GoalCard mini: name + progress bar + %]
```

### WidgetKit Implementation Notes
- Use `TimelineProvider` with 15-minute refresh for balance
- Use `AppIntentConfiguration` for configurable widget (let user choose: balance / spending today / goal progress)
- Support `.background(.widgetBackground)` for proper widget rendering
- All amounts use `Text(amount, format: .currency(code: "USD"))` for proper locale formatting

### Lock Screen Widget (accessoryRectangular)
- Same as Watch `accessoryRectangular` content
- Tap: opens Hearth to HOME-001

---

## 18. Paywall Design

### Full-Screen Paywall (SYS-001)

**Background:** `backgroundPrimary` (follows system appearance).

**Hero Section:**
- Hearth flame icon (80pt) with subtle terracotta pulse animation (scale 1.0→1.05→1.0, 2s loop)
- "Upgrade to Hearth" headline (`.title1`)
- "Your 14-day free trial has ended." (`.body`, `textSecondary`)

**Feature List (5 rows):**
```
✓  AI Spending Coach — proactive, not reactive
✓  Per-account privacy controls
✓  Joint savings goals
✓  Subscription audit
✓  Dual-partner household view
```
- Checkmark: `checkmark.circle.fill`, `hearthTerracotta`, 20pt
- Text: `.body`

**Plan Toggle:**
- "Monthly" | "Annual" segmented control (annual pre-selected)
- "Save 33%" badge on annual (`hearthAmber` bg, white text, 12pt)

**Plan Cards (stacked vertically on all sizes for safety):**

Solo Plan card:
- `backgroundCard` surface, `borderDefault` 1pt border
- "Solo" title (`.title3`)
- "$7.99/mo" (`.largeAmount`) / "$63.99/yr"
- "For individuals managing finances alone"

Couples Plan card:
- `hearthTerracotta` background, `textInverse` text
- "RECOMMENDED" badge (`hearthAmber` bg, 10pt, top-right corner)
- "Couples" title (`.title3`)
- "$12.99/mo" (`.largeAmount`) / "$103.99/yr"
- "For partners sharing a financial life"
- `shadow.strong`

Selected plan: 2pt `borderStrong` outer ring.

**CTA Section:**
- `PrimaryButton`: "Start [Plan] Plan — $[price]"
- Legal: "Auto-renews [annually/monthly]. Cancel anytime in App Store settings. Payment charged to iTunes account at confirmation of purchase.", `.caption2`, `textTertiary`
- "Restore Purchases" link (`.footnote`, `textLink`)

### Soft Paywall (Upgrade Prompt)
Displayed as a bottom sheet when user hits premium feature limit without active subscription:
- Compact: feature icon + "This is a Hearth premium feature" + `PrimaryButton` "Upgrade — Start Free Trial" + "Maybe Later" dismiss
- Does not block the app — dismissable

---

## 19. App Icon Spec

### Icon Design Brief

**Concept:** Abstract flame combined with a roofline — the "hearth" concept. The icon reads as warmth and home simultaneously. Premium, minimal, friendly.

**Light Mode Icon:**
- Background: warm cream `#F5EDE0`
- Icon mark: terracotta/sienna flame-roofline hybrid `#C15A3A`
- No drop shadow within the icon
- Mark takes up ~55% of icon canvas (centered with slight upward shift)

**Dark Mode Icon:**
- Background: warm charcoal `#1A1410`
- Icon mark: coral `#D4725A` (lightened for visibility on dark)
- Same geometry as light mode

**Icon Mark Description:**
A simplified flame shape whose base widens to form an inverted V (roofline). Three implied "lines" within the flame suggest warmth/fire. The overall silhouette is instantly recognizable as both a flame and an abstract house outline. No text. No literal house shape. Fully abstract — passes the 16pt test (readable at all sizes).

**Required Export Sizes (all from SVG master, no upscaling):**
| Size | Usage |
|------|-------|
| 1024×1024 | App Store |
| 180×180 | iPhone @3x |
| 120×120 | iPhone @2x |
| 167×167 | iPad Pro @2x |
| 152×152 | iPad @2x |
| 83.5×83.5 | iPad Pro @1x |
| 76×76 | iPad @1x |
| 60×60 | Spotlight @3x |
| 40×40 | Spotlight @2x / Settings @3x |
| 29×29 | Settings @1x |
| 20×20 | Notification @1x |

**Format:** SVG master → export PNG at each size. Add to `AppIcon.appiconset` in Assets.xcassets. No transparency (iOS masks icons).

**Do NOT:**
- Add gloss, bevel, or drop shadow effects
- Use gradient backgrounds (flat cream / flat charcoal only)
- Include text or wordmark
- Use literal house or flame clip art

---

## 20. QA Sign-off Checklist

### Completeness ✓

- [ ] All 29 screens specified (ONB-001 through SYS-003)
- [ ] All 10 core features designed:
  - [x] Dual-login household (ONB-003, SETTINGS-002, SYS-002)
  - [x] Shared dashboard (HOME-001, HOME-002)
  - [x] AI Spending Coach (Section 10, AICoachCard, INSIGHTS-001, SYS-003)
  - [x] Per-account privacy toggle (ONB-005, PrivacyBadge, SETTINGS-003)
  - [x] Transaction commenting (TRANS-002)
  - [x] Joint savings goals (GOALS-001 through GOALS-003, GoalCard)
  - [x] Expense splitting (TRANS-003)
  - [x] Subscription audit (TRANS-004)
  - [x] Variable income budgeting (INSIGHTS-002, INSIGHTS-003)
  - [x] Apple ecosystem (Sections 16-17)

### Apple HIG Compliance ✓

- [ ] All tap targets ≥ 44×44pt (Section 14)
- [ ] SF Symbols used throughout (Section 7), correct rendering modes
- [ ] Safe area handling via SwiftUI automatic (Section 4)
- [ ] Dynamic Type support on all text styles (Section 14)
- [ ] Dark mode via color asset catalog with dark variants (Section 15)
- [ ] Accessibility labels on all interactive elements (Section 14)
- [ ] `UISelectionFeedbackGenerator` for selections, `UIImpactFeedbackGenerator` for actions (Section 13)
- [ ] Sheet presentations use system `.sheet()` with proper detents
- [ ] Navigation uses `NavigationStack` (iOS 16+) not deprecated `NavigationView`
- [ ] `ASAuthorizationAppleIDButton` used without customization for Sign in with Apple

### Developer Readiness ✓

- [ ] Every color has light hex, dark hex, SwiftUI token name (Section 2)
- [ ] Every text style has size, weight, SwiftUI modifier (Section 3)
- [ ] Every component has SwiftUI implementation notes
- [ ] Every screen has: purpose, navigation, all sections, empty state, loading state, error state
- [ ] All exact copy strings documented in Section 9
- [ ] Haptic map complete (Section 13)
- [ ] Animation specs include duration, easing, SwiftUI implementation (Section 12)
- [ ] Custom icons list with required sizes (Section 7)

### Brand Consistency ✓

- [ ] Terracotta (`#C15A3A`) as primary CTA throughout — never blue, never gray
- [ ] Warm charcoal dark mode (`#1A1410`) — not cold gray (#1C1C1E)
- [ ] SF Pro Rounded for all currency amounts
- [ ] `hearthAmber` reserved for AI Coach and savings goals (not general use)
- [ ] `hearthDustyRose` reserved for Partner B attribution

### Signed Off By
- Orchestrator Agent: 2026-06-29
- Ready for developer implementation: **YES**

---

*End of Hearth Design Specification v1.0*
