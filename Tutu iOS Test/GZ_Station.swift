//
//  GZ_Station.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData

class GZ_Station: NSManagedObject
{
    @NSManaged var order : Int16
    @NSManaged var cityId : Int64
    @NSManaged var countryTitle : String
    @NSManaged var districtTitle : String
    @NSManaged var latitude : Double
    @NSManaged var longitude : Double
    @NSManaged var regionTitle : String
    @NSManaged var cityTitle : String
    @NSManaged var stationId : Int64
    @NSManaged var stationTitle : String

}
