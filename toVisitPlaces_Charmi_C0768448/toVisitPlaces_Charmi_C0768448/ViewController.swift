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
    
    func loadPlaces(){
        favDestination = [Places]()
        let filePath = getPath()
        if FileManager.default.fileExists(atPath: filePath) {
            do{
                let fileContent = try String(contentsOfFile: filePath)
                let contentArray = fileContent.components(separatedBy: "\n")
                for content in contentArray {
                    let favoritePlaceContent = content.components(separatedBy: ",")
                    if favoritePlaceContent.count == 2 {
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

}

