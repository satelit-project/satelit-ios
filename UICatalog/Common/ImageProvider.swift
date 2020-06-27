import UIKit

import Kingfisher
import SatelitUI

final class KingfisherImageProvider: ImageProvider {
    func setImage(from url: URL?, to imageView: UIImageView) {
        imageView.kf.setImage(with: url)
    }
}
