import Foundation

import Proto

/// Returns a list of predefined anime trailers.
func predefinedTrailers() -> [Data_V1_Trailer] {
    var trailers = [Data_V1_Trailer]()
    for (anime, url) in zip(predefinedAnimes(), videoURLs) {
        var trailer = Data_V1_Trailer()
        trailer.anime = anime
        trailer.videoURL = url
        trailers.append(trailer)
    }

    return trailers
}

// MARK: - Predefined

private let videoURLs = [
    "https://www.youtube.com/watch?v=RnOwqnIfSqI",
    "https://www.youtube.com/watch?v=aUOTU8JZriE",
    "https://www.youtube.com/watch?v=f8p9_r2w98g",
    "https://www.youtube.com/watch?v=tAgw7NQa-H4",
    "https://www.youtube.com/watch?v=Y3hlmOU09Qw",
    "https://www.youtube.com/watch?v=1YANqqz0qS8",
    "https://www.youtube.com/watch?v=oS4HbeJiZRg",
    "https://www.youtube.com/watch?v=em-V_Ti3nTI",
    "https://www.youtube.com/watch?v=DR1d_Pm729o",
    "https://www.youtube.com/watch?v=V_Cvvl1fVBE",
]
