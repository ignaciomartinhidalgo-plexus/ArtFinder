//
//  ArtworkDetailView.swift
//  ArtFinderKit
//

import SwiftUI

public struct ArtworkDetailView: View {

    // MARK: - Properties

    private let viewModel: ArtworkDetailViewModel

    // MARK: - Initializer

    public init(viewModel: ArtworkDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.xLarge) {
                if let image = viewModel.artworkDetail.image {
                    ArtworkImageView(url: image.url, contentMode: .fit)
                        .aspectRatio(CGFloat(image.aspectRatio), contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(image.accessibilityLabel)
                        .accessibilityAddTraits(.isImage)
                        .accessibilityIdentifier(AccessibilityIdentifier.detailImage)
                }

                Text(viewModel.artworkDetail.title)
                    .font(.title.bold())
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityIdentifier(AccessibilityIdentifier.detailTitle)

                VStack(alignment: .leading, spacing: Spacing.large) {
                    ForEach(viewModel.artworkDetail.fields) { field in
                        VStack(alignment: .leading, spacing: Spacing.xSmall) {
                            Text(field.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                            Text(field.value)
                                .font(.body)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityElement(children: .combine)
                    }
                }
            }
            .padding(Spacing.large)
        }
        .navigationBarTitleDisplayMode(.inline)
        .baseView(viewModel)
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        ArtworkDetailView(viewModel: .preview)
    }
}
#endif
