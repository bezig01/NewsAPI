import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.newscatcherapi.com"
        components.path = "/v2/\(path)"
        components.queryItems = queryItems.filter { $0.value != nil }
        return components.url
    }
}

extension Endpoint {
    
    static func latestHeadlines(
        when: String? = nil,
        languages: [String]? = nil,
        countries: [String]? = nil,
        topic: [Topic]? = nil,
        page: Int? = nil
    ) -> Self {
        return .init(
            path: "latest_headlines",
            queryItems: [
                URLQueryItem(name: "when", value: when),
                URLQueryItem(name: "lang", value: languages?.joined(separator: ",")),
                URLQueryItem(name: "countries", value: countries?.joined(separator: ",")),
                URLQueryItem(name: "topic", value: topic?.map { $0.rawValue }.joined(separator: ",")),
                URLQueryItem(name: "page", value: page != nil ? "\(page!)" : nil)
            ])
    }
}
