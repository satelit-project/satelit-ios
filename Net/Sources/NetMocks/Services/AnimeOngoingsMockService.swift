import Foundation

import Net
import Proto

final class AnimeOngoingsMockService: AnimeOngoingsService {
    func ongoings() -> [Anime_V1_Anime] {
        return generateAnimes()
    }
}
