import SatelitUI
import UIKit

final class AiringCardViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let cardView = AiringCardView(posterDownloader: KingfisherImageProvider())
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.setShow(DemoAiringShow(
            posterURL: URL(string: "https://bit.ly/2Vn9uJc"),
            title: "Steins;Gate",
            progress: "Ep 1 of 25",
            rating: 9.1,
            trackingStatus: .completed
        ))

        view.backgroundColor = .systemBackground
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.widthAnchor.constraint(equalToConstant: 250),
            cardView.heightAnchor.constraint(equalToConstant: 125),
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - Private types

private struct DemoAiringShow: AiringShow {
    let posterURL: URL?
    let title: String
    let progress: String
    let rating: Float
    let trackingStatus: TrackingStatus
}
