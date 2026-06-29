import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @State private var showProfile = false
    @State private var showAccountManagement = false
    @State private var showNotificationPrefs = false
    @State private var showPaywall = false

    var body: some View {
        NavigationStack {
            List {
                accountSection
                partnerSection
                preferencesSection
                subscriptionSection
                aboutSection
            }
            .listStyle(.insetGrouped)
            .background(Color.backgroundPrimary)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showProfile) { ProfileView() }
        .sheet(isPresented: $showAccountManagement) { AccountManagementView() }
        .sheet(isPresented: $showNotificationPrefs) { NotificationPrefsView() }
        .sheet(isPresented: $showPaywall) { PaywallView() }
    }

    private var accountSection: some View {
        Section {
            settingsRow(icon: "person.fill", color: .hearthTerracotta, title: "Profile") {
                showProfile = true
            }
            settingsRow(icon: "creditcard.fill", color: .hearthAmber, title: "Connected Accounts") {
                showAccountManagement = true
            }
        } header: {
            Text("Account")
        }
    }

    private var partnerSection: some View {
        Section {
            HStack(spacing: HS.md) {
                if let partner = appState.partner {
                    PartnerAvatar(name: partner.name, isPartnerA: false, size: .md)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(partner.name)
                            .font(.hearthBody)
                            .foregroundColor(.textPrimary)
                        Text("Partner connected")
                            .font(.hearthCaption2)
                            .foregroundColor(.semanticSuccessFg)
                    }
                } else {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 20))
                        .foregroundColor(.hearthTerracotta)
                    Text("Invite partner")
                        .font(.hearthBody)
                        .foregroundColor(.hearthTerracotta)
                }
            }
            .padding(.vertical, 4)
        } header: {
            Text("Partner")
        }
    }

    private var preferencesSection: some View {
        Section {
            settingsRow(icon: "bell.fill", color: .hearthCoral, title: "Notifications") {
                showNotificationPrefs = true
            }
            settingsRow(icon: "lock.shield.fill", color: .hearthSienna, title: "Privacy & Security") {}
        } header: {
            Text("Preferences")
        }
    }

    private var subscriptionSection: some View {
        Section {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.hearthAmber.opacity(0.15))
                        .frame(width: 32, height: 32)
                    Image(systemName: "star.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.hearthAmber)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Hearth Premium")
                        .font(.hearthBody)
                        .foregroundColor(.textPrimary)
                    Text(appState.currentUser.subscriptionTier == .premium ? "Active" : "Free Trial — 12 days left")
                        .font(.hearthCaption2)
                        .foregroundColor(.textTertiary)
                }
                Spacer()
                Button("Upgrade") { showPaywall = true }
                    .font(.hearthCaption1.weight(.semibold))
                    .foregroundColor(.hearthTerracotta)
            }
            .padding(.vertical, 4)
        } header: {
            Text("Subscription")
        }
    }

    private var aboutSection: some View {
        Section {
            settingsRow(icon: "questionmark.circle.fill", color: .textTertiary, title: "Help & Support") {}
            settingsRow(icon: "doc.text.fill", color: .textTertiary, title: "Privacy Policy") {}
            HStack {
                Text("Version")
                    .font(.hearthBody)
                    .foregroundColor(.textSecondary)
                Spacer()
                Text("1.0.0")
                    .font(.hearthBody)
                    .foregroundColor(.textTertiary)
            }
        } header: {
            Text("About")
        }
    }

    private func settingsRow(icon: String, color: Color, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: HS.md) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.15))
                        .frame(width: 32, height: 32)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(color)
                }
                Text(title)
                    .font(.hearthBody)
                    .foregroundColor(.textPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.textTertiary)
            }
            .padding(.vertical, 4)
        }
    }
}
