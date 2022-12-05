public struct ErrorResult: Decodable {
    public let message: String
    public let code: String
}

public struct ErrorResponse: Decodable, Error {
    public let results: ErrorResult
}
