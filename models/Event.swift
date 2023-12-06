import Foundation

struct Event: Decodable, Identifiable {
    let id: String
    let name: String
    let date: String // Adjust the type based on your needs
    let description: String
    let location: String
    let image: String
    let createdAt: String
    let updatedAt: String
    let __v: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case date
        case description
        case location
        case image
        case createdAt
        case updatedAt
        case __v
    }
}
