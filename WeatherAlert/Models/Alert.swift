import Foundation

class Alert: Decodable {
    let name: String
    let start: Date
    let end: Date
    let senderName: String
    let severity: String
    let certainty: String
    let urgency: String
    let description: String
    let instruction: String?
    let affectedZones: [String]

    var image: URL?

    enum CodingKeys: String, CodingKey {
        case name = "event"
        case start = "onset"
        case end = "expires"
        case senderName
        case severity
        case certainty
        case urgency
        case description
        case instruction
        case affectedZones
    }
}
