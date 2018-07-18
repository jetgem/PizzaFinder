//
//  PlaceDetailsViewController.swift
//  PizzaFinder
//
//  Created by evafiev on 7/19/18.
//

import UIKit

class PlaceDetailsViewController: UIViewController {
    @IBOutlet weak var addressLabel: UILabel!
    var place: PizzaPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = place?.name
        addressLabel.text = place?.address
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
