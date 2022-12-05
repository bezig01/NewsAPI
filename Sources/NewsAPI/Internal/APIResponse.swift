import Foundation

protocol HasElementsType {
    associatedtype Element
    var elements: [Element] { get }
}

struct APIReponse<T: Decodable & HasElementsType>: Decodable {
    
    let result: Result<[T.Element], ErrorResponse>
    
    init(from decoder: Decoder) throws {
        let response = try StatusResponse(from: decoder)
        switch response.status {
        case .success:
            let response = try T(from: decoder)
            result = .success(response.elements)
        case .error:
            let response = try ErrorResponse(from: decoder)
            result = .failure(response)
        }
    }
}

struct ArticlesResponse: Decodable, HasElementsType {
    let totalResults: Int
    let results: [NewsArticle]
    let nextPage: Int
    
    var elements: [NewsArticle] { results }
}

struct SourcesResponse: Decodable, HasElementsType {
    let results: [NewsSource]
    
    var elements: [NewsSource] { results }
}

private struct StatusResponse: Decodable {
    
    enum Status: String, Decodable {
        case success, error
    }
    
    let status: Status
}
