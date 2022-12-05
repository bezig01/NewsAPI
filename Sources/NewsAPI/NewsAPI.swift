import Foundation

public enum NewsAPIError: Error {
    case invalidURL
}

public final class NewsAPI {
    
    private let apiKey: String
    private let session: URLSession
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public init(apiKey: String, session: URLSession = URLSession.shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    public func getLatestHeadlines(
        when: String? = "1h",
        languages: [String]? = ["en"],
        countries: [String]? = ["us"],
        topic: [Topic]? = [.news],
        page: Int? = nil
    ) async throws -> [NewsArticle] {
        guard let url = Endpoint.latestHeadlines(when: when, languages: languages, countries: countries, topic: topic, page: page).url else {
            throw NewsAPIError.invalidURL
        }
        do {
            var request = URLRequest(url: url)
            request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
            let (data, _) = try await session.data(for: request)
            let response = try decoder.decode(APIReponse<ArticlesResponse>.self, from: data)
            switch response.result {
            case .success(let articles):
                return articles
            case .failure(let error):
                throw error
            }
        } catch {
            throw error
        }
    }
}
