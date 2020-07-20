import SwiftUI
import UIKit

/// A trailer that should be displayed.
///
/// - TODO: https://github.com/woltapp/blurhash
public protocol Trailer {
    /// URL of the trailed preview image.
    var previewURL: URL { get }

    /// Title of the show the trailer is featuring.
    var title: String { get }

    /// A short information about the show.
    var description: String { get }
}

// MARK: - Card

/// A view that displays a single show trailer.
public final class TrailerCardView: UIView {
    // MARK: Private properties

    /// Object that handles trailer's preview images downloads.
    private let previewDownloader: ImageProvider

    /// Image view to display trailer's preview image.
    private lazy var previewView: UIImageView = {
        let previewView = UIImageView()
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.contentMode = .scaleAspectFill
        previewView.setContentHuggingPriority(.defaultLow, for: .vertical)
        previewView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return previewView
    }()

    /// Label which displays trailer's title on a single line.
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .label
        return titleLabel
    }()

    /// Label which sits below title label and shows short show's information on a single line.
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = .preferredFont(forTextStyle: .footnote)
        descriptionLabel.textColor = .tertiaryLabel
        return descriptionLabel
    }()

    // MARK: Init & deinit

    public init(previewDownloader: ImageProvider) {
        self.previewDownloader = previewDownloader
        super.init(frame: .zero)

        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    /// Sets `trailer` to display.
    public func setTrailer(_ trailer: Trailer?) {
        previewDownloader.setImage(from: trailer?.previewURL, to: previewView)
        titleLabel.text = trailer?.title
        descriptionLabel.text = trailer?.description
    }

    // MARK: Private methods

    /// Configures self appearance and subviews.
    private func setup() {
        let playButton = makePlayButton()
        addSubview(previewView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(playButton)

        layer.cornerRadius = Metrics.Common.cornerRadius
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground

        // now layout everything (ｰ ｰ;)
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: leadingAnchor),
            previewView.topAnchor.constraint(equalTo: topAnchor),
            previewView.trailingAnchor.constraint(equalTo: trailingAnchor),
            previewView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -Metrics.Common.edgeOffset),

            playButton.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: previewView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 60),
            playButton.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.Common.edgeOffset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metrics.Common.edgeOffset),
            titleLabel.bottomAnchor.constraint(
                equalTo: descriptionLabel.topAnchor,
                constant: -Metrics.Common.verticalNextLineOffset
            ),

            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.Common.edgeOffset),
        ])
    }

    // MARK: Factories

    /// Returns a play button to show under the preview image.
    private func makePlayButton() -> PlayButton {
        let button = PlayButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

// MARK: - Previews

#if DEBUG
private final class TrailerCardCompat: UIViewRepresentable {
    struct DemoTrailer: Trailer {
        let previewURL: URL
        let title: String
        let description: String
    }

    private let trailer: DemoTrailer

    init(trailer: DemoTrailer) {
        self.trailer = trailer
    }

    func makeUIView(context _: Context) -> UIView {
        let view = TrailerCardView(previewDownloader: PreviewsImageProvider(imageSize: .init(width: 300, height: 180)))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTrailer(trailer)

        let container = UIView()
        container.backgroundColor = .systemBackground
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.addSubview(view)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        return container
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}

final class TrailerCardPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        let trailer = TrailerCardCompat.DemoTrailer(
            previewURL: URL(string: "https://bit.ly/2B2qC01")!,
            title: "BNA: Brand New Animal",
            description: "TV, 13 Ep, 2020"
        )

        return TrailerCardCompat(trailer: trailer)
            .edgesIgnoringSafeArea(.all)
            .environment(\.colorScheme, .dark)
    }
}
#endif
