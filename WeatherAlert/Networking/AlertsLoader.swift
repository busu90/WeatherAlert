import Foundation
import Combine

struct AlertsLoader {
    private let urlSession = URLSession.shared

    func loadAllAlerts() -> AnyPublisher<[Alert], Error> {
        let res = urlSession.publisher(for: .fetchAllAlerts()) as AnyPublisher<[AlertWrapper], Error>
        return res.map({ wrappers in wrappers.map(\.alert) }).eraseToAnyPublisher()
    }
}
