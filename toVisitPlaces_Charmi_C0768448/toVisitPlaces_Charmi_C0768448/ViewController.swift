//
//  ViewController.swift
//  toVisitPlaces_Charmi_C0768448
//
//  Created by user174608 on 6/13/20.
//  Copyright © 2020 charmi. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    
    var editDestination :Places?
    var favDestination: [Places]?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func getPath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = documentPath.appending("/FavoritePlaceData.txt")
        return filePath
    }
    
    


}

