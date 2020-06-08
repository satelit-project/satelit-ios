import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.
        true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _: UIApplication,
        configurationForConnecting _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        let configuration = UISceneConfiguration(name: nil, sessionRole: .windowApplication)
        configuration.sceneClass = UIWindowScene.self
        configuration.delegateClass = SceneDelegate.self

        return configuration
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
