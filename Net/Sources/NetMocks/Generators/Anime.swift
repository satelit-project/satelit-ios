import Foundation

import Proto

/// Returns list of all predefined anime shows.
func predefinedAnimes() -> [Anime_V1_Anime] {
    var animes = [Anime_V1_Anime]()
    for i in 0 ..< names.count {
        var anime = Anime_V1_Anime()
        anime.name = names[i]
        anime.thumbnailURL = thumbnails[i]
        anime.type = types[i]
        anime.season = seasons[i]
        anime.year = Int32(years[i])
        anime.airingStatus = statuses[i]
        anime.score = Float(scores[i])
        animes.append(anime)
    }
    
    return animes
}

// MARK: - Predefined

private let names = [
    "Boku no Hero Academia (2019)",
    "BNA",
    "Kakushigoto",
    "Yuru Yuri Ten",
    "Shokugeki no Souma: Gou no Sara",
    "Re:Zero kara Hajimeru Isekai Seikatsu (2018)",
    "Kuusen Madoushi Kouhosei no Kyoukan",
    "Ore no Imouto ga Konna ni Kawaii Wake ga Nai.",
    "Code Geass: Hangyaku no Lelouch",
    "Yahari Ore no Seishun LoveCome wa Machigatte Iru. Kan",
]

private let thumbnails = [
    "https://cdn-eu.anidb.net/images/main/238059.jpg",
    "https://cdn-eu.anidb.net/images/main/244892.jpg",
    "https://cdn-eu.anidb.net/images/main/244800.jpg",
    "https://cdn-eu.anidb.net/images/main/237553.jpg",
    "https://cdn-eu.anidb.net/images/main/244734.jpg",
    "https://cdn-eu.anidb.net/images/main/221173.jpg",
    "https://cdn-eu.anidb.net/images/main/221957.jpg",
    "https://cdn-eu.anidb.net/images/main/221834.jpg",
    "https://cdn-eu.anidb.net/images/main/221573.jpg",
    "https://cdn-eu.anidb.net/images/main/248007.jpg",
]

private let types: [Anime_V1_AnimeType] = [
    .tv,
    .ona,
    .tv,
    .ova,
    .tv,
    .movie,
    .tv,
    .tv,
    .tv,
    .tv
]

private let seasons: [Anime_V1_AiringSeason] = [
    .winter,
    .spring,
    .spring,
    .fall,
    .summer,
    .fall,
    .summer,
    .spring,
    .fall,
    .summer,
]

private let years = [
    2019,
    2020,
    2020,
    2019,
    2020,
    2018,
    2015,
    2013,
    2007,
    2020,
]

private let statuses: [Anime_V1_AiringStatus] = [
    .aired,
    .aired,
    .airing,
    .aired,
    .unaired,
    .aired,
    .aired,
    .aired,
    .aired,
    .unaired,
]

private let scores = [
    7.64,
    7.40,
    6.75,
    7.15,
    0,
    7.05,
    5.67,
    6.98,
    8.66,
    0,
]
