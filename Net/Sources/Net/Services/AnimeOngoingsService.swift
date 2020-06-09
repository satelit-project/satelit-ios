import Foundation

import Proto

/// A service to fetch anime shows that are currently airing.
public protocol AnimeOngoingsService {
    /// Fetches a list of currently airing anime shows.
    ///
    /// The list is sorted by how much time left until next episode.
    /// - Parameter completion: a closure to call with the fetched list of ongoings.
    func ongoings(completion: @escaping (ServiceResult<[Data_V1_Anime]>) -> Void)
}
