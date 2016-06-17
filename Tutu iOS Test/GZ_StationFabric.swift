//
//  GZ_StationFabric.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData

class GZ_StationFabric
{
    class func insertStation
        (
        cityId : Int64 = 0 ,
        countryTitle : String = "" ,
        districtTitle : String = "" ,
        latitude : Double = 0.0 ,
        longitude : Double = 0.0 ,
        regionTitle : String = "" ,
        cityTitle : String = "" ,
        order : Int16 = 0 ,
        stationId : Int64 = 0 ,
        stationTitle : String = "" ,
        context : NSManagedObjectContext
        ) -> GZ_Station
    {
        let fetchRequest = NSFetchRequest(entityName: "GZ_Station")
        fetchRequest.predicate = NSPredicate(format: "stationId = %d", stationId)
        let fetchResults = (try? context.executeFetchRequest(fetchRequest)) as? [GZ_Station]
        
        if ( fetchResults?.count == 1 )
        {
            let station = (fetchResults?[0])!
            
            station.cityId = cityId
            station.cityTitle = cityTitle
            station.countryTitle = countryTitle
            station.districtTitle = districtTitle
            station.latitude = latitude
            station.longitude = longitude
            station.regionTitle = regionTitle
            station.order = order
            station.stationTitle = stationTitle
            
            return station
            
            
        }
        else
        {
            let station = NSEntityDescription.insertNewObjectForEntityForName("GZ_Station", inManagedObjectContext: context) as! GZ_Station
            
            station.cityId = cityId
            station.cityTitle = cityTitle
            station.countryTitle = countryTitle
            station.districtTitle = districtTitle
            station.latitude = latitude
            station.longitude = longitude
            station.regionTitle = regionTitle
            station.order = order
            station.stationId = stationId
            station.stationTitle = stationTitle
            
            return station
            
            
        }
    }
}
