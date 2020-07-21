// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let homeModel = try? newJSONDecoder().decode(HomeModel.self, from: jsonData)

import Foundation

// MARK: - HomeModel
struct HomeModel: Codable {
    let status: Int
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let categories, slider: [Category]
    let mostSeller, offers, newCollection: [MostSeller]
    let pages: [Page]
    let gold: Gold
    let link: String

    enum CodingKeys: String, CodingKey {
        case categories, slider
        case mostSeller = "most_seller"
        case offers
        case newCollection = "new_collection"
        case pages, gold, link
    }
}

// MARK: - Category
struct Category: Codable {
    let id: Int
    let name: String
    let image: String
}

// MARK: - Gold
struct Gold: Codable {
    let name, price: String
}

// MARK: - MostSeller
struct MostSeller: Codable {
    let id: Int
    let name, price: String
    let offer: Offer
    let offerPrice: String
    let image: String
    let favourite: Int

    enum CodingKeys: String, CodingKey {
        case id, name, price, offer
        case offerPrice = "offer_price"
        case image, favourite
    }
}

enum Offer: String, Codable {
    case no = "no"
    case yes = "yes"
}

// MARK: - Page
struct Page: Codable {
    let title, content: String
}
