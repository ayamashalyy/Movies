//
//  YoutubeSearchResponse.swift
//  Movies
//
//  Created by aya on 03/10/2024.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
    
   }

struct VideoElement: Codable {
    let id: IdVideoElement
    }

struct IdVideoElement:Codable {
    let kind: String
    let videoId: String
    }
