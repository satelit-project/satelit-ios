import Foundation

import Proto

/// A service that can fetch anime trailers.
public protocol AnimeTrailersService {
    /// Fetches and returns a list of featured anime trailers.
    ///
    /// The list is sorted by popularity starting with the most popular one.
    /// - Parameter completion: a closure to call with the request result.
    func featured(completion: @escaping (ServiceResult<[Data_V1_Trailer]>) -> Void)
}
