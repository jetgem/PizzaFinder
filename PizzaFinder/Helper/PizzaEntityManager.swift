//
//  PizzaEntityManager.swift
//  PizzaFinder
//
//  Created by evafiev on 7/18/18.
//

import UIKit
import CoreData
import CoreLocation

class PizzaEntityManager: NSObject {
    static let shared = PizzaEntityManager()
    
    private let context: NSManagedObjectContext
    
    override init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        super.init()
    }
    
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        let url = URL(string: "https://api.foursquare.com/v2/venues/search?client_id=ZTHFEQ4SCB1VV2OFWD3KXCZZ3P0IX4E4BCLRX24WEGXPUAVC&client_secret=Q23TAOSMS4VXCLVMYMCH4ZTYJWSA0FCQMVLGUKJRKOAD02K5&ll=\(coordinate.latitude),\(coordinate.longitude)&limit=5&categoryId=4bf58dd8d48988d1ca941735&v=20180718")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if let data = data {
                do {
                    // Convert the data to JSON
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    
                    if let json = jsonSerialized, let response = json["response"] as? Dictionary<String, AnyObject>, let venues = response["venues"] as? [Dictionary<String, AnyObject>] {
                        // Delete existing places
                        self.deleteAllPlaces()
                        
                        for venue in venues {
                            let entity = NSEntityDescription.entity(forEntityName: "PizzaPlace", in: self.context)
                            let place = NSManagedObject(entity: entity!, insertInto: self.context) as! PizzaPlace
                            place.name = venue["name"] as? String
                            
                            let location = venue["location"] as? [String: AnyObject]
                            if let location = location {
                                place.address = location["address"] as? String
                            }
                        }
                        
                        
                        do {
                            try self.context.save()
                        } catch {
                            print("Failed saving")
                        }
                        
                        NotificationCenter.default.post(name: Notification.Name("UpdatePlaces"), object: nil)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func getAllPlaces() -> [PizzaPlace] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PizzaPlace")
        request.returnsObjectsAsFaults = false
        
        do {
            return try context.fetch(request) as! [PizzaPlace]
        } catch {
            print("Failed")
        }
        
        return [PizzaPlace]()
    }
    
    func deleteAllPlaces() {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PizzaPlace")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
            print("failed batch delete")
        }

    }
}
