import Foundation

enum MockDataService {
    static let partnerAId = UUID(uuidString: "AAAAAAAA-0000-0000-0000-000000000001")!
    static let partnerBId = UUID(uuidString: "BBBBBBBB-0000-0000-0000-000000000002")!

    static let categories: [Category] = [
        Category(id: UUID(uuidString: "CAT00001-0000-0000-0000-000000000001")!, name: "Food & Dining", emoji: "🍔", colorHex: "#FF6B35"),
        Category(id: UUID(uuidString: "CAT00002-0000-0000-0000-000000000002")!, name: "Groceries",     emoji: "🛒", colorHex: "#4CAF50"),
        Category(id: UUID(uuidString: "CAT00003-0000-0000-0000-000000000003")!, name: "Shopping",      emoji: "🛍️", colorHex: "#9C27B0"),
        Category(id: UUID(uuidString: "CAT00004-0000-0000-0000-000000000004")!, name: "Transport",     emoji: "🚗", colorHex: "#2196F3"),
        Category(id: UUID(uuidString: "CAT00005-0000-0000-0000-000000000005")!, name: "Entertainment", emoji: "🎬", colorHex: "#E91E63"),
        Category(id: UUID(uuidString: "CAT00006-0000-0000-0000-000000000006")!, name: "Health",        emoji: "💊", colorHex: "#00BCD4"),
        Category(id: UUID(uuidString: "CAT00007-0000-0000-0000-000000000007")!, name: "Travel",        emoji: "✈️", colorHex: "#FF9800"),
        Category(id: UUID(uuidString: "CAT00008-0000-0000-0000-000000000008")!, name: "Utilities",     emoji: "🏠", colorHex: "#607D8B"),
        Category(id: UUID(uuidString: "CAT00009-0000-0000-0000-000000000009")!, name: "Coffee",        emoji: "☕", colorHex: "#795548"),
        Category(id: UUID(uuidString: "CAT00010-0000-0000-0000-000000000010")!, name: "Subscriptions", emoji: "📱", colorHex: "#3F51B5"),
        Category(id: UUID(uuidString: "CAT00011-0000-0000-0000-000000000011")!, name: "Fitness",       emoji: "💪", colorHex: "#F44336"),
        Category(id: UUID(uuidString: "CAT00012-0000-0000-0000-000000000012")!, name: "Beauty",        emoji: "💄", colorHex: "#EC407A"),
        Category(id: UUID(uuidString: "CAT00013-0000-0000-0000-000000000013")!, name: "Education",     emoji: "📚", colorHex: "#009688"),
        Category(id: UUID(uuidString: "CAT00014-0000-0000-0000-000000000014")!, name: "Gifts",         emoji: "🎁", colorHex: "#E91E63"),
        Category(id: UUID(uuidString: "CAT00015-0000-0000-0000-000000000015")!, name: "Income",        emoji: "💰", colorHex: "#4CAF50"),
        Category(id: UUID(uuidString: "CAT00016-0000-0000-0000-000000000016")!, name: "Other",         emoji: "📦", colorHex: "#9E9E9E"),
    ]

    static func setupAppState(_ state: AppState) {
        state.currentUser = AppUser(
            id: partnerAId,
            name: "Alex",
            email: "alex@example.com",
            partnerId: partnerBId,
            subscriptionTier: .trial,
            isPartnerA: true
        )
        state.partner = Partner(
            id: partnerBId,
            name: "Jordan",
            email: "jordan@example.com",
            isPartnerA: false
        )
        state.categories = categories
        state.accounts = makeAccounts()
        state.transactions = makeTransactions()
        state.goals = makeGoals()
        state.insights = makeInsights()
        state.bills = makeBills()
        state.isOnboarded = true
    }

    private static func makeAccounts() -> [Account] {
        let checkingId = UUID(uuidString: "ACC00001-0000-0000-0000-000000000001")!
        let creditId   = UUID(uuidString: "ACC00002-0000-0000-0000-000000000002")!
        let savingsId  = UUID(uuidString: "ACC00003-0000-0000-0000-000000000003")!
        let jordanId   = UUID(uuidString: "ACC00004-0000-0000-0000-000000000004")!
        return [
            Account(id: checkingId, name: "Chase Total Checking",  bankName: "Chase",  type: .checking,    balance: 4_823.41,  privacyLevel: .full,        partnerId: partnerAId, isMyAccount: true),
            Account(id: creditId,   name: "Amex Gold Card",        bankName: "Amex",   type: .creditCard,  balance: -1_204.88, privacyLevel: .full,        partnerId: partnerAId, isMyAccount: true),
            Account(id: savingsId,  name: "Ally High-Yield Savings",bankName: "Ally",  type: .savings,     balance: 18_500.00, privacyLevel: .balanceOnly, partnerId: partnerAId, isMyAccount: true),
            Account(id: jordanId,   name: "Wells Fargo Checking",   bankName: "Wells", type: .checking,    balance: 3_241.19,  privacyLevel: .full,        partnerId: partnerBId, isMyAccount: false),
        ]
    }

