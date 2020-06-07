import Foundation

import Proto

func generateAnimes() -> [Anime_V1_Anime] {
    return predefinedAnimes
}

// MARK: - Predefined

private let predefinedAnimes = [
    Anime_V1_Anime()
]
