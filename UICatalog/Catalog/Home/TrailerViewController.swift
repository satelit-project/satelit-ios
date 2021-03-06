import SatelitUI
import UIKit

final class TrailerViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let trailerView = TrailerCardView(previewDownloader: KingfisherImageProvider())
        trailerView.translatesAutoresizingMaskIntoConstraints = false
        trailerView.setTrailer(DemoTrailer(
            previewURL: URL(string: "https://bit.ly/2B2qC01")!,
            title: "BNA: Brand New Animal",
            description: "TV, 13 Ep, 2020"
        ))

        view.backgroundColor = .systemBackground
        view.addSubview(trailerView)
        NSLayoutConstraint.activate([
            trailerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trailerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

// MARK: - Private types

private struct DemoTrailer: Trailer {
    let previewURL: URL
    let title: String
    let description: String
}
