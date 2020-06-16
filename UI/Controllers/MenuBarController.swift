//
//  MenuBarController.swift
//  UI
//
//  Created by rbbtnspc on 16/6/20.
//  Copyright © 2020 Shitty Moe. All rights reserved.
//

import UIKit
import SwiftUI

/// A container controller that manages a menu-style selection interface, where the selection determines which child controller to display.
open class MenuBarController: UIViewController {
    // MARK: Private properties
    
    /// All managed child controllers that can be displayed.
    private var controllers = [UIViewController]()
    
    /// An index of the currently selected child controller.
    private var selectedIndex: Int?
    
    /// A view which manages layout of the menu and hosts child controller's views.
    private var containerView: MenuBarContainerView?
    
    /// Menu bar view manager by the container view.
    private var menu: MenuBar?
    
    // MARK: Public methods
    
    /// Sets root controllers of the menu bar controller.
    ///
    /// Each root controller must have a corresponing `UIImage` object to display on the menu. The number of images
    /// must be equal to the number of root controllers.
    /// - Parameters:
    ///   - controllers: Array of root controller to manage.
    ///   - images: Array of corresponding controllers images.
    public func setControllers(_ controllers: [UIViewController], images: [UIImage]) {
        precondition(controllers.count == images.count, "number of controllers must be equal to number of images")

        menu?.selectItem(at: nil)
        self.controllers = controllers
        setMenu(with: images)
        
        if controllers.count > 0 {
            menu?.selectItem(at: 0)
        }
    }
    
    // MARK: Private methods

    /// Sets a controller at the `index` as the curret active controller.
    ///
    /// The method will add controller's view to a hosting container view and add the controller as the single child
    /// of the menu controller. Before using the method you must remove previously hosted controller by calling the
    /// `unsetController(at:)` method.
    private func setController(at index: Int) {
        let controller = controllers[index]
        addChild(controller)
        
        controller.view.frame = containerView?.bounds ?? .zero
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(controller.view)
        containerView?.addSubview(controller.view)

        controller.didMove(toParent: self)
    }
    
    /// Removes child controller at the `index`.
    ///
    /// The method will remove the controller from it's child controllers and will also remove it's view
    /// from the hosting container view.
    private func unsetController(at index: Int) {
        let controller = controllers[index]
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
    }
    
    /// Creates and activates new menu with specified `images` to be used as the menu items.
    ///
    /// The method will remove previously active menu and it's container view and instantiate a new ones.
    /// Before calling the method you need to remove any views hosted by the container and also the corresponding
    /// child controller by calling `unsetController(at:)`.
    ///
    /// In addition to that, this method will set neccessary callbacks that informs about safe area changes and which
    /// will modify menu controller's `additionalSafeAreaInsets` so child controllers can use container view's
    /// `safeAreaLayoutGuide` to avoid overlapping with the menu bar.
    private func setMenu(with images: [UIImage]) {
        containerView?.onAdditionalSafeAreaInsetsChanged = nil
        containerView?.removeFromSuperview()
        
        let newMenu = makeMenu(with: images)
        let newContainerView = MenuBarContainerView(menu: newMenu)
        newContainerView.frame = view.bounds
        newContainerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(newContainerView)
        
        newContainerView.onAdditionalSafeAreaInsetsChanged = { [weak self] insets in
            self?.additionalSafeAreaInsets = insets
        }

        menu = newMenu
        containerView = newContainerView
    }
    
    // MARK: Factories
    
    /// Creates new menu instance with items created from the provided `images`.
    /// - Parameter images: Array of images to use for menu's items.
    /// - Returns: Newly created menu bar.
    private func makeMenu(with images: [UIImage]) -> MenuBar {
        let items = images.enumerated().map { index, image in
            MenuBarItem(
                image: image,
                onSelect: { [weak self] in
                    self?.selectedIndex = index
                    self?.setController(at: index)
                }, onDeselect: { [weak self] in
                    self?.unsetController(at: index)
                    self?.selectedIndex = nil
                }
            )
        }

        return MenuBar(items: items)
    }
}

// MARK: - Private types

/// A view that hosts menu bar and views for child view controllers.
private final class MenuBarContainerView: UIView {
    // MARK: Public properties
    
    /// A closure to call when view's additional safe area insets changes.
    ///
    /// The provided insets are meant to be set to controller's `additionalSafeAreaInsets` to adjust safe area
    /// of it's views so they can avoid overlapping with the menu bar.
    var onAdditionalSafeAreaInsetsChanged: ((UIEdgeInsets) -> Void)?
    
