# Multi-Agent iOS App Builder — Production Plan

## Project Overview

Build a **production-ready, ad-monetized Swift iOS app** using a fully automated multi-agent pipeline. Every stage — market research, naming, design, implementation, QA, code review, and deployment — is handled by specialized AI agents coordinated by a manager agent. Every step is tracked through GitHub branches, PRs, and reviews.

**Repo:** https://github.com/yusufbayindir/empty.git  
**Stack:** Swift / SwiftUI / iOS  
**Monetization:** Google AdMob (banner + interstitial)  
**Localization:** 30+ languages (en, tr, fr, zh-Hans, zh-Hant, hi, es, ar, pt, de, ja, ko, ru, it, nl, pl, sv, da, fi, no, cs, hu, ro, uk, id, ms, th, vi, el, he)

---

## Problem Statement

Building a high-quality, monetized iOS app from scratch — with market validation, App Store optimization, professional design, and production-quality code — typically takes a team of 4-6 people 2-3 months. With modern AI agents, this pipeline can be automated end-to-end, compressing timeline dramatically while maintaining production quality.

---

## Multi-Agent Architecture

### Agents & Roles

| Agent | Role | Responsibility |
|-------|------|---------------|
| **ManagerAgent** | Orchestrator | Coordinates all agents, manages state, assigns tasks, monitors progress |
| **MarketingAgent** | Market Research | Analyzes App Store trends (non-games), identifies growth categories, selects best opportunity |
| **NamingAgent × 3** | App Store Optimization | Each independently proposes name candidates; consensus decides final name |
| **DesignerAgent** | UX/UI Design | Analyzes top 3 apps in chosen category, creates complete design system |
| **DeveloperAgent × 2** | Implementation | Builds the Swift app; one implements features, one handles integration |
| **QAAgent** | Quality Assurance | Tests each branch before PR creation |
| **ReviewerAgent** | Code Review | Reviews PRs created by DeveloperAgent |
| **MergeAgent** | Integration | Merges approved PRs to main |
| **LocalizationAgent** | i18n | Runs in parallel, generates all 30+ locale `.strings` files |

### Agent Communication Protocol

Agents communicate via a shared `.context/` directory (JSON state files):
- `.context/state.json` — global pipeline state
- `.context/market-research.json` — MarketingAgent output
- `.context/design-spec.json` — DesignerAgent output  
- `.context/app-name.json` — NamingAgent consensus
- `.context/qa-reports/` — QAAgent reports per branch
- `.context/review-reports/` — ReviewerAgent outputs

---

## Pipeline Stages

### Stage 1: Market Research (MarketingAgent)
- Fetch App Store top charts and trending data across categories (non-games)
- Analyze category growth rates, review velocity, and monetization potential
- Identify the single best opportunity with defensible market position
- Output: `market-research.json` with chosen category + rationale

### Stage 2: App Naming (3× NamingAgent, parallel)
- Each NamingAgent receives: chosen category, App Store ASO guidelines
- Each proposes 5 name candidates with keyword scores, memorability score, App Store compliance check
- ManagerAgent runs consensus: highest combined score wins
- Output: `app-name.json` with final name + 3 keyword tags

### Stage 3: Design (DesignerAgent)
- Analyzes top 3 existing apps in chosen category (screenshots, reviews, patterns)
- Creates complete design system: colors, typography, spacing, component library
- Produces screen-by-screen wireframes for all core flows
- Output: `design-spec.json` with full design system + asset definitions

### Stage 4: GitHub Setup
- Rename repo (from "empty") to final app name
- Set up branch protection rules
- Create milestone structure

### Stage 5: Implementation (DeveloperAgent × 2, LocalizationAgent parallel)
Each feature gets its own branch. Workflow per feature:
1. Create branch: `feature/<feature-name>`
2. Implement with full production code (error handling, accessibility, tests)
3. QAAgent validates on branch
4. If QA passes → PR created
5. ReviewerAgent reviews PR
6. If approved → MergeAgent merges