    private static func makeTransactions() -> [Transaction] {
        let checkingId = UUID(uuidString: "ACC00001-0000-0000-0000-000000000001")!
        let creditId   = UUID(uuidString: "ACC00002-0000-0000-0000-000000000002")!
        let jordanId   = UUID(uuidString: "ACC00004-0000-0000-0000-000000000004")!

        let catFood  = categories[0].id
        let catGroc  = categories[1].id
        let catShop  = categories[2].id
        let catTrans = categories[3].id
        let catEnt   = categories[4].id
        let catCoffee = categories[8].id
        let catSub   = categories[9].id
        let catIncome = categories[14].id

        func daysAgo(_ n: Int) -> Date {
            Calendar.current.date(byAdding: .day, value: -n, to: Date()) ?? Date()
        }

        return [
            Transaction(id: UUID(), merchantName: "Trader Joe's",       amount: 124.52, date: daysAgo(0),  categoryId: catGroc,  isReviewed: false, partnerId: partnerAId, accountId: creditId),
            Transaction(id: UUID(), merchantName: "Sweetgreen",          amount: 18.40,  date: daysAgo(0),  categoryId: catFood,  isReviewed: false, partnerId: partnerAId, accountId: creditId),
            Transaction(id: UUID(), merchantName: "Starbucks",           amount: 7.25,   date: daysAgo(1),  categoryId: catCoffee,isReviewed: true,  partnerId: partnerAId, accountId: creditId),
            Transaction(id: UUID(), merchantName: "Netflix",             amount: 22.99,  date: daysAgo(1),  categoryId: catSub,   isReviewed: true,  partnerId: partnerAId, isSplit: true, splitAmount: 11.50, accountId: creditId),
            Transaction(id: UUID(), merchantName: "Whole Foods",         amount: 89.15,  date: daysAgo(2),  categoryId: catGroc,  isReviewed: true,  partnerId: partnerBId, accountId: jordanId),
            Transaction(id: UUID(), merchantName: "Lyft",                amount: 14.80,  date: daysAgo(2),  categoryId: catTrans, isReviewed: false, partnerId: partnerAId, accountId: creditId),
            Transaction(id: UUID(), merchantName: "Amazon",              amount: 67.43,  date: daysAgo(3),  categoryId: catShop,  isReviewed: false, partnerId: partnerBId, accountId: jordanId),
            Transaction(id: UUID(), merchantName: "Chipotle",            amount: 23.10,  date: daysAgo(3),  categoryId: catFood,  isReviewed: true,  partnerId: partnerAId, accountId: creditId),
            Transaction(id: UUID(), merchantName: "Spotify",             amount: 16.99,  date: daysAgo(4),  categoryId: catSub,   isReviewed: true,  partnerId: partnerAId, isSplit: true, splitAmount: 8.50, accountId: creditId),
            Transaction(id: UUID(), merchantName: "CVS Pharmacy",        amount: 34.20,  date: daysAgo(4),  categoryId: catGroc,  isReviewed: false, partnerId: partnerBId, accountId: jordanId),
            Transaction(id: UUID(), merchantName: "Uber",                amount: 22.50,  date: daysAgo(5),  categoryId: catTrans, isReviewed: true,  partnerId: partnerAId, accountId: creditId),
            Transaction(id: UUID(), merchantName: "The Farm Table",      amount: 142.80, date: daysAgo(5),  categoryId: catFood,  isReviewed: false, note: "Anniversary dinner 🎉", partnerId: partnerAId, accountId: creditId),
            Transaction(id: UUID(), merchantName: "Target",              amount: 91.34,  date: daysAgo(6),  categoryId: catShop,  isReviewed: true,  partnerId: partnerBId, accountId: jordanId),
            Transaction(id: UUID(), merchantName: "Apple Music",         amount: 10.99,  date: daysAgo(7),  categoryId: catSub,   isReviewed: true,  partnerId: partnerAId, accountId: creditId),
            Transaction(id: UUID(), merchantName: "Costco",              amount: 215.60, date: daysAgo(8),  categoryId: catGroc,  isReviewed: true,  partnerId: partnerAId, isSplit: true, splitAmount: 107.80, accountId: checkingId),
            Transaction(id: UUID(), merchantName: "AMC Theatres",        amount: 38.50,  date: daysAgo(9),  categoryId: catEnt,   isReviewed: true,  partnerId: partnerAId, isSplit: true, splitAmount: 19.25,  accountId: creditId),
            Transaction(id: UUID(), merchantName: "H&M",                 amount: 78.00,  date: daysAgo(10), categoryId: catShop,  isReviewed: true,  partnerId: partnerBId, accountId: jordanId),
            Transaction(id: UUID(), merchantName: "Blue Bottle Coffee",  amount: 8.50,   date: daysAgo(11), categoryId: catCoffee,isReviewed: true,  partnerId: partnerAId, accountId: creditId),
            Transaction(id: UUID(), merchantName: "Employer",            amount: 4_200.00,date: daysAgo(15),categoryId: catIncome,isReviewed: true,  partnerId: partnerAId, isIncome: true, accountId: checkingId),
            Transaction(id: UUID(), merchantName: "Employer",            amount: 3_800.00,date: daysAgo(15),categoryId: catIncome,isReviewed: true,  partnerId: partnerBId, isIncome: true, accountId: jordanId),
        ]
    }

