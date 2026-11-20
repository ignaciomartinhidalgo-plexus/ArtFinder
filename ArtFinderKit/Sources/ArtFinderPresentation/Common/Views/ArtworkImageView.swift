//
//  ArtworkImageView.swift
//  ArtFinderKit
//

import SwiftUI
import UIKit

struct ArtworkImageView: View {

    // MARK: - Phase

    private enum Phase {
        case loading
        case loaded(UIImage)
        case failed
    }

    // MARK: - Properties

    let url: URL?
    let contentMode: ContentMode

    @Environment(\.imageLoader) private var imageLoader
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var phase: Phase = .loading

    // MARK: - Body

    var body: some View {
        content
            .task(id: url) {
                await loadImage()
            }
    }

    @ViewBuilder
    private var content: some View {
        switch phase {
        case .loaded(let image):
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        case .loading:
            placeholder(systemImage: nil)
        case .failed:
            placeholder(systemImage: "photo")
        }
    }

    // MARK: - Private functions

    private func loadImage() async {
        guard let url, let imageLoader else {
            phase = .failed
            return
        }

        phase = .loading
        do {
            let data = try await imageLoader.loadImageData(from: url)
            guard let image = UIImage(data: data) else {
                phase = .failed
                return
            }
            withAnimation(reduceMotion ? nil : .easeInOut) {
                phase = .loaded(image)
            }
        } catch is CancellationError {
            // The view disappeared or its URL changed: `.task(id:)` cancelled this load.
        } catch {
            phase = .failed
        }
    }

    @ViewBuilder
    private func placeholder(systemImage: String?) -> some View {
        ZStack {
            Rectangle()
                .fill(.quaternary)
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.title2)
                    .foregroundStyle(.secondary)
            } else {
                ProgressView()
            }
        }
    }
}
