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
    
    public func getTopHeadlines(
        query: String? = nil,
        categories: [Category]? = nil,
        languages: [Language]? = nil,
        domains: [String]? = nil
    ) async throws -> [NewsArticle] {
        guard let url = Endpoint.news(key: apiKey, query: query, categories: categories, languages: languages, domains: domains).url else {
            throw NewsAPIError.invalidURL
        }
        do {
            let (data, _) = try await session.data(from: url)
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
    
    public func search(
        query: String,
        domains: [String]? = nil,
        languages: [Language]? = nil
    ) async throws -> [NewsArticle] {
        guard let url = Endpoint.news(key: apiKey, query: query, languages: languages, domains: domains).url else {
            throw NewsAPIError.invalidURL
        }
        do {
            let (data, _) = try await session.data(from: url)
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
    
    public func getSources(
        category: Category? = nil,
        language: Language? = nil,
        country: Country? = nil
    ) async throws -> [NewsSource] {
        guard let url = Endpoint.sources(key: apiKey, category: category, language: language, country: country).url else {
            throw NewsAPIError.invalidURL
        }
        do {
            let (data, _) = try await session.data(from: url)
            let response = try decoder.decode(APIReponse<SourcesResponse>.self, from: data)
            switch response.result {
            case .success(let sources):
                return sources
            case .failure(let error):
                throw error
            }
        } catch {
            throw error
        }
    }
}
