import Foundation

struct ResponseWrapper<Wrapped: Decodable>: Decodable {
    let features: Wrapped
}
