//
//  GZ_CommitManager.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/16/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import CoreData

class GZ_CommitManager
{

}

extension GZ_CommitManager
{
    class func createOrUpdateUserCommit ( withId id: Int16,
                                          stationFrom: GZ_Station?,
                                          stationTo: GZ_Station?,
                                          date: NSDate?,
                                          success : () -> Void ,
                                          failure : () -> Void ) -> Void
    {
        
        let persistentManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let privateContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateContext.parentContext = persistentManagedObjectContext
        
        // создаем дубликаты станций, так как они в другом контексте
        var duplicatedStationFrom:GZ_Station?
        var duplicatedStationTo:GZ_Station?
        
        if ( stationFrom != nil )
        {
            duplicatedStationFrom = GZ_StationFabric.insertStation(stationFrom!.cityId,
                                                                   countryTitle: stationFrom!.countryTitle,
                                                                   districtTitle: stationFrom!.districtTitle,
                                                                   latitude: stationFrom!.latitude,
                                                                   longitude: stationFrom!.longitude,
                                                                   regionTitle: stationFrom!.regionTitle,
                                                                   cityTitle: stationFrom!.cityTitle,
                                                                   order: stationFrom!.order,
                                                                   stationId: stationFrom!.stationId,
                                                                   stationTitle: stationFrom!.stationTitle,
                                                                   context: privateContext)
        }
        
        if ( stationTo != nil )
        {
            duplicatedStationTo = GZ_StationFabric.insertStation(stationTo!.cityId,
                                                                   countryTitle: stationTo!.countryTitle,
                                                                   districtTitle: stationTo!.districtTitle,
                                                                   latitude: stationTo!.latitude,
                                                                   longitude: stationTo!.longitude,
                                                                   regionTitle: stationTo!.regionTitle,
                                                                   cityTitle: stationTo!.cityTitle,
                                                                   order: stationTo!.order,
                                                                   stationId: stationTo!.stationId,
                                                                   stationTitle: stationTo!.stationTitle,
                                                                   context: privateContext)
        }
        
        let newCommit = GZ_UserCommitFabric.insertUserCommit(id,
                                                             date: date,
                                                             stationFrom: duplicatedStationFrom,
                                                             stationTo: duplicatedStationTo,
                                                             context: privateContext)
        
        var e: NSError?
        do {
            try privateContext.save()
            success()
        } catch let error as NSError {
            e = error
            failure()
        } catch {
        }
        
    }
}