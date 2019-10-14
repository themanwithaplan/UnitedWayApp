//
//  File.swift
//  United-Way
//
//  Created by Jacob Julag-ay on 10/14/19.
//  Copyright © 2019 UnitedWay. All rights reserved.
//

import Foundation


struct User{
    var id: String
    var email: String?
    var name: String?
}

extension User{
    init?(json: JSON) {
        guard let id = json["id"] as? String else {
            return nil
        }
        self.id = id
        self.email = json["email"] as? String
        self.name = json["name"] as? String
    }
}
