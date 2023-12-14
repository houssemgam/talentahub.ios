import Foundation

struct Talent: Codable, Identifiable, Hashable {
    var id: String?
    var titrepro: String
    var teamtalent: String
    var email: String
    var cartepro: Int
    var affiche: String?
    var typetalent: String
    var besoinmaterielle: String

    private enum CodingKeys: String, CodingKey {
        case id = "_id" // Map "id" to "_id"
        case titrepro
        case teamtalent
        case email
        case cartepro
        case affiche
        case typetalent
        case besoinmaterielle
    }
}

struct FetchTalentsResponse: Decodable {
    let talents: [Talent]
    let message: String
    let statusCode: Int
}