**Feature branches in order:**
1. `feature/project-setup` — Xcode project, SPM dependencies, folder structure
2. `feature/design-system` — Colors, fonts, spacing tokens, reusable components
3. `feature/core-app-shell` — AppDelegate/App entry, tab/nav structure, theme engine
4. `feature/main-feature` — Primary app functionality (determined by market research)
5. `feature/admob-integration` — Google AdMob (banner ads, interstitial ads)
6. `feature/localization` — 30+ language `.strings` integration (parallel with above)
7. `feature/onboarding` — First-run flow, permissions, paywall (if applicable)
8. `feature/settings` — Settings screen, language picker, review prompt
9. `feature/app-store-assets` — App icon (all sizes), screenshots, metadata

### Stage 6: AdMob Integration
- `GoogleMobileAds` SPM package
- Banner ad: `GADBannerView` in main content view
- Interstitial ad: triggered on natural content transitions (not intrusive)
- Test ad IDs during development, real IDs injected via env at release
- GDPR/ATT consent flow (required for App Store)

### Stage 7: Localization (parallel pipeline)
30+ languages via `.strings` files + `Localizable.xcstrings` (Xcode 15+):
```
en, tr, fr, zh-Hans, zh-Hant, hi, es, ar, pt-BR, de, ja, ko, ru, it, nl, 
pl, sv, da, fi, nb, cs, hu, ro, uk, id, ms, th, vi, el, he, ca, sk, hr
```
- LocalizationAgent generates all translations in parallel
- All strings use String Catalog (`.xcstrings`) for Xcode native management
- RTL support for Arabic, Hebrew
- Proper pluralization rules per locale

### Stage 8: QA Protocol (QAAgent)
Per branch:
- Build check: `xcodebuild -scheme AppName -destination 'platform=iOS Simulator'`
- SwiftLint: zero errors
- Unit tests: all pass
- UI tests: core flows covered
- Accessibility: VoiceOver support verified
- Memory: no retain cycles (Instruments)

### Stage 9: App Store Submission Prep
- App icon generated at all required sizes (1024×1024 source, resized)
- Screenshots for 6.7", 6.5", 5.5" iPhone + iPad (if universal)
- App Store Connect metadata in all 30+ languages
- Privacy manifest (PrivacyInfo.xcprivacy)
- Export compliance declaration

---

## Technical Architecture — iOS App

### Project Structure
```
AppName/
├── App/
│   ├── AppNameApp.swift
│   ├── AppDelegate.swift
│   └── Info.plist
├── Core/
│   ├── DesignSystem/
│   │   ├── Colors.swift
│   │   ├── Typography.swift
│   │   └── Spacing.swift
│   ├── Components/
│   │   ├── PrimaryButton.swift
│   │   ├── AdBannerView.swift
│   │   └── ...
│   └── Extensions/
├── Features/
│   ├── Onboarding/
│   ├── Main/
│   └── Settings/
├── Services/
│   ├── AdService.swift
│   ├── LocalizationService.swift
│   └── AnalyticsService.swift
├── Resources/
│   ├── Localizable.xcstrings
│   ├── Assets.xcassets
│   └── ...
└── Tests/
    ├── Unit/
    └── UI/
```

### Dependencies (SPM)
- `GoogleMobileAds` — AdMob
- `SwiftLint` (build tool plugin)
- TBD based on market research outcome

### SwiftUI Architecture
- **Pattern**: MVVM + ObservableObject / @Observable (iOS 17+)
- **Minimum deployment**: iOS 16.0 (covers 95%+ of active devices)
- **Orientation**: Portrait primary (landscape supported where applicable)
- **Dynamic Type**: full support
- **Dark Mode**: full support

---

## GitHub Workflow

### Branch Strategy
- `main` — protected, requires PR + approval
- `feature/*` — feature branches created per stage
- `fix/*` — bug fix branches from QA failures