    private static func makeGoals() -> [Goal] {
        let future3m = Calendar.current.date(byAdding: .month, value: 3, to: Date()) ?? Date()
        let future6m = Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date()
        let future12m = Calendar.current.date(byAdding: .month, value: 12, to: Date()) ?? Date()
        return [
            Goal(id: UUID(), name: "Tokyo Trip",           emoji: "✈️", targetAmount: 5_000,  partnerAContribution: 1_200, partnerBContribution: 800,  targetDate: future3m),
            Goal(id: UUID(), name: "Emergency Fund",       emoji: "🛡️", targetAmount: 10_000, partnerAContribution: 4_100, partnerBContribution: 2_400, targetDate: future6m),
            Goal(id: UUID(), name: "New Apartment Fund",   emoji: "🏠", targetAmount: 15_000, partnerAContribution: 1_500, partnerBContribution: 1_500, targetDate: future12m),
        ]
    }

    private static func makeInsights() -> [AIInsight] {
        let catFood = categories[0].id
        let catSub  = categories[9].id
        return [
            AIInsight(id: UUID(), type: .proactiveWarning, message: "You're on track to overspend dining by $180 this month — you've spent $342 with 11 days left and your usual is $280/month.", severity: .medium, categoryId: catFood,  actionLabel: "Review Dining"),
            AIInsight(id: UUID(), type: .subscriptionAlert, message: "Found 3 active subscriptions across both accounts totaling $50.97/month. You may have forgotten about one of them.", severity: .low,    categoryId: catSub,   actionLabel: "See Subscriptions"),
            AIInsight(id: UUID(), type: .positiveInsight,  message: "You're $200 under your shopping budget this month — great work staying on track! 🎉",                                   severity: .low,    categoryId: nil,      actionLabel: "See Details"),
        ]
    }

    private static func makeBills() -> [Bill] {
        func daysFromNow(_ n: Int) -> Date {
            Calendar.current.date(byAdding: .day, value: n, to: Date()) ?? Date()
        }
        return [
            Bill(id: UUID(), merchantName: "Rent",       amount: 2_800.00, dueDate: daysFromNow(1),  isRecurring: true,  partnerAChecked: true,  partnerBChecked: false, iconName: "house.fill"),
            Bill(id: UUID(), merchantName: "PG&E",       amount: 124.50,   dueDate: daysFromNow(5),  isRecurring: true,  partnerAChecked: false, partnerBChecked: false, iconName: "bolt.fill"),
            Bill(id: UUID(), merchantName: "Internet",   amount: 79.99,    dueDate: daysFromNow(8),  isRecurring: true,  partnerAChecked: true,  partnerBChecked: true,  iconName: "wifi"),
            Bill(id: UUID(), merchantName: "Netflix",    amount: 22.99,    dueDate: daysFromNow(12), isRecurring: true,  partnerAChecked: false, partnerBChecked: false, iconName: "play.rectangle.fill"),
            Bill(id: UUID(), merchantName: "Spotify",    amount: 16.99,    dueDate: daysFromNow(15), isRecurring: true,  partnerAChecked: false, partnerBChecked: false, iconName: "music.note"),
        ]
    }
}
