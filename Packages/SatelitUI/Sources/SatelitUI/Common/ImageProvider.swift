import UIKit

/// An object which can download remote images and set them to an image view..
public protocol ImageProvider {
    /// Downloads an image from the provided `url` and set's it to the `imageView` or clears it if `url` is `nil`.
    ///
    /// It's expected that the method will be async, will handle image caching and download cancellations in cases
    /// when it's called multiple times for the same image view.
    func setImage(from url: URL?, to imageView: UIImageView)
}
