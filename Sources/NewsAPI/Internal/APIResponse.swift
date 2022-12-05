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
        case .ok:
            let response = try T(from: decoder)
            result = .success(response.elements)
        case .error:
            let response = try ErrorResponse(from: decoder)
            result = .failure(response)
        }
    }
}

struct ArticlesResponse: Decodable, HasElementsType {
    let totalHits: Int
    let page: Int
    let totalPages: Int
    let pageSize: Int
    let articles: [NewsArticle]
    
    var elements: [NewsArticle] { articles }
}

private struct StatusResponse: Decodable {
    
    enum Status: String, Decodable {
        case ok, error
    }
    
    let status: Status
}
