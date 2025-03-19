import Foundation

protocol HTTPClient {
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

extension URLSession: HTTPClient {}
