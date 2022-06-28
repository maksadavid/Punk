//
//  Beer.swift
//  Punk
//
//  Created by David Maksa on 27.06.22.
//

import Foundation

struct Beer: Codable, Equatable {
    let id: Int
    let name: String
    let tagline: String
    let description: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case tagline = "tagline"
        case description = "description"
        case imageUrl = "image_url"
    }
}
