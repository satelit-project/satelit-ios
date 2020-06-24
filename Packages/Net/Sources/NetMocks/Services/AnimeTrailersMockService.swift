import Foundation

import Net
import Proto

/// Fake trailers service which always returns the same list of predefined trailers.
public final class AnimeTrailersMockService: MockService, AnimeTrailersService {
    public func featured(completion: @escaping (ServiceResult<[Data_V1_Trailer]>) -> Void) {
        let data = predefinedTrailers()
        emulateResponse(with: data, completion: completion)
    }
}
