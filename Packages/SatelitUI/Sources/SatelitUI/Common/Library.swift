import UIKit

/// Tracking status of a show in user's library.
public enum TrackingStatus {
    /// The show is not being tracked.
    case untracked

    /// The show is only bookmarked.
    case bookmarked

    /// User is watching the show.
    case watching

    /// User is planning to start watching the show at some point.
    case planned

    /// User already finished watching the show.
    case completed

    /// User stopped watching the show but planning to resume at some point.
    case paused

    /// User stopped watching the show and don't plan to resume.
    case dropped
}

// MARK: - Extensions

extension TrackingStatus {
    /// Returns a color associated with the tracking status,
    var color: UIColor? {
        switch self {
        case .watching:
            return UIColor { traits in
                if traits.userInterfaceStyle == .dark {
                    return .white
                }

                return .green // TODO: light color scheme
            }

        case .planned:
            return .systemBlue

        case .completed:
            return .systemGreen

        case .paused:
            return .systemYellow

        case .dropped:
            return .systemRed

        case .untracked, .bookmarked:
            return nil
        }
    }
}