### PR Template
Each PR includes:
- [ ] Feature implemented completely
- [ ] QA passed (linked report)
- [ ] SwiftLint: 0 errors
- [ ] Tests: all passing
- [ ] Accessibility: checked
- [ ] Screenshots/recordings attached (for UI changes)

### Review Gates
1. QAAgent: automated checks must pass before PR is created
2. ReviewerAgent: code quality + architecture review
3. MergeAgent: only merges after reviewer approval

---

## Success Criteria

1. App runs without crashes on iOS 16+ simulator and device
2. All 30+ locales display correctly (including RTL)
3. AdMob ads load and display correctly
4. App Store submission package complete (binary + metadata + assets)
5. All tests pass
6. Zero SwiftLint errors
7. Privacy manifest complete and accurate
8. GDPR/ATT consent flow functional

---

## Out of Scope

- Backend/server infrastructure (app is client-only)
- Push notifications (Phase 2)
- In-app purchases (Phase 2, unless market research recommends it)
- Android version (Phase 2)
- Physical device testing (simulator-validated)

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Market research selects saturated category | Medium | High | Use multiple signals: growth rate + review velocity + monetization potential |
| AdMob approval delay | Low | Medium | Start with test IDs, parallelize submission |
| Localization quality issues | Medium | Low | Use Claude for translations + native speaker review notes |
| iOS version compatibility | Low | High | Target iOS 16+ to avoid APIs not available on older devices |
| App Store rejection | Medium | High | Follow HIG strictly, use review guidelines checklist |
<!-- /autoplan restore point: /Users/yusufbayindir/.gstack/projects/yusufbayindir-empty/multi-agent-app-builder-pipeline-autoplan-restore-20260629-143903.md -->

---

## GSTACK REVIEW REPORT

### Phase 1: CEO Review

#### CEO DUAL VOICES — CONSENSUS TABLE
```
═══════════════════════════════════════════════════════════════
  Dimension                           Claude  Codex  Consensus
  ──────────────────────────────────── ─────── ─────── ─────────
  1. Premises valid?                   ⚠ Mix   ⚠ Mix   DISAGREE (5/7 questioned)
  2. Right problem to solve?           ⚠ Maybe  ❌ No   DISAGREE (reframe needed)
  3. Scope calibration correct?        ❌ No    ❌ No   CONFIRMED: Over-scoped at launch
  4. Alternatives sufficiently explored? ❌ No  ❌ No   CONFIRMED: Missed IAP, wedge, narrow locale
  5. Competitive/market risks covered? ❌ No    ❌ No   CONFIRMED: No UA, no retention, no moat
  6. 6-month trajectory sound?         ⚠ Risk  ❌ Risk  CONFIRMED: Compiles ≠ traction
═══════════════════════════════════════════════════════════════
```

#### Premise Challenge (Step 0A)

| # | Premise | Status | Verdict |
|---|---------|--------|---------|
| P1 | Multi-agent pipeline → production quality | ASSUMED | QUESTIONABLE — agents share biases; code hygiene ≠ product quality |
| P2 | Market research agent finds viable category | ASSUMED | QUESTIONABLE — lagging indicators, no CAC/retention signal |
| P3 | 30+ language localization adds distribution | ASSUMED | QUESTIONABLE — premature before single user validates core |
| P4 | AdMob-only is viable monetization | ASSUMED | QUESTIONABLE — eCPM near zero at cold-start DAU |
| P5 | GitHub PR workflow adds quality control | PARTIALLY VALID | Same model = correlated blind spots; ceremony without diversity |
| P6 | iOS 16+ covers 95%+ active devices | STATED | VALID — confirmed by both models |
| P7 | Simulator QA sufficient for App Store | ASSUMED | QUESTIONABLE — AdMob, memory, GPU differ on device |

