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
        loadData()
        intials()
        // Do any additional setup after loading the view.
    }
    
    func intials() {
        //mapviewDelegate
        mapView.delegate = self
        
        //Navigation Controller
        self.title = "Drag to edit"
        let add = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTapped))
        navigationItem.rightBarButtonItem = add
        // Do any additional setup after loading the view.
        
        //MARK: User defaults
        self.editLat = defaults.double(forKey: "editLat")
        self.editLong = defaults.double(forKey: "editLong")


               
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: editLat, longitude: editLong)
        annotation.title = "Drag this to edit"
        mapView.addAnnotation(annotation)
       
        
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let customLocation = CLLocationCoordinate2D(latitude: editLat, longitude: editLong)
        let region = MKCoordinateRegion(center: customLocation, span: span)
        
        // 4 - assign region to map
        mapView.setRegion(region, animated: true)
    }
    
    @objc func doneBtnTapped(){
        let alert = UIAlertController(title: "Alert", message: "Are you sure to save this new location?", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            print(self.mapView.annotations[0].coordinate)
            self.edittedData(self.mapView.annotations[0].coordinate.latitude, self.mapView.annotations[0].coordinate.longitude)
                    
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(addAction)
            alert.addAction(cancelAction)

            present(alert, animated: true, completion: nil)
    }
    
    @IBAction func zoom(_ sender: UIStepper) {
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
    
    
    
    
    
    
    func getDataFilePath() -> String {
         let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
         
         let filePath = documentPath.appending("/Favorite-Place-Data.txt")
         return filePath
     }
    
    func loadData(){
          editPlaces = [Places]()
          
          let filePath = getDataFilePath()
          if FileManager.default.fileExists(atPath: filePath) {
              
              do{
                  //creating string of file path
                  let fileContent = try String(contentsOfFile: filePath)
                  // seperating books from each other
                  let contentArray = fileContent.components(separatedBy: "\n")
                  for content in contentArray {
                      //seperating each book's content
                      let favoritePlaceContent = content.components(separatedBy: ",")
                      if favoritePlaceContent.count == 3 {
                          let favoritePlace = Places(lattitude: Double(favoritePlaceContent[0])!, longitude: Double(favoritePlaceContent[1])!, address: favoritePlaceContent[2])
                          editPlaces?.append(favoritePlace)
                      }
                  }
                  
              }catch {
                  print(error)
              }
          }
      }
    
    func editData(_ newArray: [Places]){
        
        let filePath = getDataFilePath()
                   
                   var saveString = ""
                   
                   for favoritePlace in newArray {
                       saveString = "\(saveString)\(favoritePlace.lattitude),\(favoritePlace.longitude),\(favoritePlace.address)\n"
                   }
                   
                   do{
                       try saveString.write(toFile: filePath, atomically: true, encoding: .utf8)
                   } catch {
                       print(error)
                   }
                   
    }
    
    func edittedData(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
           let lat = latitude
           let long = longitude
           
           

           CLGeocoder().reverseGeocodeLocation( CLLocation(latitude: latitude, longitude: longitude) ) { (placemarks, error) in
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
                                    


                                   let editPlace = Places(lattitude: lat , longitude: long , address: address )

                                   self.editPlaces?.remove(at: self.editPlaceIndex!)
                                         self.editPlaces?.append(editPlace)
                                    print("Data Added Successfully")
                                   self.editData(self.editPlaces!)
                                  self.navigationController?.popToRootViewController(animated: true)
                                 }

                            }
                    }
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


extension EditPlaceViewController: MKMapViewDelegate {
    
       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           
            let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
            pinAnnotation.animatesDrop = true
            pinAnnotation.isDraggable = true
            return pinAnnotation
        }

    
}
