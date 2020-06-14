import UI
import UIKit

class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let items = [
            MenuBarItem(image: UIImage(systemName: "globe")!),
            MenuBarItem(image: UIImage(systemName: "list.bullet.below.rectangle")!),
            MenuBarItem(image: UIImage(systemName: "magnifyingglass")!),
            MenuBarItem(image: UIImage(systemName: "person")!),
        ]

        let menu = MenuBar(items: items)
        menu.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menu)

        NSLayoutConstraint.activate([
            menu.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menu.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        view.backgroundColor = .systemBackground
    }
}
