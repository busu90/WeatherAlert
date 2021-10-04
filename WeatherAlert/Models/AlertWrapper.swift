import Foundation

struct AlertWrapper: Decodable {
    let alert: Alert

    enum CodingKeys: String, CodingKey {
        case alert = "properties"
    }
}