#### Dream State Delta (Step 0C)
```
CURRENT STATE → THIS PLAN → 12-MONTH IDEAL
     Empty repo       App compiles, submits     Top-50 chart in chosen category
                      30+ locales loaded         1,000+ DAU
                      AdMob integrated           Positive AdMob ARPDAU
                      Tests pass                 User reviews ≥4.2 stars
                      PR workflow active         Real iteration from analytics data
```
Gap: The plan gets from CURRENT → PLAN but has no mechanism to get PLAN → IDEAL.

#### Implementation Alternatives (Step 0C-bis)

| Approach | Effort | Risk | Pros | Cons |
|----------|--------|------|------|------|
| A) Full auto pipeline (current plan) | CC: ~8h | HIGH | Demonstrates agentic dev end-to-end | No human quality gate; category risk |
| B) Human-gated pipeline (recommended) | CC: ~8h + 2 human decisions | MEDIUM | Category + arch decisions anchored by human; far better product odds | Slightly slower |
| C) Known category + automated build | CC: ~6h | LOW | Eliminates highest-risk stage; proves pipeline quality | Less impressive as a full-auto demo |

**Auto-decision: Option B (P1 + P6 — completeness + bias toward action with real quality gate)**

#### Scope Decisions (Step 0D)

**NOT in scope (deferred to TODOS.md):**
- 30+ language localization → reduce to 5-7 tier-1 locales at launch (en, zh-Hans, es, fr, de, ja, tr)
- Simulator-only QA → add device validation step for AdMob specifically
- AdMob-only monetization → add $0.99 one-time purchase as primary; AdMob as supplement

**What already exists:**
- GitHub repo: https://github.com/yusufbayindir/empty.git (empty, initial commit)
- No existing iOS code, SPM packages, or configuration

#### Error & Rescue Registry

| Error | Trigger | Recovery |
|-------|---------|---------|
| Market research selects saturated category | Human gate rejects output | Re-run MarketingAgent with stricter defensibility criteria |
| App Store rejection 4.3 (copycat) | Submission review | Add unique feature hook; resubmit with differentiation argument |
| AdMob policy violation | Revenue disabled | Review content policy; implement proper consent flow |
| Agent produces non-compiling Swift | CI build fails | QAAgent catches; DeveloperAgent re-runs with error context |
| Merge conflict on localization strings | MergeAgent blocked | ManagerAgent serializes LocalizationAgent merge |
| Privacy manifest missing key | App Store rejection | DesignerAgent audit runs PrivacyInfo check as part of Stage 9 |

#### Failure Modes Registry

| Mode | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| Category is saturated/wrong | MEDIUM | CRITICAL | Human approval gate at Stage 1 output |
| Architectural errors compound across branches | MEDIUM | HIGH | ADR document locks architecture before Stage 5 |
| AdMob cold-start revenue is near zero | HIGH | MEDIUM | Add IAP; set revenue expectations correctly |
| App Store rejection | MEDIUM | HIGH | Follow HIG strictly; add distinctive feature |
| Localization quality causes rejection | LOW | MEDIUM | Reduce to 7 locales; add manual review step |

#### CEO Completion Summary

**Strategic verdict: PROCEED with 4 modifications (2 required before code starts, 2 deferred)**

Required before Stage 5 (implementation):
1. Human approval gate at Stage 1 output (market research review)
2. Architecture Decision Record locked before feature branches start

Deferred but tracked in TODOS.md:
3. Reduce launch localization to 7 languages (expand post-launch)
4. Add $0.99 IAP as primary monetization; AdMob as supplementary

<!-- AUTONOMOUS DECISION LOG -->
## Decision Audit Trail

| # | Phase | Decision | Classification | Principle | Rationale | Rejected |
|---|-------|----------|-----------|-----------|----------|---------|
| 1 | CEO | Reduce launch locales from 30+ to 7 | Taste | P3 (pragmatic) + P1 (completeness of core product) | Both models confirm: 30 locales at launch is premature; 7 covers 70%+ of iOS revenue | Keep all 30 at launch |
| 2 | CEO | Add IAP supplement to AdMob | Mechanical | P1 (completeness) | Both models flag cold-start AdMob as near-zero revenue; IAP provides immediate monetization path | AdMob-only |
| 3 | CEO | Add human approval gate at Stage 1 | Taste | P6 (bias toward action with quality) | Both models flag unguarded auto-category selection as highest risk; single human decision eliminates it | Full automation |
| 4 | CEO | Add Architecture Decision Record pre-Stage 5 | Mechanical | P5 (explicit over clever) | Agents cannot reliably propagate architecture decisions through JSON; explicit ADR solves compound error risk | Rely on JSON state |

