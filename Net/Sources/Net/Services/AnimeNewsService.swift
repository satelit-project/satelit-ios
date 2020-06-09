import Foundation

import Proto

/// Represents a service that can fetch anime news.
public protocol AnimeNewsService {
    /// Fetches and returns a list of latest anime news articles.
    ///
    /// The list is sorted starting from the most recent article.
    /// - Parameter completion: a closure to call with the request result.
    func latestArticles(completion: @escaping (ServiceResult<[Data_V1_Article]>) -> Void)
}
