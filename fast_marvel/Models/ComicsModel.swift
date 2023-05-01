//
//  ComicsModel.swift
//  fast_marvel
//
//  Created by Guilherme Siepmann on 24/04/23.
//

import Foundation

// MARK: - ComicsModel
struct ComicsModel: Codable {
    let code: Int?
    let status, copyright, attributionText, attributionHTML: String?
    let etag: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    let offset, limit, total, count: Int?
    let results: [Comic]?
}

// MARK: - Comic
struct Comic: Codable {    
    let id, digitalID: Int?
    let title: String?
    let issueNumber: Int?
    let variantDescription: String?
    let description: String?
    let modified: String?
    let isbn, upc: String?
    let diamondCode: String?
    let ean, issn: String?
    let format: String?
    let pageCount: Int?
    let textObjects: [TextObject]?
    let resourceURI: String?
    let urls: [URLElement]?
    let series: Series?
    let variants: [Series]?
    let collections: [ComicSummary]?
    let collectedIssues: [Series]?
    let dates: [DateElement]?
    let prices: [Price]?
    let thumbnail: Thumbnail?
    let images: [Thumbnail]?
    let creators: Creators?
    let characters: Characters?
    let stories: Stories?
    let events: Characters?

    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title, issueNumber, variantDescription, description, modified,
             isbn, upc, diamondCode, ean, issn, format, pageCount, textObjects,
             resourceURI, urls, series, variants, collections, collectedIssues,
             dates, prices, thumbnail, images, creators, characters, stories, events
    }
}

// MARK: - Characters
struct Characters: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [Series]?
    let returned: Int?
}

// MARK: - Series
struct Series: Codable {
    let resourceURI: String?
    let name: String?
}

// MARK: - Creators
struct Creators: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [CreatorsItem]?
    let returned: Int?
}

// MARK: - CreatorsItem
struct CreatorsItem: Codable {
    let resourceURI: String?
    let name: String?
    let role: String?
}

// MARK: - DateElement
struct DateElement: Codable {
    let type: String?
    let date: String?
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String?
    let thumbnailExtension: String?

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
    
    func thumbURL() -> String {
        if let path = self.path,
           let thumbnailExtension = self.thumbnailExtension {
            return "\(path).\(thumbnailExtension)"
        }
        
        return ""
    }
}

// MARK: - Price
struct Price: Codable {
    let type: String?
    let price: Double?
}

// MARK: - Stories
struct Stories: Codable {
    let available: Int?
    let collectionURI: String?
    let items: [StoriesItem]?
    let returned: Int?
}

// MARK: - StoriesItem
struct StoriesItem: Codable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

// MARK: - TextObject
struct TextObject: Codable {
    let type: String?
    let language: String?
    let text: String?
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String?
    let url: String?
}

struct ComicSummary: Codable {
    let resourceURI: String?
    let name: String?
}
