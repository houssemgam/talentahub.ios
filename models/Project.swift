import Foundation

struct Project: Decodable, Identifiable {
    let id: String
    let title: String
    let date: Date?
    let description: String
    let exigence: String
    let detail: String
    let image: String
    let createdAt: String
    let updatedAt: String
    let __v: Int
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case date
        case description
        case exigence
        case detail
        case image
        case createdAt
        case updatedAt
        case __v
    }
    
}
