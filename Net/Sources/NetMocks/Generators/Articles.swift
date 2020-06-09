import Foundation

import Proto

/// Returns a list of predefined anime articles.
func predefinedArticles() -> [Data_V1_Article] {
    var articles = [Data_V1_Article]()
    for i in 0 ..< titles.count {
        var article = Data_V1_Article()
        article.title = titles[i]
        article.summary = summaries[i]
        article.source = sources[i]
        article.sourceURL = urls[i]
        article.likes = (0 ... 9999).randomElement()!  // swiftlint:disable:this force_unwrapping
        articles.append(article)
    }

    return articles
}

// MARK: - Predefined

private let titles = [
    #"Uzaki-chan Wants to Hang Out! Anime's Video Reveals Opening Song, More Cast, July 10 Debut"#,

    #"Sing "Yesterday" for Me – Episode 10"#,

    #"You Can Now Brew Coffee With the Evangelion Crew"#,
]

private let summaries = [
    #"The official website for the television anime of Take's Uzaki-chan Wants to Hang Out! (Uzaki-chan wa Asobitai!) manga began streaming the anime's third promotional video on Tuesday. The video reveals and previews the anime's opening theme song "Nadamesukashi Negotiation" (Negotiation by Comforting) by Kano and Naomi Ōzora as her character Uzaki-chan. It also reveals a new cast member, and the anime's July 10 premiere date."#,

    #"So just up front here, this episode of Sing "Yesterday" for Me ends on an absolutely vicious cliffhanger, which had me genuinely considering seeking out the manga to read through and find out what happened."#,

    #"Ever wondered what kind of coffee the Evangelion pilots drink? Well, wonder no more, because Nescafé has the answers."#,
]

private let sources = [
    "AnimeNewsNetwork",
    "AnimeNewsNetwork",
    "AnimeNewsNetwork",
]

private let timestamps = [
    1_591_703_234,
    1_591_703_134,
    1_591_701_234,
]

private let urls = [
    "https://www.animenewsnetwork.com/news/2020-06-08/uzaki-chan-wants-to-hang-out-anime-video-reveals-opening-song-more-cast-july-10-debut/.160408",

    "https://www.animenewsnetwork.com/review/sing-yesterday-for-me/episode-10/.160350",

    "https://www.animenewsnetwork.com/interest/2020-06-08/you-can-now-brew-coffee-with-the-evangelion-crew/.159558",
]
