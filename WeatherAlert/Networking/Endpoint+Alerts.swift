import Foundation

extension Endpoint {
    static func fetchAllAlerts() -> Self {
        Endpoint(path: "alerts/active", queryItems: [
            URLQueryItem(name: "status", value: "actual"),
            URLQueryItem(name: "message_type", value: "alert")
        ])
    }
}
