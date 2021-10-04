import Foundation
import Combine
import SwiftUI

class AlertListViewModel {
    enum State {
        case loading
        case alerts(_ alerts: [Alert])
        case error(_ error: Error)
    }

    private let alertsLoader = AlertsLoader()

    @Published private(set) var state = State.loading

    func updateAlerts() {
        alertsLoader.loadAllAlerts()
            .map(State.alerts)
            .catch { error in
                Just(.error(error))
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
}
