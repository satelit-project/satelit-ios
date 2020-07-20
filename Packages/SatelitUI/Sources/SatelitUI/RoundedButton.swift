import SwiftUI
import UIKit

public final class RoundedButton: UIControl {
    public var icon: UIImage? {
        get { contentView.icon }
        set { contentView.icon = newValue }
    }

    public var text: String? {
        get { contentView.text }
        set { contentView.text = newValue }
    }

    private lazy var backgrounView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemUltraThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentView: RoundedButtonContentView = {
        let view = RoundedButtonContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }

    private func setup() {
        layer.cornerRadius = Metrics.Common.cornerRadius
        layer.cornerCurve = .continuous
        layer.masksToBounds = true

        addSubview(backgrounView)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            backgrounView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgrounView.topAnchor.constraint(equalTo: topAnchor),
            backgrounView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgrounView.bottomAnchor.constraint(equalTo: bottomAnchor),

            leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -Metrics.Common.edgeOffset),
            topAnchor.constraint(equalTo: contentView.topAnchor, constant: -Metrics.Common.edgeOffset),
            trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metrics.Common.edgeOffset),
            bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metrics.Common.edgeOffset),
        ])
    }
    
    private func update(for state: State) {
        // TODO
    }
}

private final class RoundedButtonContentView: UIView {
    var icon: UIImage? {
        get { iconView.image }
        set {
            iconView.image = newValue?.withRenderingMode(.alwaysTemplate)
            iconView.isHidden = newValue == nil
        }
    }

    var text: String? {
        get { textLabel.text }
        set {
            textLabel.text = newValue
            textLabel.isHidden = newValue?.isEmpty ?? true
        }
    }

    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredSymbolConfiguration = .init(font: textLabel.font)
        view.isHidden = true
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.isHidden = true
        label.setContentHuggingPriority(.defaultHigh - 1, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        iconView.tintColor = tintColor
        textLabel.textColor = tintColor
    }

    private func setup() {
        let stack = UIStackView(arrangedSubviews: [iconView, textLabel])
        stack.axis = .horizontal
        stack.spacing = Metrics.Common.horizontalTextImageOffset
        stack.alignment = .firstBaseline
        stack.distribution = .fill

        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - Previews

#if DEBUG
private final class RoundedButtonCompat: UIViewRepresentable {
    func makeUIView(context _: Context) -> UIView {
        let button = RoundedButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.text = "1"
        button.icon = UIImage(systemName: "heart")

        let container = UIView()
        container.backgroundColor = .systemBackground
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        return container
    }

    func updateUIView(_: UIViewType, context _: Context) {}
}

final class RoundedButtonPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        RoundedButtonCompat()
            .edgesIgnoringSafeArea(.all)
            .environment(\.colorScheme, .dark)
    }
}
#endif
