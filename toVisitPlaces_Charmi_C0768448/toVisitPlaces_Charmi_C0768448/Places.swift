//
//  Places.swift
//  toVisitPlaces_Charmi_C0768448
//
//  Created by user174608 on 6/15/20.
//  Copyright © 2020 charmi. All rights reserved.
//

import Foundation
class Places{
    var lattitude: Double
    var longitude: Double
    var address: String
    
    init(lattitude: Double, longitude: Double, address: String) {
        self.lattitude = lattitude
        self.longitude = longitude
        self.address = address
    }
}