### Phase 2: Design Review

#### DESIGN DUAL VOICES — LITMUS SCORECARD
```
═══════════════════════════════════════════════════════════════════
  Dimension                             Claude  Codex  Consensus
  ──────────────────────────────────── ─────── ─────── ─────────
  1. UI states fully specified?          ❌ 1/10  ❌ 1/10  CONFIRMED: CRITICAL gap
  2. Design system concrete?             ❌ 2/10  ❌ 2/10  CONFIRMED: underspecified
  3. AdMob placement thoughtful?         ❌ 2/10  ❌ 2/10  CONFIRMED: height/position unresolved
  4. Onboarding spec usable?             ❌ 1/10  ❌ 1/10  CONFIRMED: no screen spec
  5. RTL support designed?               ❌ 2/10  ❌ 2/10  CONFIRMED: asserted, not designed
  6. App Store visual quality?           ⚠ 4/10  ❌ 3/10  CONFIRMED: templated risk
  7. Dark Mode / Dynamic Type?           ✅ stated ✅ stated CONFIRMED: required but not tokenized
═══════════════════════════════════════════════════════════════════
```

#### Auto-Decided Design Decisions (added to ADR)

| # | Decision | Rationale |
|---|----------|-----------|
| D5 | Navigation: tab bar, 3 tabs (Main / History or Explore / Settings) | P5 — explicit contract needed before parallel feature branches; universal utility pattern |
| D6 | AdMob banner: bottom of screen, above tab bar, `safeAreaInset(.bottom)`, always reserve 50pt | P5 — prevents content reflow; resolves all placement questions |
| D7 | Interstitial triggers: post-primary-action only, min 60s interval, excluded from onboarding/settings/first 3 launches | P1 — App Store policy compliance + user trust |
| D8 | Design system: 8pt grid, SF Pro system font, 12pt card/8pt button radius, semantic color tokens | P5 — SF Pro has zero licensing/localization complexity; 8pt grid is industry standard |
| D9 | RTL policy: all layout uses `.leading`/`.trailing` semantically; directional icons use `.flipsForRightToLeftLayoutDirection`; RTL checked in QA on Arabic simulator | P1 — completeness for 30-locale coverage |
| D10 | Onboarding: 5 screens (value prop → feature → ATT pre-prompt → [system ATT] → paywall/skip); skip available from screen 2; state key: `hasCompletedOnboarding` | P5 — explicit spec prevents incompatible agent implementations |
| D11 | GDPR consent: use Google UMP SDK (no custom consent UI); configure via AdMob dashboard | P3 — pragmatic: UMP is maintained by Google, handles policy updates automatically |

#### Design Gaps → Added to Implementation Requirements

Critical items added to all DesignerAgent and DeveloperAgent context:
- Every screen requires 5 UI state variants: loading, empty, error, success, and zero-data
- Ad banner height (50pt) reserved at layout time, not injected post-load
- Illustrations must be non-directional or supply RTL asset variants
- Arabic/Hebrew: separate line height multiplier (1.4× Latin baseline)
- App review prompt trigger: after 3rd successful primary action + min 7 days post-install


### Phase 3: Engineering Review

