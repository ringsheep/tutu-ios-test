//
//  GZ_City.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData

class GZ_City: NSManagedObject
{
    @NSManaged var cityId : Int64
    @NSManaged var countryTitle : String
    @NSManaged var districtTitle : String
    @NSManaged var latitude : Double
    @NSManaged var longitude : Double
    @NSManaged var regionTitle : String
    @NSManaged var cityTitle : String
    @NSManaged var stations : NSSet
    @NSManaged var routingTo : Bool
    @NSManaged var routingFrom : Bool
}