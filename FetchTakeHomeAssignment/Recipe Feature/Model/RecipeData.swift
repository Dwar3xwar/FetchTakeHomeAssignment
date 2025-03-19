struct RecipeDataResponse: Codable {
    var recipes: [RecipeData]
}

struct RecipeData: Codable, Identifiable, Equatable {
    let id: String
    let cuisine: String
    let name: String
    let imageURLString: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case cuisine
        case name
        case imageURLString = "photo_url_small"
    }
}
