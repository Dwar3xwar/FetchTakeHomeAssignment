import Foundation
import SwiftUI

protocol INetworkManager {
    func data(from url: URL) async throws -> Data
    func decodedData<T: Decodable>(from url: URL) async throws -> T
}

actor NetworkManager: INetworkManager {
    
    static let shared = NetworkManager(client: URLSession.shared)

    var client: HTTPClient = URLSession.shared
    
    private init(client: HTTPClient) {
        self.client = client
    }
    
    func data(from url: URL) async throws -> Data {
        let (data, _) = try await client.data(from: url, delegate: nil)
        return data
    }
    
    func decodedData<T: Decodable>(from url: URL) async throws -> T {
        let (data, response) = try await client.data(from: url, delegate: nil)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
