public struct ErrorResponse: Decodable, Error {
    public let errorCode: String
    public let message: String
}
