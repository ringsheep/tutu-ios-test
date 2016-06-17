//
//  GZ_CitiesParsingOperation.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData
import UIKit

class GZ_CitiesParsingOperation: NSOperation {
    
    var successBlock : (() -> Void)
    var failureBlock : ( code : Int ) -> Void
    var offset : Int
    var count : Int
    
    var substring : String?
    
    var pasrsingOfRoutingTo = false
    var pasrsingOfRoutingFrom = false
    
    // контекст городов начала пути
    let citiesNonPersistentManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).citiesNonPersistentManagedObjectContext
    
    // MARK: - инициализация операции в общем виде
    init( offset : Int , count : Int , success : () -> Void , failure : ( code : Int ) -> Void )
    {
        self.offset = offset
        self.count = count
        successBlock = success
        failureBlock = failure
        super.init()
    }
    
    // MARK: - инициализация операции с подстрокой
    init( substring : String , offset : Int , count : Int , success : () -> Void , failure : ( code : Int ) -> Void )
    {
        self.substring = substring
        self.offset = offset
        self.count = count
        successBlock = success
        failureBlock = failure
        super.init()
    }
    
}

// MARK: - процедура парсинга и добавления городов в контекст
extension GZ_CitiesParsingOperation
{
    func parseAndInsertCities ( inContext context : NSManagedObjectContext ,
                                          offset : Int,
                                          count : Int,
                                          data : NSArray? ,
                                          semaphore : dispatch_semaphore_t! )
    {
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.parentContext = context
        
        privateContext.performBlockAndWait({ () -> Void in
            
            if ( data!.count == 0 )
            {
                self.failureBlock(code: 0 )
                dispatch_semaphore_signal(semaphore)
                return
            }
            
            var filteredData = data
            if ( self.substring != nil )
            {
                let resultPredicate = NSPredicate(format: "ANY stations.stationTitle contains[cd] %@", self.substring!)
                filteredData = data!.filteredArrayUsingPredicate(resultPredicate)
            }
            
            // берем кусок из всего json-а для частичной подгрузки, с учетом текущего отступа
            var trueCount = count
            if ( filteredData?.count < ( count + offset ) )
            {
                trueCount = filteredData!.count - offset
            }
            let dataPart = filteredData?.subarrayWithRange(NSMakeRange(offset, trueCount))
            print("берем \(dataPart!.count) новых городов")
            if ( dataPart!.count == 0 )
            {
                self.failureBlock(code: 0 )
                dispatch_semaphore_signal(semaphore)
                return
            }
            
            for cityDictionary in dataPart!
            {
                if ( self.cancelled )
                {
                    break
                }
                
                // общие данные о городе
                let countryTitle = cityDictionary [ "countryTitle" ] as? String ?? ""
                let districtTitle = cityDictionary [ "districtTitle" ] as? String ?? ""
                let regionTitle = cityDictionary [ "regionTitle" ] as? String ?? ""
                let cityTitle = cityDictionary [ "cityTitle" ] as? String ?? ""
                let cityId =  cityDictionary [ "cityId" ] as? Int ?? 0
                
                // координаты города
                let point = (cityDictionary as! NSDictionary) [ "point" ] as! NSDictionary
                let longitude = point [ "longitude" ] as? Double ?? 0.0
                let latitude = point [ "latitude" ] as? Double ?? 0.0

                // станции города
                let cityStations = NSMutableSet ()
                if let stations = (cityDictionary as! NSDictionary) [ "stations" ] as? NSArray
                {
                    var orderCounter = 0
                    
                    for stationObject in stations
                    {
                        let station = stationObject as! NSDictionary
                        
                        if ( self.cancelled )
                        {
                            break
                        }
                        
                        orderCounter++
                        // общие данные о станции
                        let stationId = station [ "stationId" ] as? Int ?? 0
                        let cityId = station [ "cityId" ] as? Int ?? 0
                        let stationTitle = station [ "stationTitle" ] as? String ?? ""
                        let countryTitle = station [ "countryTitle" ] as? String ?? ""
                        let districtTitle = station [ "districtTitle" ] as? String ?? ""
                        let cityTitle = station [ "cityTitle" ] as? String ?? ""
                        let regionTitle = station [ "regionTitle" ] as? String ?? ""
                        
                        // координаты станции
                        let stationPoint = station [ "point" ] as! NSDictionary
                        let longitude = stationPoint [ "longitude" ] as? Double ?? 0.0
                        let latitude = stationPoint [ "latitude" ] as? Double ?? 0.0
                        
                        let cityStation = GZ_StationFabric.insertStation(
                            Int64( cityId ),
                            countryTitle: countryTitle,
                            districtTitle: districtTitle,
                            latitude: latitude,
                            longitude: longitude,
                            regionTitle: regionTitle,
                            cityTitle: cityTitle,
                            order: Int16 ( orderCounter ),
                            stationId: Int64 ( stationId ),
                            stationTitle: stationTitle,
                            context: privateContext)
                        cityStations.addObject ( cityStation )
                        
                    }
                    
                    if ( self.cancelled )
                    {
                        break
                    }
                }
                
                if ( self.cancelled )
                {
                    break
                }
                
                let city = GZ_CityFabric.insertCity(
                    Int64(cityId),
                    countryTitle: countryTitle,
                    districtTitle: districtTitle,
                    latitude: latitude,
                    longitude: longitude,
                    regionTitle: regionTitle,
                    cityTitle: cityTitle,
                    stations: cityStations,
                    routingTo: self.pasrsingOfRoutingTo,
                    routingFrom:  self.pasrsingOfRoutingFrom,
                    context: privateContext)
                
            }
            
            if ( self.cancelled != true )
            {
                var e: NSError?
                do {
                    try privateContext.save()
                } catch let error as NSError {
                    e = error
                    
                } catch {
                }
            }
            
        })
        
        self.successBlock()
        dispatch_semaphore_signal(semaphore)
    }
}