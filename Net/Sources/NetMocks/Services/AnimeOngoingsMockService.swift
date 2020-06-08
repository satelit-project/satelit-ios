import Foundation

import Net
import Proto

/// Fake service to get a list of currently airing anime shows.
///
/// The service will always return a predefined list of shows and it will always be the same.
final class AnimeOngoingsMockService: MockService, AnimeOngoingsService {
    /// Current year to set for each anime show.
    private let currentYear = Calendar.current.component(.year, from: Date())

    func ongoings(completion: @escaping (ServiceResult<[Anime_V1_Anime]>) -> Void) {
        let ongoings = predefinedAnimes().map(makeOngoing(anime:))
        emulateResponse(with: ongoings, completion: completion)
    }

    /// Returns a modified anime show with proper airing properties values.
    private func makeOngoing(anime: Anime_V1_Anime) -> Anime_V1_Anime {
        var anime = anime
        anime.airingStatus = .airing
        anime.year = Int32(currentYear)
        return anime
    }
}
