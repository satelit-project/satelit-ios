import UIKit

#if DEBUG
/// Image provider that generates images instead of downloading them from URL.
struct PreviewsImageProvider: ImageProvider {
    // MARK: Properties

    /// Size of the image to draw to.
    let imageSize: CGSize

    func setImage(from url: URL?, to imageView: UIImageView) {
        guard url != nil else {
            imageView.image = nil
            return
        }

        let renderer = UIGraphicsImageRenderer(size: imageSize)
        imageView.image = renderer.image { ctx in
            let firstWidth = imageSize.width * 0.66
            let secondX = imageSize.width - firstWidth

            UIColor.systemRed.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: firstWidth, height: imageSize.height))
            UIColor.systemBlue.setFill()
            ctx.fill(CGRect(x: secondX, y: 0, width: firstWidth, height: imageSize.height), blendMode: .exclusion)
        }
    }
}
#endif
