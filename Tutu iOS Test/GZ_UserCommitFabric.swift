//
//  GZ_UserCommitFabric.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/16/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData

class GZ_UserCommitFabric
{
    class func insertUserCommit
        (
        id : Int16 = 0,
        date : NSDate? ,
        stationFrom : GZ_Station? ,
        stationTo : GZ_Station? ,
        context : NSManagedObjectContext
        ) -> GZ_UserCommit
    {
        let fetchRequest = NSFetchRequest(entityName: "GZ_UserCommit")
        fetchRequest.predicate = NSPredicate(format: "id = %d", id)
        let fetchResults = (try? context.executeFetchRequest(fetchRequest)) as? [GZ_UserCommit]
        
        if ( fetchResults?.count == 1 )
        {
            let commit = (fetchResults?[0])!
            if (date != nil)
            {
                commit.date = date!
            }
            if (stationFrom != nil)
            {
                commit.stationFrom = stationFrom!
            }
            if (stationTo != nil)
            {
                commit.stationTo = stationTo!
            }
            
            return commit
            
            
        }
        else
        {
            let commit = NSEntityDescription.insertNewObjectForEntityForName("GZ_UserCommit", inManagedObjectContext: context) as! GZ_UserCommit
            
            commit.id = id
            if (date != nil)
            {
                commit.date = date!
            }
            if (stationFrom != nil)
            {
                commit.stationFrom = stationFrom!
            }
            if (stationTo != nil)
            {
                commit.stationTo = stationTo!
            }
            
            return commit
            
            
        }
    }
}