    // MARK: Private properties
    
    /// Hosted menu bar.
    private let menu: MenuBar
    
    /// Offset from the top anchor of the menu bar to the bottom anchor of the adjusted safe area.
    private let topOffset: CGFloat
    
    /// Minimum offset from the bottom anchor of the view to the top anchor of the menu bar.
    ///
    /// The offset will be used in case if there's no safe area for the view or it's smaller than the offset.
    private let bottomOffset: CGFloat
    
    /// View's bounds at the previous layout cycle.
    private var lastBounds: CGRect = .zero
    
    /// Constraint from the bottom anchor of the menu bar to the bottom anchor of the view.
    private var bottomConstraint: NSLayoutConstraint?
    
    // MARK: Init & deinit
    
    /// Creates new instance of the view.
    /// - Parameters:
    ///   - menu: Menu bar to host.
    ///   - topOffset: Offset from the top of the menu to the bottom of the adjusted safe area.
    ///   - bottomOffset: Offset from the bottom of the view to the bottom of the menu bar.
    init(menu: MenuBar, topOffset: CGFloat = 16, bottomOffset: CGFloat = 16) {
        self.menu = menu
        self.topOffset = topOffset
        self.bottomOffset = bottomOffset
        super.init(frame: .zero)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        
        // menu bar should always be on top of the view hierarchy
        bringSubviewToFront(menu)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // calculate additional safe area insets to make it non-overlapping with the menu bar
        if bounds != lastBounds {
            let obscuredHeight = bounds.height - menu.frame.maxY + menu.bounds.height - realBottomSafeAreaInset()
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: obscuredHeight + topOffset, right: 0)
            onAdditionalSafeAreaInsetsChanged?(insets)
        }
        
        lastBounds = bounds
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        bottomConstraint?.constant = safeBottomOffset()
    }
    
    // MARK: Private methods
    
    /// Sets up menu bar.
    private func setup() {
        menu.translatesAutoresizingMaskIntoConstraints = false
        addSubview(menu)
        
        menu.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bottomConstraint = menu.bottomAnchor.constraint(equalTo: bottomAnchor, constant: safeBottomOffset())
        bottomConstraint?.isActive = true
    }
    
    /// Calculates bottom menu bar offset.
    ///
    /// Returned offset is either the `bottomOffset` or the value of the bottom safe area's inset depending which
    /// is greater. Safe area of the view's window is used to simulate behaviour of the real `UITabBarController`.
    private func safeBottomOffset() -> CGFloat {
        return -max(realBottomSafeAreaInset(), bottomOffset)
    }
    
    /// Calculates view's bottom safe area inset relative to it's window.
    ///
    /// View window's safe area is used so the view is not affected by it's controller's `additionalSafeAreaInsets`.
    private func realBottomSafeAreaInset() -> CGFloat {
        guard let window = window else { return 0 }
        guard let superview = superview else { return 0 }
        
        let windowBounds = window.bounds
        let myFrame = window.convert(frame, from: superview)
        
        let myBottomOffset = windowBounds.height - myFrame.maxY
        let bottomSafeInset = window.safeAreaInsets.bottom
        
        return max(0, bottomSafeInset - myBottomOffset)
    }
}

// MARK: - Previews

#if DEBUG
private final class MenuBarControllerCompat: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: MenuBarController, context: Context) {}
    
    func makeUIViewController(context: Context) -> MenuBarController {
        let images = [
            UIImage(systemName: "globe")!,
            UIImage(systemName: "list.bullet.below.rectangle")!,
            UIImage(systemName: "magnifyingglass")!,
            UIImage(systemName: "person")!,
        ]
        
        let controllers: [UIViewController] = [
            {
                let controller = UIViewController()
                controller.view.backgroundColor = .systemRed
                return controller
            }(),
            {
                let controller = UIViewController()
                controller.view.backgroundColor = .systemBlue
                return controller
            }(),
            {
                let controller = UIViewController()
                controller.view.backgroundColor = .systemPink
                return controller
            }(),
            {
                let controller = UIViewController()
                controller.view.backgroundColor = .systemTeal
                return controller
            }(),
        ]
        
        let controller = MenuBarController()
        controller.setControllers(controllers, images: images)
        return controller
    }
}

final class MenuBarControllerPreview: PreviewProvider {
    static var previews: some View {
        return MenuBarControllerCompat()
            .edgesIgnoringSafeArea(.all)
    }
}
#endif
