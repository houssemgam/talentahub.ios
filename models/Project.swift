//
//  Project.swift
//  talentahub.ios
//
//  Created by mikhail on 29/11/2023.
//

import Foundation
import SwiftUI

struct project: Codable ,Identifiable {
    let id : String
    let title: String
    let date: Date
    let description: String
    let exigence: String
    let detail: String
    let imageURL : String
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case date
        case description
        case exigence
        case detail
        case imageURL // Assurez-vous que la clé pour l'image correspond exactement à celle dans votre JSON
    }
 
}