#### ENG DUAL VOICES — CONSENSUS TABLE
```
═══════════════════════════════════════════════════════════════
  Dimension                           Claude  Codex  Consensus
  ──────────────────────────────────── ─────── ─────── ─────────
  1. Architecture sound?               ⚠ Issues ⚠ Issues CONFIRMED: 5 critical architecture gaps
  2. Test coverage sufficient?         ❌ No    ❌ No   CONFIRMED: AdMob, ATT, locale tests missing
  3. Performance risks addressed?      ⚠ Some  ⚠ Some  CONFIRMED: Ad banner re-render risk
  4. Security/privacy threats covered? ❌ No    ❌ No   CONFIRMED: Privacy manifest incomplete
  5. Error paths handled?              ❌ No    ⚠ Some  CONFIRMED: UI states undefined
  6. Deployment risk manageable?       ❌ No    ❌ No   CONFIRMED: No signing, archive, upload plan
═══════════════════════════════════════════════════════════════
```

#### Architecture ASCII Diagram

```
AppNameApp (@main)
    └── @UIApplicationDelegateAdaptor(AppDelegate.self)
    └── AppEnvironment (@EnvironmentObject, root)
         ├── AdService (singleton, MainActor)
         │    ├── GADMobileAds.start()    [after UMP+ATT]
         │    ├── GADBannerView (UIViewRepresentable)
         │    └── GADInterstitialAd (one-shot, pre-loads next after present)
         ├── PersistenceService (@AppStorage, UserDefaults)
         └── AnalyticsService (optional, Firebase)

ContentView (root SwiftUI)
    └── TabView (3 tabs: Main / History / Settings)
         ├── MainFeatureView
         │    └── AdBannerView (50pt, safeAreaInset .bottom, above TabBar)
         ├── HistoryView
         └── SettingsView (language picker, review prompt, restore IAP)

OnboardingView (modal, shown if !hasCompletedOnboarding)
    ├── Screen 1: Value proposition
    ├── Screen 2: Key feature (skip available)
    ├── Screen 3: ATT pre-prompt
    ├── [System ATT dialog]
    └── Screen 4: Paywall (if IAP enabled) or next screen

UMP Flow (AppDelegate.application(_:didFinishLaunchingWithOptions:)):
    1. UMPConsentInformation.requestConsentInfoUpdate
    2. Present consent form if required (GDPR users)
    3. Only after consent resolved: ATTrackingManager.requestTrackingAuthorization
    4. Only after ATT: GADMobileAds.sharedInstance().start()
```

#### Auto-Decided Engineering Decisions (added to ADR)

