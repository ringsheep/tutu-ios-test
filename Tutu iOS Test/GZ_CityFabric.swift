//
//  GZ_CityFabric.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData

//MARK: создание города
class GZ_CityFabric
{
    class func insertCity
        (
        cityId : Int64 = 0 ,
        countryTitle : String = "" ,
        districtTitle : String = "" ,
        latitude : Double = 0.0 ,
        longitude : Double = 0.0 ,
        regionTitle : String = "" ,
        cityTitle : String = "" ,
        stations : NSSet = NSSet(),
        routingTo : Bool = false,
        routingFrom : Bool = false,
        context : NSManagedObjectContext
        ) -> GZ_City
    {
        let fetchRequest = NSFetchRequest(entityName: "GZ_City")
        fetchRequest.predicate = NSPredicate(format: "cityId = %d", cityId)
        let fetchResults = (try? context.executeFetchRequest(fetchRequest)) as? [GZ_City]
        
        if ( fetchResults?.count == 1 )
        {
            let city = (fetchResults?[0])!
            
            city.cityTitle = cityTitle
            city.countryTitle = countryTitle
            city.districtTitle = districtTitle
            city.latitude = latitude
            city.longitude = longitude
            city.regionTitle = regionTitle
            city.stations = stations
            
            // проверка того, что город ранее не парсился - ему не был назначен флаг начала или конца пути
            if ( city.routingTo != true )
            {
                city.routingTo = routingTo
            }
            if ( city.routingFrom != true )
            {
                city.routingTo = routingFrom
            }
            //print("updating city \(cityTitle)")
            return city
            
            
        }
        else
        {
            let city = NSEntityDescription.insertNewObjectForEntityForName("GZ_City", inManagedObjectContext: context) as! GZ_City
            
            city.cityId = cityId
            city.cityTitle = cityTitle
            city.countryTitle = countryTitle
            city.districtTitle = districtTitle
            city.latitude = latitude
            city.longitude = longitude
            city.regionTitle = regionTitle
            city.stations = stations
            city.routingTo = routingTo
            city.routingFrom = routingFrom
            
            //print("new city \(cityTitle)")
            return city
            
            
        }
    }
}
