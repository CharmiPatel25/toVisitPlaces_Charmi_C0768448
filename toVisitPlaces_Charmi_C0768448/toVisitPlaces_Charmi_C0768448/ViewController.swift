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
        let filePath = documentPath.appending("/Favorite-Place-Data.txt")
        return filePath
    }
    
    func loadPlaces(){
        favDestination = [Places]()
        let filePath = getPath()
        if FileManager.default.fileExists(atPath: filePath) {
            do{
                let fileContent = try String(contentsOfFile: filePath)
                let contentArray = fileContent.components(separatedBy: "\n")
                for content in contentArray {
                    let favoritePlaceContent = content.components(separatedBy: ",")
                    if favoritePlaceContent.count == 3 {
                        let favoritePlace = Places(lattitude: Double(favoritePlaceContent[0])!, longitude: Double(favoritePlaceContent[1])!,address: favoritePlaceContent[2])
                        favDestination?.append(favoritePlace)
                    }
                }
                
            }catch {
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
            loadPlaces()
            self.tableView.reloadData()
    }

    func deleteData(_ newArray: [Places]){
        
        let filePath = getPath()
                   
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
    
          //Table Data
    
       override func numberOfSections(in tableView: UITableView) -> Int {
           // #warning Incomplete implementation, return the number of sections
           return 1
       }

       override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of rows
           return favDestination?.count ?? 0
       }

       
       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
                   let favoritePlace = self.favDestination![indexPath.row]
                   let cell = tableView.dequeueReusableCell(withIdentifier: "favoritePlaceCell")
                  cell?.textLabel?.text =  favoritePlace.address
                cell?.detailTextLabel?.text = "Lattitude: " + String(favoritePlace.lattitude) + " Longitude: " + String(favoritePlace.longitude)
        return cell!
       }
       override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
               
               var newArray = self.favDestination!
               
               newArray.remove(at: indexPath.row)
               
               if editingStyle == .delete {
                   let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this place?", preferredStyle: .alert)
                   let addAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                       // Delete the row from the data source
                       self.favDestination?.remove(at: indexPath.row)
                       self.tableView.deleteRows(at: [indexPath], with: .automatic)
                       
                       self.deleteData(newArray)
                   }
                   let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
               
                   alert.addAction(addAction)
                   alert.addAction(cancelAction)
                      present(alert, animated: true, completion: nil)
                   
               }
           }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoritePlace = self.favDestination![indexPath.row]
        self.editDestination = self.favDestination![indexPath.row]
        
        defaults.set(favoritePlace.lattitude, forKey: "editLat")
        defaults.set(favoritePlace.longitude, forKey: "editLong")
        
        let editPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "editPlaceViewController") as! EditPlaceViewController

        editPlaceViewController.editPlaceIndex = indexPath.row
        
        self.navigationController?.pushViewController(editPlaceViewController, animated: true)
    }
    
    


}

