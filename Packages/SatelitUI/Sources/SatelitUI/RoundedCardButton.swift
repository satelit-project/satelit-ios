import SwiftUI
import UIKit

/// A rounded button to represent actions in cards.
public final class RoundedCardButton: UIControl {
    // MARK: Public properties

    /// An icon to show at the leading edge of the button.
    public var icon: UIImage? {
        get { contentView.icon }
        set { contentView.icon = newValue }
    }

    /// A text to display on the trailing edge of the button.
    public var text: String? {
        get { contentView.text }
        set { contentView.text = newValue }
    }

    // MARK: Private properties

    /// Background view which holds button's content.
    private lazy var backgrounView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    /// Button's content view which holds other views like image and text views.
    private lazy var contentView: ContentView = {
        let view = ContentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    /// Custom tint color configuration for different button's state.
    private var tintColors = [HashableState: UIColor]()

    /// Custom background color configuration for differtent button's state.
    private var backgroundColors = [HashableState: UIColor]()

    /// Contains KVO lifetime wrappers.
    private var observers = Set<NSKeyValueObservation>()

    // MARK: Init & deinit

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }

    // MARK: Public methods

    /// Sets custom button's tint color for the `state`.
    public func setTintColor(_ color: UIColor, for state: State) {
        let wrapped = HashableState(state: state)
        tintColors[wrapped] = color

        if self.state == state {
            update(for: state)
        }
    }

    /// Sets custom button's background color for the `state`.
    public func setBackgroundColor(_ color: UIColor, for state: State) {
        let wrapped = HashableState(state: state)
        backgroundColors[wrapped] = color

        if self.state == state {
            update(for: state)
        }
    }

    // MARK: Private methods

    /// Configures itself and subviews.
    private func setup() {
        layer.cornerRadius = Metrics.Common.cornerRadius
        layer.cornerCurve = .continuous
        layer.masksToBounds = true

        addSubview(backgrounView)
        backgrounView.contentView.addSubview(contentView)

        NSLayoutConstraint.activate([
            backgrounView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgrounView.topAnchor.constraint(equalTo: topAnchor),
            backgrounView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgrounView.bottomAnchor.constraint(equalTo: bottomAnchor),

            backgrounView.contentView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: -Metrics.Common.edgeOffset
            ),
            backgrounView.contentView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: -Metrics.Common.edgeOffset
            ),
            backgrounView.contentView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: Metrics.Common.edgeOffset
            ),
            backgrounView.contentView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: Metrics.Common.edgeOffset
            ),
        ])

        observeState()
        update(for: state)
    }

    /// Starts observing control state of self.
    private func observeState() {
        let observation = { (me: RoundedCardButton, _: NSKeyValueObservedChange<Bool>) in
            me.update(for: me.state)
        }

        observers.insert(observe(\.isHighlighted, changeHandler: observation))
        observers.insert(observe(\.isSelected, changeHandler: observation))
    }

    /// Updates appearance for the `state`.
    private func update(for state: State) {
        let wrapped = HashableState(state: state)
        let normal = HashableState(state: .normal)

        tintColor = tintColors[wrapped] ?? tintColors[normal]
        backgroundColor = backgroundColors[wrapped] ?? backgroundColors[normal]
    }
}

// MARK: - Private types

/// A view which holds all views for the `RoundedCardButton`.
///
/// The view reacts to `tintColor` changes and will update it's appearance to match it.
private final class ContentView: UIView {
    // MARK: Properties

    /// An icon to show at the leading edge of the view.
    var icon: UIImage? {
        get { iconView.image }
        set {
            iconView.image = newValue?.withRenderingMode(.alwaysTemplate)
            iconView.isHidden = newValue == nil
        }
    }

    /// A text to display on the trailing edge of the view.
    var text: String? {
        get { textLabel.text }
        set {
            textLabel.text = newValue
            textLabel.isHidden = newValue?.isEmpty ?? true
        }
    }

    // MARK: Private properties

    /// Image view to display an icon on the leading edge.
    private lazy var iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.preferredSymbolConfiguration = .init(font: textLabel.font)
        view.isHidden = true
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return view
    }()

    /// Label to display text on the trailing edge.
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.isHidden = true
        label.setContentHuggingPriority(.defaultHigh - 1, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        return label
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

    // MARK: Lifecycle

    override func tintColorDidChange() {
        super.tintColorDidChange()
        iconView.tintColor = tintColor
        textLabel.textColor = tintColor
    }

    // MARK: Private methods

    /// Configures seld and subviews.
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

/// A wrapper around `UIControl.State` to make it `Hashable`.
private struct HashableState {
    let state: UIControl.State
}

extension HashableState: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.state == rhs.state
    }
}

extension HashableState: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(state.rawValue)
    }
}

// MARK: - Previews

#if DEBUG
private final class RoundedCardButtonCompat: UIViewRepresentable {
    private let state: UIControl.State

    init(state: UIControl.State) {
        self.state = state
    }

    func makeUIView(context _: Context) -> UIView {
        let button = RoundedCardButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.text = "1"
        button.icon = UIImage(systemName: "heart")

        button.setTintColor(.systemGray, for: .normal)
        button.setTintColor(.systemRed, for: .selected)
        button.setBackgroundColor(.systemGray6, for: .highlighted)

        button.isSelected = state.contains(.selected)
        button.isHighlighted = state.contains(.highlighted)

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

final class RoundedCardButtonPreview: PreviewProvider {
    static var previews: some SwiftUI.View {
        RoundedCardButtonCompat(state: .normal)
            .previewLayout(.fixed(width: 100, height: 100))
            .environment(\.colorScheme, .dark)

        RoundedCardButtonCompat(state: .selected)
            .previewLayout(.fixed(width: 100, height: 100))
            .environment(\.colorScheme, .dark)

        RoundedCardButtonCompat(state: .highlighted)
            .previewLayout(.fixed(width: 100, height: 100))
            .environment(\.colorScheme, .dark)
    }
}
#endif
