import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {
    var window: UIWindow?

    func scene(_: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let window = window else { return }
        guard let splitViewController = window.rootViewController as? UISplitViewController else { return }
        guard let navigationController = splitViewController.viewControllers.last as? UINavigationController
        else { return }
        navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController
            .displayModeButtonItem
        navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
    }
}
