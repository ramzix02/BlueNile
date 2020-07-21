// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let favourite = try? newJSONDecoder().decode(Favourite.self, from: jsonData)

import Foundation

// MARK: - Favourite
struct FavouriteModel: Codable {
    let status: Int
    let message: String
    let data: DataClassFav
}

// MARK: - DataClass
struct DataClassFav: Codable {
    let products: [ProductFav]
}

// MARK: - Product
struct ProductFav: Codable {
    let id: Int
    let name, price, offer, offerPrice: String
    let image: String
    let favourite: Int

    enum CodingKeys: String, CodingKey {
        case id, name, price, offer
        case offerPrice = "offer_price"
        case image, favourite
    }
}

