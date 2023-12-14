//
//  User.swift
//  talentahub.ios
//
//  Created by ryadh on 29/11/2023.
//

import Foundation
import SwiftUI

struct User: Identifiable {
    var id = UUID()
    var email: String
    var password: String
    var role: String
}
