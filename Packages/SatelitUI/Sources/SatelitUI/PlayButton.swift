import SwiftUI
import UIKit

/// A rounded button with a blur appearance.
public final class PlayButton: UIControl {
    // MARK: Init & deinit

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }

    // MARK: Private methods

    /// Configures self appearance and subviews.
    private func setup() {
        let (blurView, vibrancyView) = makeEffectViews()
        addSubview(blurView)

        let iconView = makeIconView()
        iconView.center = vibrancyView.contentView.center
        vibrancyView.contentView.addSubview(iconView)

        clipsToBounds = true
    }

    // MARK: Factories

    /// Creates and returns blur and vibrancy effect views.
    private func makeEffectViews() -> (blur: UIVisualEffectView, vibrancy: UIVisualEffectView) {
        let blur = UIBlurEffect(style: .systemMaterial)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.frame = bounds
        addSubview(blurView)

        let vibrancy = UIVibrancyEffect(blurEffect: blur, style: .label)
        let vibrancyView = UIVisualEffectView(effect: vibrancy)
        vibrancyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vibrancyView.frame = blurView.contentView.bounds
        blurView.contentView.addSubview(vibrancyView)

        return (blurView, vibrancyView)
    }

    /// Creates and returns an image view with a play symbol.
    private func makeIconView() -> UIImageView {
        let playImageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        let playImage = UIImage(systemName: "play.fill", withConfiguration: playImageConfiguration)!
        let playImageView = UIImageView(image: playImage)
        playImageView.sizeToFit()
        playImageView.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleBottomMargin,
        ]

        return playImageView
    }
}

// MARK: - Previews

#if DEBUG
private final class PlayButtonCompat: UIViewRepresentable {
    func makeUIView(context _: Context) -> some UIView {
        let button = PlayButton(frame: .init(origin: .zero, size: .init(width: 60, height: 60)))
        button.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]

        let container = UIView()
        container.backgroundColor = .systemBackground
        container.addSubview(button)
        button.center = container.center

        return container
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}

struct PlayButtonPreview: PreviewProvider {
    static var previews: some View {
        PlayButtonCompat()
            .edgesIgnoringSafeArea(.all)
            .environment(\.colorScheme, .dark)
    }
}
#endif
