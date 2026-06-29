import SwiftUI

// MARK: - RecentView

struct RecentView: View {
    @EnvironmentObject private var appEnvironment: AppEnvironment
    @State private var selectedDocument: DocuScanDocument?
    @State private var deleteError: Error?
    @State private var showDeleteError = false

    private var documentStore: DocumentStore { appEnvironment.documentStore }

    var body: some View {
        NavigationStack {
            Group {
                if documentStore.recentDocuments.isEmpty {
                    RecentEmptyStateView()
                } else {
                    recentList
                }
            }
            .navigationTitle(String(localized: "recent.title"))
            .navigationBarTitleDisplayMode(.large)
            .alert(
                String(localized: "recent.delete_error.title"),
                isPresented: $showDeleteError,
                actions: {
                    Button(String(localized: "common.ok"), role: .cancel) {}
                },
                message: {
                    if let error = deleteError {
                        Text(error.localizedDescription)
                    }
                }
            )
            .navigationDestination(for: DocuScanDocument.self) { document in
                DocumentViewerView(source: .saved(document))
            }
        }
        .withAdBanner()
    }

    // MARK: - Recent List

    private var recentList: some View {
        List {
            ForEach(documentStore.recentDocuments) { document in
                Button {
                    selectedDocument = document
                } label: {
                    DocumentRowView(document: document)
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(
                    top: Spacing.sm,
                    leading: Spacing.md,
                    bottom: Spacing.sm,
                    trailing: Spacing.md
                ))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        delete(document)
                    } label: {
                        Label(
                            String(localized: "recent.swipe.delete"),
                            systemImage: "trash.fill"
                        )
                    }
                }
            }
        }
        .listStyle(.plain)
    }

    // MARK: - Actions

    private func delete(_ document: DocuScanDocument) {
        do {
            try documentStore.delete(document)
        } catch {
            deleteError = error
            showDeleteError = true
        }
    }
}

// MARK: - Empty State

private struct RecentEmptyStateView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.dsPrimary.opacity(0.08))
                    .frame(width: 96, height: 96)

                Image(systemName: "clock.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(Color.dsPrimary.opacity(0.5))
            }

            VStack(spacing: Spacing.sm) {
                Text(String(localized: "recent.empty.title"))
                    .font(.dsTitle3)
                    .foregroundStyle(Color.dsTextPrimary)

                Text(String(localized: "recent.empty.subtitle"))
                    .font(.dsBody)
                    .foregroundStyle(Color.dsTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }

            Spacer()
        }
    }
}

// MARK: - Document Row View

struct DocumentRowView: View {
    let document: DocuScanDocument

    var body: some View {
        HStack(spacing: Spacing.md) {
            // File icon
            ZStack {
                RoundedRectangle(cornerRadius: Spacing.CornerRadius.small)
                    .fill(Color.dsPrimary.opacity(0.1))
                    .frame(width: 48, height: 56)

                VStack(spacing: 2) {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Color.dsPrimary)

                    Text("PDF")
                        .font(.dsCaption2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.dsPrimary)
                }
            }

            // Document info
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(document.name)
                    .font(.dsSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(2)

                HStack(spacing: Spacing.sm) {
                    // Page count
                    Label {
                        Text(
                            String(
                                localized: "recent.row.page_count",
                                defaultValue: "\(document.pageCount) pg"
                            )
                        )
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsTextSecondary)
                    } icon: {
                        Image(systemName: "doc.text")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.dsTextTertiary)
                    }

                    Text("·")
                        .foregroundStyle(Color.dsTextTertiary)
                        .font(.dsCaption1)

                    // File size
                    Text(document.fileSizeString)
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsTextSecondary)
                }

                // Date
                Text(document.createdAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.dsCaption1)
                    .foregroundStyle(Color.dsTextTertiary)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.dsTextTertiary)
        }
        .padding(Spacing.md)
        .cardStyle()
    }
}
