import CoreGraphics
import Foundation

/// Layout constants used by views in the package.
enum Metrics {
    /// Common constants shared by card-style views.
    enum Card {
        /// Corner radius for top-level cards.
        static let cornerRadius: CGFloat = 10

        /// Offset from card's edges to it's content.
        static let edgeOffset: CGFloat = 12

        /// Offset between items in a card.
        static let innerInterItemOffset: CGFloat = 8

        /// Vertical offset between text views.
        static let verticalNextLineOffset: CGFloat = 2

        /// Horisontal offset between text and non-text view.
        static let horizontalTextNonTextOffset: CGFloat = 4
    }
}
