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

/// An object which can download trailer previews and set them to an image view..
public protocol TrailerPreviewDownloader {
    /// Downloads a preview image  from the provided `url` and set's it to the `imageView` or clears it if `url` is `nil`.
    ///
    /// It's expected that the method will be async, will handle image caching and download cancellations in cases
    /// when it's called multiple times for the same image view.
    func setImage(from url: URL?, to imageView: UIImageView)
}

// MARK: - Trailer View

/// A view that displays a single show trailer.
public final class TrailerView: UIView {
    // MARK: Properties

    /// The trailer to display or `nil` to show nothing.
    public var trailer: Trailer? {
        didSet { update(with: trailer) }
    }

    // MARK: Properties

    /// Object that handles trailer's preview images downloads.
    private let previewDownloader: TrailerPreviewDownloader

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

    public init(previewDownloader: TrailerPreviewDownloader) {
        self.previewDownloader = previewDownloader
        super.init(frame: .zero)

        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    /// Configures self appearance and subviews.
    private func setup() {
        let playButton = makePlayButton()
        addSubview(previewView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(playButton)

        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground

        // now layout everything (ｰ ｰ;)
        NSLayoutConstraint.activate([
            previewView.leftAnchor.constraint(equalTo: leftAnchor),
            previewView.topAnchor.constraint(equalTo: topAnchor),
            previewView.rightAnchor.constraint(equalTo: rightAnchor),
            previewView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -12),

            playButton.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: previewView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 60),
            playButton.heightAnchor.constraint(equalToConstant: 60),

            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -2),

            descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
        ])
    }

    /// Updates appearance with the provided `trailer`.
    private func update(with trailer: Trailer?) {
        previewDownloader.setImage(from: trailer?.previewURL, to: previewView)
        titleLabel.text = trailer?.title
        descriptionLabel.text = trailer?.description
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
private final class TrailerViewCompat: UIViewRepresentable {
    struct DemoTrailer: Trailer {
        let previewURL: URL
        let title: String
        let description: String
    }

    final class Downloader: TrailerPreviewDownloader {
        func setImage(from url: URL?, to imageView: UIImageView) {
            guard url != nil else {
                imageView.image = nil
                return
            }

            let renderer = UIGraphicsImageRenderer(size: .init(width: 300, height: 180))
            imageView.image = renderer.image { ctx in
                UIColor.systemRed.setFill()
                ctx.fill(CGRect(x: 0, y: 0, width: 200, height: 190))
                UIColor.systemBlue.setFill()
                ctx.fill(CGRect(x: 100, y: 0, width: 200, height: 190), blendMode: .exclusion)
            }
        }
    }

    private let trailer: DemoTrailer

    init(trailer: DemoTrailer) {
        self.trailer = trailer
    }

    func makeUIView(context _: Context) -> UIView {
        let view = TrailerView(previewDownloader: Downloader())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.trailer = trailer

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

final class TrailerViewPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        let trailer = TrailerViewCompat.DemoTrailer(
            previewURL: URL(string: "https://bit.ly/2B2qC01")!,
            title: "BNA: Brand New Animal",
            description: "TV, 13 Ep, 2020"
        )

        return TrailerViewCompat(trailer: trailer)
            .edgesIgnoringSafeArea(.all)
            .environment(\.colorScheme, .dark)
    }
}
#endif
