//
//  Person.swift
//  project10-oisin
//
//  Created by Oisín Lavery on 11/12/15.
//  Copyright © 2015 Oisín Lavery. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
