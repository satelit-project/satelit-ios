import SatelitUI
import UIKit

final class RoundedButtonViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let button = RoundedCardButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.text = "Hello"
        button.icon = UIImage(systemName: "heart")

        view.addSubview(button)
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}
