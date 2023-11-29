//
//  Event.swift
//  talentahub.ios
//
//  Created by mikhail on 28/11/2023.
//

import Foundation
import SwiftUI

struct Event: Identifiable {
    let id = UUID()
    let name: String
    let date: Date
    let descrption: String
    let location: String
    let image: String
}

