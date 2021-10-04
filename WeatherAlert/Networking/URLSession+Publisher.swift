import Foundation
import Combine

extension URLSession {
    private static var defaultDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        return decoder
    }()

    func publisher<R: Decodable>(for endpoint: Endpoint, decoder: JSONDecoder = defaultDecoder) -> AnyPublisher<R, Error> {
        guard let request = endpoint.makeRequest() else {
            //should return a custom error
            return Fail( error: NSError()).eraseToAnyPublisher()
        }

        return dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ResponseWrapper<R>.self, decoder: decoder)
            .map(\.features)
            .eraseToAnyPublisher()
    }
}