| # | Decision | Rationale |
|---|----------|-----------|
| D12 | Use `ObservableObject`+`@Published` only; NO `@Observable` (iOS 17+) | P5 — deployment target is iOS 16; mixing causes compile/runtime failures |
| D13 | AppDelegate wired via `@UIApplicationDelegateAdaptor`; AdMob init in `didFinishLaunching` | P5 — required for correct AdMob SDK initialization |
| D14 | `AdService`: preload next interstitial immediately after `willPresentFullScreenContent` | P5 — `GADInterstitialAd` is one-shot; failure to reload = no next ad |
| D15 | All services injected via single `AppEnvironment` `@EnvironmentObject` at root | P5 — prevents inconsistent DI patterns across 9 feature branches |
| D16 | Remove `LocalizationService.swift`; use `String(localized:)` + `.xcstrings` catalog | P4 — DRY; two string systems = split corpus |
| D17 | UMP before ATT before AdMob start; exact order locked in ADR | P1 — legal compliance; incorrect order = GDPR violation |
| D18 | Ad unit IDs in `AdsConfig.swift` with `#if DEBUG` guard; test IDs as constants | P5 — "env injection at release" is not valid iOS; test IDs: banner `ca-app-pub-3940256099942544/2934735716`, interstitial `ca-app-pub-3940256099942544/4411468910` |
| D19 | Add `GoogleUserMessagingPlatform` to SPM dependencies | P1 — UMP is required for GDPR; separate package from AdMob |
| D20 | Swift 5 language mode (not Swift 6) | P5 — Swift 6 actor isolation requires migration pass; avoid compilation failures |
| D21 | `NavigationStack` with `navigationDestination(for:)` exclusively | P5 — `NavigationView` deprecated iOS 16 |
| D22 | All async work via `.task {}` view modifier (auto-cancels); NO `Task {}` in `.onAppear` | P5 — prevents concurrent load races on navigation |
| D23 | `force_unwrapping = error` in SwiftLint config | P1 — force unwraps in View body crash with no context |
| D24 | `AdBannerView` placed at TabView wrapper level with stable `.id()`; NOT inside scrolling content | P5 — prevents re-render causing constant new ad requests |
| D25 | `ITSAppUsesNonExemptEncryption = NO` in Info.plist | P5 — required for App Store upload; blocks submission if missing |
| D26 | `xcodebuild test -resultBundlePath ./TestResults.xcresult` | P5 — required for agent retry logic on failures |
| D27 | `GADApplicationIdentifier` in Info.plist = test App ID during development | P5 — missing key = crash at launch |
| D28 | `NSUserTrackingUsageDescription` in Info.plist required before any ATT call | P1 — missing = crash; App Store rejection |
| D29 | Privacy manifest required entries: `NSPrivacyTracking=true`, tracking domains: `googleadservices.com`, `googlesyndication.com`, `doubleclick.net`; accessed API types: UserDefaults CA92.1, FileTimestamp C617.1, SystemBootTime 35F9.1, DiskSpace E174.1 | P1 — automated App Store validation rejects binary without these |
| D30 | Add signing, archive, and export steps to Stage 9: `xcodebuild archive` + `xcodebuild -exportArchive` + App Store Connect API key | P1 — no archive = no submission |
| D31 | Feature branch dependency locks: `admob` blocked on `core-app-shell` merged; `localization` string-extract gates on `main-feature` partial merge; `settings` blocked on `localization` merged | P5 — prevents incompatible parallel agent assumptions |
| D32 | Add `swift-snapshot-testing` for visual regression tests | P1 — multi-agent design changes need snapshot tests |
| D33 | Locale CI matrix: `en`, `ar`, `zh-Hans` simulator runs required | P1 — RTL and CJK layout breaks require locale-specific runs |
| D34 | `SKAdNetworkItems` in Info.plist: add Google SKAdNetwork IDs for AdMob | P1 — required for iOS 14+ attribution; affects AdMob revenue |

#### Test Plan (written to disk)

Test plan artifact: `~/.gstack/projects/yusufbayindir-empty/test-plan-multi-agent-app-builder.md`

Test matrix:
| Category | Tool | What's Covered |
|----------|------|----------------|
| Build | xcodebuild | Simulator + device archive |
| Lint | SwiftLint | Style + force_unwrapping error |
| Unit | XCTest | ViewModels, AdService, PersistenceService, ATT state machine |
| UI | XCUITest | Core flows in en, ar, zh-Hans |
| Snapshot | swift-snapshot-testing | Design system components |
| Performance | XCTMemoryMetric | Memory allocations; leaks tool |
| Localization | xcodebuild -exportLocalizations | .xcstrings completeness |
| Privacy | App Store Connect validation | Privacy manifest completeness |


### Phase 3.5: DX Review (Developer/Agent Experience)

**DX score: 3/10 (agents are the primary users; pipeline is agent-unreadable in current form)**

#### DX CONSENSUS TABLE (subagent-only — Codex skipped for DX phase, Claude subagent comprehensive)
```
═════════════════════════════════════════════════════════════
  Dimension                           Claude  Consensus
  ──────────────────────────────────── ─────── ─────────
  1. .context/ schemas sufficient?     ❌ 1/10  CRITICAL: no field definitions
  2. Stage gate clarity?               ❌ 2/10  CRITICAL: hand-off protocol missing
  3. GitHub commands specified?        ❌ 1/10  HIGH: prose only, no actual commands
  4. ADR template defined?             ❌ 1/10  HIGH: path, schema, authority undefined
  5. Naming conventions consistent?    ❌ 2/10  HIGH: bundle ID, symbols, commits undefined
  6. QA failure retry protocol?        ❌ 1/10  CRITICAL: no termination condition → infinite loop
═════════════════════════════════════════════════════════════
```

