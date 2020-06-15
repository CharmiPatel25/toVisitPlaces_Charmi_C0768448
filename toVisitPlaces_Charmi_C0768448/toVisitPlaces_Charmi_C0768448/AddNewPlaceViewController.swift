//
//  AddNewPlaceViewController.swift
//  toVisitPlaces_Charmi_C0768448
//
//  Created by user174608 on 6/15/20.
//  Copyright © 2020 charmi. All rights reserved.
//

import UIKit
import MapKit

class AddNewPlaceViewController: UIViewController ,  MKMapViewDelegate, UITabBarDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate{

    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var zoom: UIStepper!
    
    @IBOutlet weak var locationBtn: UIButton!
    
    
    @IBOutlet weak var travelMode: UITabBar!
    
    
    
    
       var favoritePlaces: [Places]?
       var favoriteAddress: String?
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    var tappedLocation: CLLocationCoordinate2D?
    var favoriteLocation: CLLocation?
    
    var stepperComparingValue = 0.0
    
    let request = MKDirections.Request()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                        mapView.delegate = self
                  
                        setUpMapView()
                  
                        locationBtn.layer.cornerRadius = 30
                        locationBtn.layer.borderWidth = 1
                        locationBtn.layer.borderColor = UIColor.white.cgColor
                        locationBtn.widthAnchor.constraint(equalToConstant: 125.0).isActive = true
                        locationBtn.heightAnchor.constraint(equalToConstant: 25.0).isActive = true

                   
                        travelMode.delegate = self
                  
                        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
                        tap.numberOfTapsRequired = 2
                        view.addGestureRecognizer(tap)
                    
          
                        
                        loadPlaces()
    }
    func getPath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath = documentPath.appending("/Favorite-Place-Data.txt")
        return filePath
    }
    
    func loadPlaces(){
        favoritePlaces = [Places]()
        let filePath = getPath()
        if FileManager.default.fileExists(atPath: filePath) {
            do{
                let fileContent = try String(contentsOfFile: filePath)
                let contentArray = fileContent.components(separatedBy: "\n")
                for content in contentArray {
                    let favoritePlaceContent = content.components(separatedBy: ",")
                    if favoritePlaceContent.count == 2 {
                        let favoritePlace = Places(lattitude: Double(favoritePlaceContent[0])!, longitude: Double(favoritePlaceContent[1])!,address: favoritePlaceContent[2])
                        favoritePlaces?.append(favoritePlace)
                    }
                }
                
            }catch {
                print(error)
            }
        }
    }
    
    
    func setUpMapView() {
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = true
       currentLocation()
    }
    
    func currentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       if #available(iOS 11.0, *) {
          locationManager.showsBackgroundLocationIndicator = true
       } else {
          // code for earlier version
       }
       locationManager.startUpdatingLocation()
    }
    
    @objc func doubleTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        // remove all annotations(markers)
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        //remove overlays
        mapView.removeOverlays(mapView.overlays)
        //location finder with double tap
        let location = gestureRecognizer.location(in: mapView)
        
        self.tappedLocation = mapView.convert(location, toCoordinateFrom: mapView)
        
        self.favoriteLocation = CLLocation(latitude: self.tappedLocation?.latitude ?? 0.00, longitude: self.tappedLocation?.longitude ?? 0.00)
        //annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.tappedLocation!
        annotation.title = "Location Marked"
        annotation.subtitle = "Your Desired Location"
        // custom annotation
        mapView.addAnnotation(annotation)
        travelMode.isHidden = true
        locationBtn.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let favoritePlacesListTableVC = segue.destination as? ViewController {
            favoritePlacesListTableVC.favDestination = self.favoritePlaces
        }
    }
    
    @objc func saveData() {
        let filePath = getPath()
        
        var saveString = ""
        
        for favoritePlace in self.favoritePlaces! {
            saveString = "\(saveString)\(favoritePlace.lattitude),\(favoritePlace.longitude),\(favoritePlace.address)\n"
        }
        
        do{
            try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
        
        
    }
    
    
    
    
    @IBAction func zoomFunc(_ sender: UIStepper) {
        
        let stepperValue = zoom.value
        if(stepperValue > self.stepperComparingValue){
            var region: MKCoordinateRegion = mapView.region
            region.span.latitudeDelta /= 2.0
            region.span.longitudeDelta /= 2.0
            mapView.setRegion(region, animated: true)
            self.stepperComparingValue = stepperValue
        }else if(stepperValue < self.stepperComparingValue){

            var region: MKCoordinateRegion = mapView.region
              region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
              region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
              mapView.setRegion(region, animated: true)
            self.stepperComparingValue = stepperValue
        }
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
