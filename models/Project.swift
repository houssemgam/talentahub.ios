//
//  Project.swift
//  talentahub.ios
//
//  Created by mikhail on 29/11/2023.
//

import Foundation
import SwiftUI

struct project: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
    let description: String
    let exigence: String
    let detail: String
    let image: String
    
 
}
