import Foundation

import Net
import Proto

/// Fake ongoings service which always returns the same list of predefined anime shows.
public final class AnimeOngoingsMockService: MockService, AnimeOngoingsService {
    // MARK: Private properties

    /// Current year to set for each anime show.
    private let currentYear = Calendar.current.component(.year, from: Date())

    // MARK: Public methods

    public func ongoings(completion: @escaping (ServiceResult<[Data_V1_Anime]>) -> Void) {
        let ongoings = predefinedAnimes().map(makeOngoing(anime:))
        emulateResponse(with: ongoings, completion: completion)
    }

    // MARK: Private methods

    /// Returns a modified anime show with proper airing properties values.
    private func makeOngoing(anime: Data_V1_Anime) -> Data_V1_Anime {
        var anime = anime
        anime.airingStatus = .airing
        anime.year = Int32(currentYear)
        return anime
    }
}
