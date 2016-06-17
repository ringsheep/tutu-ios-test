//
//  GZ_CitiesToParsingOperation.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData

class GZ_CitiesToParsingOperation: GZ_CitiesParsingOperation
{
    override func main() -> Void
    {
        let semaphore = dispatch_semaphore_create(0)
        
        GZ_DATA_WRAPPER.returnCitiesToData({ (data) in
            
            self.pasrsingOfRoutingTo = true
            self.parseAndInsertCities(inContext: self.citiesNonPersistentManagedObjectContext,
                offset: self.offset,
                count: self.count,
                data: data, semaphore: semaphore)
            
        }) { (errorCode) in
            
            self.failureBlock( code : errorCode )
            dispatch_semaphore_signal(semaphore)
        }
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
}
