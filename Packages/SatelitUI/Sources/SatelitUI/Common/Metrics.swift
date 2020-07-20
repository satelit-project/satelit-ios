import CoreGraphics
import Foundation

/// Layout constants used by views in the package.
enum Metrics {
    /// Common constants shared by most views.
    enum Common {
        /// Corner radius for top-level view.
        static let cornerRadius: CGFloat = 10

        /// Offset from view's edges to it's content.
        static let edgeOffset: CGFloat = 12

        /// Offset between items in a view.
        static let innerInterItemOffset: CGFloat = 8

        /// Vertical offset between text views.
        static let verticalNextLineOffset: CGFloat = 2

        /// Horisontal offset between text and image view.
        static let horizontalTextImageOffset: CGFloat = 4
    }
}
