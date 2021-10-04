import Foundation

struct Endpoint {
    let path: String
    var queryItems = [URLQueryItem]()

    func makeRequest() -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.weather.gov"
        components.path = "/" + path
        components.queryItems = queryItems.isEmpty ? nil : queryItems

        guard let url = components.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
}
