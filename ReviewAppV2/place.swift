import Foundation

struct Place: Decodable {
    let name: String
    let photos: [Photo]?
    let reviews: [Review]?
    let userRatingsTotal: Int?
}

struct Photo: Decodable {
    let photoReference: String
}

struct Review: Decodable, Identifiable {
    var id = UUID()
    let authorName: String
    let rating: Int
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case rating
        case text
    }
}