#### Auto-Decided DX Fixes

| # | Decision | Rationale |
|---|----------|-----------|
| D35 | Define all .context/ JSON schemas; add SCHEMA.md with field types | P5 — agents need machine-readable contracts, not prose descriptions |
| D36 | ADR lives at `.context/ADR.md`; has status field `locked/proposed`; consolidates D5–D34 | P5 — agents receive ADR path in every task prompt; decisions not in ADR don't count |
| D37 | Commit convention: Conventional Commits (`feat:`, `fix:`, `chore:`); PR title: `feat(<feature>): <description>` | P5 — prevents incompatible history across 9 branches |
| D38 | Bundle ID: `com.yusufbayindir.<appname-lowercase-nospaces>`; Swift type: PascalCase of app name; written to `state.json` at Stage 4 | P5 — irreversible; must be decided once and read from state |
| D39 | QA retry limit: 3 retries per branch, then human escalation; `retryCount` field in `state.json` per branch | P1 — infinite retry loop is the most likely catastrophic failure mode |
| D40 | GitHub Actions CI workflow file added in `feature/project-setup`; runs on push and PR; required status checks block merge | P1 — without CI, branch protection is ceremonial |
| D41 | Merge strategy: squash merge only; squash commit uses PR title | P5 — clean main history for agent-built repo |
| D42 | Exact `gh` commands specified for: repo rename, branch protection, PR create, PR approve, PR merge | P5 — prose descriptions unusable as agent instructions |

#### DX Implementation Checklist (added to ADR)

Before Stage 5 starts, the following must exist:
- [ ] `.context/SCHEMA.md` — JSON schema for all context files
- [ ] `.context/ADR.md` — all D5–D42 consolidated, status=locked
- [ ] `.github/workflows/ci.yml` — CI pipeline (merged via `feature/project-setup`)
- [ ] `.github/pull_request_template.md` — PR checklist
- [ ] `.context/state.json` — initialized with `appName`, `repoUrl`, `localeScope=7`, `adrLocked=true`, `featureBranches=[]`

TTHW (Time-to-Hello-World) for a DeveloperAgent: estimated 45 min without ADR → estimated 8 min with ADR + SCHEMA.md.


### Cross-Phase Themes

**Theme 1: Agents share biases — independent review ≠ independent judgment**
Flagged in Phase 1 (CEO) AND Phase 3 (Eng). High-confidence signal. Both models independently identified that DeveloperAgent + ReviewerAgent running the same base model will miss the same architectural errors. Mitigation locked: human approval gate at Stage 1 + ADR that both agents must explicitly acknowledge.

**Theme 2: Plan optimizes for build artifact, not product outcome**
Flagged in Phase 1 (CEO — 6-month regret scenario) AND Phase 2 (Design — 2/10 UX completeness). High-confidence signal. Success criteria measure compilation + test pass, not user acquisition, retention, or revenue. Mitigation: add concrete KPIs to success criteria (installs, D1 retention benchmark, AdMob ARPDAU target).

**Theme 3: Privacy/compliance is underspecified and submission-blocking**
Flagged in Phase 3 (Eng — ATT, UMP, privacy manifest) AND Phase 3.5 (DX — no commands, no enforcement). High-confidence signal. Multiple submission blockers identified: missing `GADApplicationIdentifier`, missing privacy manifest entries, wrong UMP→ATT order. Mitigation: D17–D29 added to ADR; compliance checklist in QA gate.

**Theme 4: Agent-to-agent context transfer is the critical failure point**
Flagged in Phase 1 (CEO — JSON state as "lossy medium") AND Phase 3.5 (DX — no schemas, no hand-off protocol). High-confidence signal. The entire pipeline depends on agents correctly reading each other's outputs. Without typed schemas, agents fabricate field names. Mitigation: D35–D38 add SCHEMA.md and typed context files before any agent runs.

