import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var email: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        PartnerAvatar(name: appState.currentUser.name, isPartnerA: true, size: .lg)
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section("Personal Info") {
                    LabeledContent("Name") {
                        TextField("Your name", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    LabeledContent("Email") {
                        TextField("Email", text: $email)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.emailAddress)
                    }
                }

                Section("Subscription") {
                    LabeledContent("Plan") {
                        Text(appState.currentUser.subscriptionTier.displayName)
                            .foregroundColor(.hearthTerracotta)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundPrimary)
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if !name.isEmpty { appState.currentUser.name = name }
                        if !email.isEmpty { appState.currentUser.email = email }
                        dismiss()
                    }
                    .foregroundColor(.hearthTerracotta)
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                name = appState.currentUser.name
                email = appState.currentUser.email
            }
        }
    }
}

extension SubscriptionTier {
    var displayName: String {
        switch self {
        case .free:    return "Free"
        case .trial:   return "Premium Trial"
        case .premium: return "Premium"
        }
    }
}
