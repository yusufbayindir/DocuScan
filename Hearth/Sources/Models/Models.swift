import Foundation
import SwiftUI

// MARK: - Enums

enum PrivacyLevel: String, Codable, CaseIterable {
    case full, balanceOnly, hidden

    var label: String {
        switch self {
        case .full:        return "Full"
        case .balanceOnly: return "Balance"
        case .hidden:      return "Hidden"
        }
    }
    var icon: String {
        switch self {
        case .full:        return "eye.fill"
        case .balanceOnly: return "eye.slash.fill"
        case .hidden:      return "lock.fill"
        }
    }
    var description: String {
        switch self {
        case .full:        return "Partner sees all transactions and balances"
        case .balanceOnly: return "Partner sees balance only, not transactions"
        case .hidden:      return "Partner sees this account exists, nothing more"
        }
    }
}

enum AccountType: String, Codable {
    case checking, savings, creditCard, investment, cash
    var label: String {
        switch self {
        case .checking:   return "Checking"
        case .savings:    return "Savings"
        case .creditCard: return "Credit Card"
        case .investment: return "Investment"
        case .cash:       return "Cash"
        }
    }
}

enum InsightType: String, Codable {
    case proactiveWarning, positiveInsight, subscriptionAlert, monthlyRecap, goalProgress
}

enum InsightSeverity: String, Codable {
    case low, medium, high, critical
}

enum SubscriptionTier: String, Codable {
    case free, trial, premium
    var label: String {
        switch self {
        case .free:    return "Free"
        case .trial:   return "Free Trial"
        case .premium: return "Premium"
        }
    }
}

enum TransactionFilter: String, CaseIterable {
    case all, mine, partner, split, unreviewed
    var label: String {
        switch self {
        case .all:        return "All"
        case .mine:       return "Mine"
        case .partner:    return "Partner's"
        case .split:      return "Split"
        case .unreviewed: return "Unreviewed"
        }
    }
}

// MARK: - Models

struct Partner: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var email: String
    var initials: String { String(name.prefix(2)).uppercased() }
    var isPartnerA: Bool = true
}

struct Account: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var bankName: String
    var type: AccountType
    var balance: Double
    var privacyLevel: PrivacyLevel = .full
    var partnerId: UUID
    var lastSync: Date = Date()
    var isConnected: Bool = true
    var isMyAccount: Bool = true

    var displayBalance: String {
        switch privacyLevel {
        case .full:        return balance.formatted(.currency(code: "USD"))
        case .balanceOnly: return "$\(Int(balance).formatted())"
        case .hidden:      return "••••••"
        }
    }
}

struct Category: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var emoji: String
    var colorHex: String
}

struct Transaction: Identifiable, Codable {
    var id: UUID = UUID()
    var merchantName: String
    var amount: Double
    var date: Date
    var categoryId: UUID
    var isReviewed: Bool = false
    var note: String? = nil
    var emoji: String? = nil
    var partnerId: UUID
    var isSplit: Bool = false
    var splitAmount: Double? = nil
    var isIncome: Bool = false
    var accountId: UUID
}

struct Goal: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var emoji: String
    var targetAmount: Double
    var partnerAContribution: Double = 0
    var partnerBContribution: Double = 0
    var targetDate: Date? = nil
    var isCompleted: Bool = false
    var isPaused: Bool = false

    var totalContributed: Double { partnerAContribution + partnerBContribution }
    var progress: Double { targetAmount > 0 ? min(totalContributed / targetAmount, 1.0) : 0 }
    var percentFunded: Int { Int(progress * 100) }
    var remaining: Double { max(targetAmount - totalContributed, 0) }
}

struct AIInsight: Identifiable, Codable {
    var id: UUID = UUID()
    var type: InsightType
    var message: String
    var severity: InsightSeverity
    var categoryId: UUID?
    var actionLabel: String? = nil
    var issuedAt: Date = Date()
    var isDismissed: Bool = false
}

struct Bill: Identifiable, Codable {
    var id: UUID = UUID()
    var merchantName: String
    var amount: Double
    var dueDate: Date
    var isRecurring: Bool = true
    var partnerAChecked: Bool = false
    var partnerBChecked: Bool = false
    var iconName: String = "calendar.badge.clock"

    var isDueSoon: Bool {
        let days = Calendar.current.dateComponents([.day], from: Date(), to: dueDate).day ?? 99
        return days <= 2 && days >= 0
    }
    var isOverdue: Bool { dueDate < Date() }
}

struct AppUser: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var email: String
    var partnerId: UUID? = nil
    var subscriptionTier: SubscriptionTier = .trial
    var trialEndDate: Date = Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date()
    var initials: String { String(name.prefix(2)).uppercased() }
    var isPartnerA: Bool = true
}
