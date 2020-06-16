import SwiftUI
import UIKit

/// A single menu item.
public final class MenuBarItem {
    /// Image of the item.
    fileprivate let image: UIImage

    /// Closure to call when the item was selected.
    fileprivate let onSelect: (() -> Void)?

    /// Closure to call when the item was deselected.
    fileprivate let onDeselect: (() -> Void)?

    /// Tint color to use when the item is selected.
    fileprivate var selectedColor: UIColor {
        UIColor { traits in
            if traits.userInterfaceStyle == .dark {
                return .white
            }

            // TODO: change color for the light scheme
            return .red
        }
    }

    /// Tint color to use when the item is deselected.
    fileprivate var deselectedColor: UIColor {
        UIColor { traits in
            if traits.userInterfaceStyle == .dark {
                return .systemGray2
            }

            // TODO: change color for the light scheme
            return .green
        }
    }

    /// Creates a new menu item to show in a menu bar.
    /// - Parameters:
    ///   - image: Image of the item that will be visible on a menu bar.
    ///   - onSelect: Closure to call on the item selection.
    ///   - onDeselect: Closure to call on the item deselection.
    public init(image: UIImage, onSelect: (() -> Void)? = nil, onDeselect: (() -> Void)? = nil) {
        self.image = image
        self.onSelect = onSelect
        self.onDeselect = onDeselect
    }
}

/// Floating menu meant to be used for navigation between app's screens.
public final class MenuBar: UIView {
    // MARK: Private properties

    /// Offset between menu items.
    private let verticalSpacing: CGFloat = 40

    /// Offset between menu items and top/bottom edges of the menu bar.
    private let horizontalSpacing: CGFloat = 15

    /// Menu item views managed by the menu.
    private var itemViews = [MenuBarItemView]()

    /// Currently selected menu item view.
    private var selectedItemView: MenuBarItemView?

    // MARK: Init & deinit

    /// Creates new menu with the provided menu items.
    /// - Parameter items: Menu items to display in the new menu.
    public init(items: [MenuBarItem] = []) {
        super.init(frame: .zero)
        setup(with: items)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override public func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = min(bounds.width, bounds.height) / 2
        layer.cornerRadius = cornerRadius
    }

    // MARK: Methods

    /// Selects menu item at `index` and deselects previously selected item.
    ///
    /// Setting `nil` deselects currently selected item.
    public func selectItem(at index: Int?) {
        selectItemView(index.map({ itemViews[$0] }))
    }

    // MARK: Configuration

    /// Performs initial view configuration.
    ///
    /// The method will create and setup the menu and all of it's corresponding views, as well as
    /// will perform configuration for user interaction.
    private func setup(with items: [MenuBarItem]) {
        let (menuView, itemViews) = makeMenu(with: items)
        addSubview(menuView)
        menuView.frame = bounds
        menuView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        clipsToBounds = true
        layer.cornerCurve = .continuous

        self.itemViews = itemViews
        setupTouches()
    }

    /// Installs required gesture recognizers to all menu item views.
    private func setupTouches() {
        for view in itemViews {
            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapMenuItem))
            view.isUserInteractionEnabled = true
            view.addGestureRecognizer(tap)
        }
    }

    // MARK: Touches

    /// Handles a tap gesture on a menu item view and calls item's callbacks.
    @objc
    private func didTapMenuItem(_ tap: UITapGestureRecognizer) {
        selectItemView(tap.view as? MenuBarItemView)
    }

    /// Marks provided `itemView` as selected and calls item's callbacks.
    private func selectItemView(_ itemView: MenuBarItemView?) {
        if let view = selectedItemView {
            view.setSelected(false)
            selectedItemView = nil
        }

        if let view = itemView {
            view.setSelected(true)
            selectedItemView = view
        }
    }

    // MARK: Factories

    /// Creates and returns menu view.
    private func makeMenu(with items: [MenuBarItem]) -> (UIView, [MenuBarItemView]) {
        let blur = UIBlurEffect(style: .systemChromeMaterial)
        let blurView = UIVisualEffectView(effect: blur)

        let itemViews = makeItemViews(for: items)
        let contentView = makeItemsContainer(for: itemViews)

        blurView.contentView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: blurView.contentView.leftAnchor, constant: verticalSpacing),
            contentView.topAnchor.constraint(equalTo: blurView.contentView.topAnchor, constant: horizontalSpacing),
            contentView.rightAnchor.constraint(equalTo: blurView.contentView.rightAnchor, constant: -verticalSpacing),
            contentView.bottomAnchor.constraint(
                equalTo: blurView.contentView.bottomAnchor,
                constant: -horizontalSpacing
            ),
        ])

        return (blurView, itemViews)
    }

    /// Creates and returns a list of views where each view corresponds to menu item.
    private func makeItemViews(for items: [MenuBarItem]) -> [MenuBarItemView] {
        var itemViews = [MenuBarItemView]()
        itemViews.reserveCapacity(items.count)
        for item in items {
            let view = MenuBarItemView(item: item)
            view.translatesAutoresizingMaskIntoConstraints = false
            itemViews.append(view)
        }

        return itemViews
    }

    /// Creates and returns a container view for the list of menu item views.
    private func makeItemsContainer(for itemViews: [MenuBarItemView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: itemViews)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = verticalSpacing

        return stack
    }
}

// MARK: Private types

/// A single menu bar item.
private final class MenuBarItemView: UIImageView {
    /// A menu item managed by the view.
    private let item: MenuBarItem

    /// Creates the view with the provided `item`.
    init(item: MenuBarItem) {
        self.item = item
        super.init(frame: .zero)

        image = item.image.withRenderingMode(.alwaysTemplate)
        preferredSymbolConfiguration = .init(pointSize: 24, weight: .semibold)
        setSelected(false, silent: true)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Selects or deselects managed menu item and call's item's callbacks.
    /// - Parameters:
    ///   - isSelected: Pass `true` to make the item selected or `false` to make it deselected.
    func setSelected(_ isSelected: Bool) {
        setSelected(isSelected, silent: false)
    }

    /// Selects or deselects managed menu item.
    /// - Parameters:
    ///   - isSelected: Pass `true` to make the item selected or `false` to make it deselected.
    ///   - silent: Pass `false` to call item's callbacks or `true` to skip them.
    private func setSelected(_ isSelected: Bool, silent: Bool) {
        tintColor = isSelected ? item.selectedColor : item.deselectedColor

        if !silent {
            isSelected ? item.onSelect?() : item.onDeselect?()
        }
    }
}

// MARK: - Previews

#if DEBUG
    private final class MenuBarCompat: UIViewRepresentable {
        func updateUIView(_: UIView, context _: Context) {}

        func makeUIView(context _: Context) -> UIView {
            let items = [
                MenuBarItem(image: UIImage(systemName: "globe")!),
                MenuBarItem(image: UIImage(systemName: "list.bullet.below.rectangle")!),
                MenuBarItem(image: UIImage(systemName: "magnifyingglass")!),
                MenuBarItem(image: UIImage(systemName: "person")!),
            ]

            let menu = MenuBar(items: items)
            menu.translatesAutoresizingMaskIntoConstraints = false

            let container = UIView()
            container.backgroundColor = .systemBackground
            container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            container.addSubview(menu)

            NSLayoutConstraint.activate([
                menu.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                menu.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            ])

            return container
        }
    }

    struct RoundedTabBarPreview: PreviewProvider {
        static var previews: some View {
            MenuBarCompat()
                .environment(\.colorScheme, .dark)
                .edgesIgnoringSafeArea(.all)
        }
    }
#endif
