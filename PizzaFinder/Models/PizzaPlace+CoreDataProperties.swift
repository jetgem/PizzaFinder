//
//  PizzaPlace+CoreDataProperties.swift
//  PizzaFinder
//
//  Created by evafiev on 7/18/18.
//
//

import Foundation
import CoreData


extension PizzaPlace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PizzaPlace> {
        return NSFetchRequest<PizzaPlace>(entityName: "PizzaPlace")
    }

    @NSManaged public var name: String?
    @NSManaged public var address: String?

}
