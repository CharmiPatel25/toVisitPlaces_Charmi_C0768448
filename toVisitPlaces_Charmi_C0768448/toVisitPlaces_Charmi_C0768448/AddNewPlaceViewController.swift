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
                    if favoritePlaceContent.count == 3 {
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
    
    
    
    @IBAction func locationBtnClick(_ sender: UIButton) {
        let sourceLat = mapView.userLocation.location?.coordinate.latitude ?? 0.00
                       let sourceLong = mapView.userLocation.location?.coordinate.longitude ?? 0.00
                       let destinationLat = self.tappedLocation?.latitude ?? 0.00
                       let destinationLong = self.tappedLocation?.longitude ?? 0.00
                       print("Source: \(sourceLat) , \(sourceLong)")
                       print("Destination: \(destinationLat) , \(destinationLong)")
                           if(sourceLat == 0.0 || sourceLong == 0.0){
                               let alert = UIAlertController(title: "Location couldn't retrieve!!", message: "Simulate Location from your xcode", preferredStyle: UIAlertController.Style.alert)
                                             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                             self.present(alert, animated: true, completion: nil)
                       }
                           else if(destinationLat == 0.0 || destinationLong == 0.0){
                               let alert = UIAlertController(title: "Alert", message: "Please double tap to select destination", preferredStyle: UIAlertController.Style.alert)
                                  alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                                  self.present(alert, animated: true, completion: nil)
                           }else{
                   
                   let alert = UIAlertController(title: "Select!!", message: "Please select the Travel mode", preferredStyle: UIAlertController.Style.alert)

                   alert.addAction(UIAlertAction(title: "Walking", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in

                       self.travelMode.selectedItem = self.travelMode.items?[0]
                       self.request.transportType = .walking
                       self.getRoute()
                   }))
                   alert.addAction(UIAlertAction(title: "Drive", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in

                       self.travelMode.selectedItem = self.travelMode.items?[1]
                           self.request.transportType = .automobile
                           self.getRoute()
                          }))
                   self.present(alert, animated: true, completion: nil)
              
                   }
    }
    
    
    func getRoute(){
               //source and destination lat and long
               let sourceLat = mapView.userLocation.location?.coordinate.latitude ?? 0.00
               let sourceLong = mapView.userLocation.location?.coordinate.longitude ?? 0.00
               let destinationLat = self.tappedLocation?.latitude ?? 0.00
               let destinationLong = self.tappedLocation?.longitude ?? 0.00
               print("Source: \(sourceLat) , \(sourceLong)")
               print("Destination: \(destinationLat) , \(destinationLong)")
                   travelMode.isHidden = false
                  // locationBtn.isHidden = true
                   // request globally declared
                   request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLong), addressDictionary: nil))
                   request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong), addressDictionary: nil))
                   request.requestsAlternateRoutes = true
                      

                   let directions = MKDirections(request: request)

                   directions.calculate { [unowned self] response, error in
                       guard let unwrappedResponse = response else { return }

                       for route in unwrappedResponse.routes {
                           self.mapView.addOverlay(route.polyline)
                               self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                       }
                   }
           }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if self.request.transportType == .automobile
        {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        renderer.alpha = 0.80
            return renderer
            
        }else if self.request.transportType == .walking {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.red
            renderer.lineDashPattern = [0, 10]
            renderer.lineWidth = 8
            renderer.alpha = 0.80
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            if(item == travelMode   .items?[0]){
                //remove overlays
                mapView.removeOverlays(mapView.overlays)
                self.request.transportType = .walking
                travelMode.selectedItem = travelMode.items?[0]
                getRoute()
            }else if(item == travelMode.items?[1]){
                //remove overlays
                mapView.removeOverlays(mapView.overlays)
                self.request.transportType = .automobile
                travelMode.selectedItem = travelMode.items?[1]
                getRoute()
            }
        }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           if annotation is MKUserLocation{
            return nil

        }
                    let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
                    pinAnnotation.animatesDrop = true
                    pinAnnotation.canShowCallout = true
                    pinAnnotation.rightCalloutAccessoryView = UIButton(type: .contactAdd)
                    return pinAnnotation
    }
    
     func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
     {
        
                    let alert = UIAlertController(title: "Favorite ?", message: "Do you want to add this place to your list?", preferredStyle: .alert)
                let addAction = UIAlertAction(title: "Add", style: .cancel) { (UIAlertAction) in
    //                print("Data Addition process")

                    let lat = self.favoriteLocation?.coordinate.latitude
                    let long = self.favoriteLocation?.coordinate.longitude
                    
                    
                    CLGeocoder().reverseGeocodeLocation(self.favoriteLocation ?? CLLocation() ) { (placemarks, error) in
                                 if error != nil {
                                     print("Error found: \(error!)")
                                 } else {
                                     if let placemark = placemarks?[0] {
                                     
                                     var address = ""
                                     
                                         if placemark.subThoroughfare != nil{
                                             address += placemark.subThoroughfare! + " "
                                         }
                                         
                                         if placemark.thoroughfare != nil {
                                              address += placemark.thoroughfare! + " "
                                         }
                                         
                                         if placemark.subLocality != nil {
                                             address += placemark.subLocality! + " "
                                                            }
                                         
                                         if placemark.subAdministrativeArea != nil {
                                             address += placemark.subAdministrativeArea! + " "
                                                            }
                                         
                                         if placemark.postalCode != nil {
                                             address += placemark.postalCode! + " "
                                                            }
                                         
                                         if placemark.country != nil {
                                             address += placemark.country!
                                                            }
                                         print(address)
                                        self.favoriteAddress = address


                                      let favoritePlace = Places(lattitude: lat ?? 0.0, longitude: long ?? 0.0, address: self.favoriteAddress ?? "no address found")

                                             self.favoritePlaces?.append(favoritePlace)
                                        print("Place Added")
                                      self.saveData()
                                      self.navigationController?.popToRootViewController(animated: true)
                                     }
                               
                                }
                        }
                }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alert.addAction(cancelAction)
                    alert.addAction(addAction)
              
                 present(alert, animated: true, completion: nil)
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

  

