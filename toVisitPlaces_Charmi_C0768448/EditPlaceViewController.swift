//
//  EditPlaceViewController.swift
//  toVisitPlaces_Charmi_C0768448
//
//  Created by user174608 on 6/15/20.
//  Copyright © 2020 charmi. All rights reserved.
//

import UIKit
import  MapKit

class EditPlaceViewController: UIViewController {

    var stepperComparingValue = 0.0
    let defaults = UserDefaults.standard
    var editLat: Double = 0.0
    var editLong: Double = 0.0
    var editPlaceIndex: Int?
    var editPlaces: [Places]?
    
    @IBOutlet weak var zoom: UIStepper!
    
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
