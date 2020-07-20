import SwiftUI
import UIKit

/// Airing anime that can be displayed on an airing show card.
public protocol AiringShow {
    /// URL of the show's poster.
    var posterURL: URL? { get }

    /// Show's title.
    var title: String { get }

    /// How much episodes has aired.
    var progress: String { get }

    /// Show's rating.
    var rating: Float { get }

    /// Tracking status of the show in user's library.
    var trackingStatus: TrackingStatus { get }
}

/// A card that shows details about an ongoing anime.
public final class AiringCardView: UIView {
    // MARK: Private properties

    /// An object to download show's poster.
    private let posterDownloader: ImageProvider

    /// Rounded poster image view.
    private lazy var posterView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = Metrics.Common.cornerRadius / 2
        view.contentMode = .scaleAspectFill
        return view
    }()

    /// Show's title label.
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()

    /// A view to show airing progress and tracking status.
    private lazy var progressView: ShowProgressView = {
        let view = ShowProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    /// A view to display show's rating.
    private lazy var ratingView: ShowRatingView = {
        let view = ShowRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: Init & deinit

    /// Initializes new instance with the provided `posterDownloader`.
    public init(posterDownloader: ImageProvider) {
        self.posterDownloader = posterDownloader
        super.init(frame: .zero)

        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    /// Set's a `show` do display.
    public func setShow(_ show: AiringShow) {
        posterDownloader.setImage(from: show.posterURL, to: posterView)
        titleLabel.text = show.title
        progressView.setProgress(show.progress, trackingStatus: show.trackingStatus)
        ratingView.setRating(show.rating)
    }

    // MARK: Private methods

    /// Configures self and subviews.
    private func setup() {
        addSubview(posterView)
        addSubview(titleLabel)
        addSubview(progressView)
        addSubview(ratingView)

        layer.cornerRadius = Metrics.Common.cornerRadius
        backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metrics.Common.edgeOffset),
            posterView.topAnchor.constraint(equalTo: topAnchor, constant: Metrics.Common.edgeOffset),
            posterView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Metrics.Common.edgeOffset),
            posterView.trailingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor,
                constant: -Metrics.Common.innerInterItemOffset
            ),
            posterView.widthAnchor.constraint(equalToConstant: 70),

            titleLabel.topAnchor.constraint(equalTo: posterView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Common.edgeOffset),

            progressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Common.edgeOffset),
            progressView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Metrics.Common.verticalNextLineOffset
            ),

            ratingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Metrics.Common.edgeOffset),
            ratingView.bottomAnchor.constraint(equalTo: posterView.bottomAnchor),
        ])
    }
}

// MARK: - Private types

/// A view that shows anime airing progress and tracking status.
private final class ShowProgressView: UIView {
    // MARK: Private properties

    /// A label to show airing progress.
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        return label
    }()

    /// A view (dot) that indicates if the show is tracked in user's library.
    private lazy var trackingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true

        let size: CGFloat = 5
        view.layer.cornerRadius = size / 2
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: size),
            view.heightAnchor.constraint(equalToConstant: size),
        ])

        return view
    }()

    // MARK: Init & deinit

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    /// Shows provided airing `progress` and `trackingStatus` in user's library.
    func setProgress(_ progress: String, trackingStatus: TrackingStatus?) {
        progressLabel.text = progress
        trackingView.isHidden = trackingStatus == nil
        trackingView.backgroundColor = trackingStatus?.color
    }

    // MARK: Private methods

    /// Configures self and subviews.
    private func setup() {
        addSubview(progressLabel)
        addSubview(trackingView)

        NSLayoutConstraint.activate([
            progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressLabel.topAnchor.constraint(equalTo: topAnchor),
            progressLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            trackingView.leadingAnchor.constraint(
                equalTo: progressLabel.trailingAnchor,
                constant: Metrics.Common.horizontalTextImageOffset
            ),
            trackingView.centerYAnchor.constraint(equalTo: progressLabel.centerYAnchor),
            trackingView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
        ])
    }
}

/// A view that displays show's rating.
private final class ShowRatingView: UIView {
    // MARK: Private properties

    /// A label to show anime's rating.
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .tertiaryLabel
        label.textAlignment = .right

        let font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.font = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: font)

        return label
    }()

    /// The "star" symbol on the leading side of the rating label.
    private lazy var starView: UIView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredSymbolConfiguration = .init(font: self.ratingLabel.font)
        view.image = UIImage(systemName: "star.fill")
        view.tintColor = self.ratingLabel.textColor
        return view
    }()

    // MARK: Init & deinit

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Public methods

    /// Shows the provided `rating` with two-digit percision.
    func setRating(_ rating: Float) {
        ratingLabel.text = String(format: "%.2f", rating)
    }

    // MARK: Private methods

    /// Configures self and subviews.
    private func setup() {
        addSubview(starView)
        addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            starView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starView.trailingAnchor.constraint(
                equalTo: ratingLabel.leadingAnchor,
                constant: -Metrics.Common.horizontalTextImageOffset
            ),
            starView.firstBaselineAnchor.constraint(equalTo: ratingLabel.firstBaselineAnchor),

            ratingLabel.topAnchor.constraint(equalTo: topAnchor),
            ratingLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

// MARK: - Previews

#if DEBUG
private final class AiringCardViewCompat: UIViewRepresentable {
    private struct DemoAiringShow: AiringShow {
        var posterURL: URL? { URL(string: "google.com")! }
        var title: String { "Steins;Gate" }
        var progress: String { "Ep 1 of 25" }
        var rating: Float { 9.1 }
        var trackingStatus: TrackingStatus { .completed }
    }

    func makeUIView(context _: Context) -> some UIView {
        let card = AiringCardView(posterDownloader: PreviewsImageProvider(imageSize: .init(width: 70, height: 100)))
        card.translatesAutoresizingMaskIntoConstraints = false
        card.setShow(DemoAiringShow())

        let container = UIView()
        container.backgroundColor = .systemBackground
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.addSubview(card)

        NSLayoutConstraint.activate([
            card.widthAnchor.constraint(equalToConstant: 250),
            card.heightAnchor.constraint(equalToConstant: 125),
            card.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        return container
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}

struct AiringCardViewPreview: PreviewProvider {
    static var previews: some View {
        AiringCardViewCompat()
            .edgesIgnoringSafeArea(.all)
            .environment(\.colorScheme, .dark)
    }
}
#endif
