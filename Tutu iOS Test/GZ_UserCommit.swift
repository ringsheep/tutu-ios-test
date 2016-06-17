//
//  GZ_UserCommit.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/16/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import CoreData

class GZ_UserCommit: NSManagedObject {

    @NSManaged var stationFrom : GZ_Station
    @NSManaged var stationTo : GZ_Station
    @NSManaged var date : NSDate
    @NSManaged var id : Int16
    
}
