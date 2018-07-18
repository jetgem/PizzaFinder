//
//  PizzaListViewController.swift
//  PizzaFinder
//
//  Created by evafiev on 7/18/18.
//

import UIKit
import CoreLocation

class PizzaListViewController: UITableViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!
    var places: [PizzaPlace]!
    var selectedPlace: PizzaPlace!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register custom cell
        tableView.register(UINib(nibName: "PizzaDetailsCell", bundle: nil), forCellReuseIdentifier: "PizzaDetailsCell")
        
        // Start location manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        places = PizzaEntityManager.shared.getAllPlaces()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPlaces), name: NSNotification.Name("UpdatePlaces"), object: nil)
    }
    
    @objc func reloadPlaces() {
        places = PizzaEntityManager.shared.getAllPlaces()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaDetailsCell", for: indexPath) as! PizzaDetailsCell

        // Configure the cell...
        let place = places[indexPath.row]
        cell.nameLabel.text = place.name
        cell.addressLabel.text = place.address

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlace = places[indexPath.row]
        performSegue(withIdentifier: "Details", sender: self)
    }

    // MARK: - Location manager delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
        PizzaEntityManager.shared.fetchNearbyPlaces(coordinate: userLocation.coordinate)
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Details" {
            let detailsVC = segue.destination as! PlaceDetailsViewController
            detailsVC.place = selectedPlace
        }
    }
}
