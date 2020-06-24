import Foundation

import Net
import Proto

/// Fake news service which always returns the same list of predefined anime news.
public final class AnimeNewsMockService: MockService, AnimeNewsService {
    public func latestArticles(completion: @escaping (ServiceResult<[Data_V1_Article]>) -> Void) {
        let data = predefinedArticles()
        emulateResponse(with: data, completion: completion)
    }
}
