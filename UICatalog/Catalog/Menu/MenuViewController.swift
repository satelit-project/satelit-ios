import UI
import UIKit

class MenuViewController: MenuBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        for controller in controllers {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .systemBackground
            view.alpha = 0.5

            controller.view.addSubview(view)
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor),
                view.leftAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.leftAnchor),
                view.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor),
                view.rightAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.rightAnchor),
            ])
        }

       setControllers(controllers, images: images)
    }
}
