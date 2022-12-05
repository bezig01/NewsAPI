import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "newsdata.io"
        components.path = "/api/1/\(path)"
        components.queryItems = queryItems.filter { $0.value != nil }
        
        return components.url
    }
}

extension Endpoint {
    
    static func news(
        key: String,
        query: String? = nil,
        queryInTitle: String? = nil,
        countries: [Country]? = nil,
        categories: [Category]? = nil,
        languages: [Language]? = nil,
        domains: [String]? = nil,
        page: Int = 0
    ) -> Self {
        return .init(
            path: "news",
            queryItems: [
                URLQueryItem(name: "apikey", value: key),
                URLQueryItem(name: "country", value: countries?.map { $0.rawValue }.joined(separator: ",")),
                URLQueryItem(name: "category", value: categories?.map { $0.rawValue }.joined(separator: ",")),
                URLQueryItem(name: "language", value: languages?.map { $0.rawValue }.joined(separator: ",")),
                URLQueryItem(name: "domain", value: domains?.joined(separator: ",")),
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "qInTitle", value: query),
                URLQueryItem(name: "page", value: "\(page)")
            ])
    }
    
    static func sources(
        key: String,
        category: Category? = nil,
        language: Language? = nil,
        country: Country? = nil
    ) -> Self {
        return .init(
            path: "sources",
            queryItems: [
                URLQueryItem(name: "apikey", value: key),
                URLQueryItem(name: "category", value: category?.rawValue),
                URLQueryItem(name: "language", value: language?.rawValue),
                URLQueryItem(name: "country", value: country?.rawValue)
            ])
    }
    
    static func domains(
        key: String
    ) -> Self {
        return .init(
            path: "domains",
            queryItems: [
                URLQueryItem(name: "apikey", value: key)
            ])
    }
}
