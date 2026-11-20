//
//  ArtworkRowView.swift
//  ArtFinderKit
//

import SwiftUI

struct ArtworkRowView: View {

    // MARK: - Properties

    let artwork: ArtworkRowUIModel

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .body) private var thumbnailSize: CGFloat = 64

    // MARK: - Body

    var body: some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: Spacing.small))
            : AnyLayout(HStackLayout(alignment: .center, spacing: Spacing.medium))

        layout {
            ArtworkImageView(url: artwork.thumbnailURL, contentMode: .fill)
                .frame(width: thumbnailSize, height: thumbnailSize)
                .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: Spacing.xSmall) {
                Text(artwork.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                if let artistName = artwork.artistName {
                    Text(artistName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                if let date = artwork.date {
                    Text(date)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, Spacing.xSmall)
    }
}
