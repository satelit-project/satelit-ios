import Foundation
import Proto

public protocol AnimeOngoingsService {
    func ongoings() -> [Anime_V1_Anime]
}
