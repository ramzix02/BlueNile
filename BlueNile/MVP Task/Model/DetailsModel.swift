// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let details = try? newJSONDecoder().decode(Details.self, from: jsonData)

import Foundation

// MARK: - Details
struct Details: Codable {
    let status: Int
    let message: String
    let data: DataClassDetails
}

// MARK: - DataClass
struct DataClassDetails: Codable {
    let product: PurpleProduct
    let products: [ProductElement]
    let gold: GoldDetails
    let link: String
}

// MARK: - Gold
struct GoldDetails: Codable {
    let name, price: String
}

// MARK: - PurpleProduct
struct PurpleProduct: Codable {
    let id: Int
    let name, desc: String
    let count, price: Int
    let offer: String
    let offerPrice: Int
    let sizeShow: String
    let favourite: Int
    let currency: String
    let size: String
    let images: [Image]

    enum CodingKeys: String, CodingKey {
        case id, name, desc, count, price, offer
        case offerPrice = "offer_price"
        case sizeShow = "size_show"
        case favourite, currency, size, images
    }
}

// MARK: - Image
struct Image: Codable {
    let image: String
}

// MARK: - ProductElement
struct ProductElement: Codable {
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
