import SwiftUI

// MARK: - FavoritesView

struct FavoritesView: View {
    @EnvironmentObject private var appEnvironment: AppEnvironment
    @State private var selectedDocument: DocuScanDocument?

    private var documentStore: DocumentStore { appEnvironment.documentStore }

    var body: some View {
        NavigationStack {
            Group {
                if documentStore.favoriteDocuments.isEmpty {
                    FavoritesEmptyStateView()
                } else {
                    favoritesList
                }
            }
            .navigationTitle(String(localized: "favorites.title"))
            .navigationBarTitleDisplayMode(.large)
            .navigationDestination(for: DocuScanDocument.self) { document in
                DocumentViewerView(source: .saved(document))
            }
        }
        .withAdBanner()
    }

    // MARK: - Favorites List

    private var favoritesList: some View {
        List {
            ForEach(documentStore.favoriteDocuments) { document in
                Button {
                    selectedDocument = document
                } label: {
                    FavoriteDocumentRowView(document: document)
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
                    Button {
                        documentStore.toggleFavorite(document)
                    } label: {
                        Label(
                            String(localized: "favorites.swipe.remove"),
                            systemImage: "star.slash.fill"
                        )
                    }
                    .tint(Color.dsWarning)
                }
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Empty State

private struct FavoritesEmptyStateView: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.dsWarning.opacity(0.1))
                    .frame(width: 96, height: 96)

                Image(systemName: "star.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundStyle(Color.dsWarning.opacity(0.6))
            }

            VStack(spacing: Spacing.sm) {
                Text(String(localized: "favorites.empty.title"))
                    .font(.dsTitle3)
                    .foregroundStyle(Color.dsTextPrimary)

                Text(String(localized: "favorites.empty.subtitle"))
                    .font(.dsBody)
                    .foregroundStyle(Color.dsTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Spacing.xl)
            }

            Spacer()
        }
    }
}

// MARK: - Favorite Document Row

private struct FavoriteDocumentRowView: View {
    let document: DocuScanDocument

    var body: some View {
        HStack(spacing: Spacing.md) {
            // File icon with star accent
            ZStack(alignment: .topTrailing) {
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
                .frame(width: 48, height: 56)

                // Star badge
                ZStack {
                    Circle()
                        .fill(Color.dsBackground)
                        .frame(width: 18, height: 18)

                    Image(systemName: "star.fill")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Color.dsWarning)
                }
                .offset(x: 6, y: -6)
            }

            // Document info
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(document.name)
                    .font(.dsSubheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.dsTextPrimary)
                    .lineLimit(2)

                HStack(spacing: Spacing.sm) {
                    Label {
                        Text(
                            String(
                                localized: "favorites.row.page_count",
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

                    Text(document.fileSizeString)
                        .font(.dsCaption1)
                        .foregroundStyle(Color.dsTextSecondary)
                }

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
