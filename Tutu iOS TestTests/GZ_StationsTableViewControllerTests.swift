//
//  GZ_StationsTableViewControllerTests.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/20/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import XCTest
import CoreData
@testable import Tutu_iOS_Test

class GZ_StationsTableViewControllerTests: XCTestCase {
    
    var storeCoordinator: NSPersistentStoreCoordinator!
    var managedObjectContext: NSManagedObjectContext!
    var managedObjectModel: NSManagedObjectModel!
    var store: NSPersistentStore!
    
    var stationsViewController: GZ_StationsTableViewController!
    
    override func setUp() {
        super.setUp()
        
        // тестовый контекст
        managedObjectModel = NSManagedObjectModel.mergedModelFromBundles(nil)
        storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        store = try? storeCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
        managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        
        stationsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("GZ_StationsTableViewController") as! GZ_StationsTableViewController
        stationsViewController.managedObjectContext = managedObjectContext
    }
    
    override func tearDown() {
        managedObjectContext = nil
        super.tearDown()
    }
    
    func testThatStoreIsSetUp() {
        XCTAssertNotNil(store, "хранилища не существует")
    }
    
    func testControllerHasTableViewPropertySetAfterLoading() {
        
        let _ = stationsViewController.view
        
        XCTAssertTrue(stationsViewController.tableView != nil, "Таблица должна быть установлена")
 
    }
    
    func testControllerFetchedDataCorrectly() {
        
        let _ = stationsViewController.view
        stationsViewController.chosenRoute = route.From
        
        GZ_CityManager.getAllCitiesFrom(stationsViewController.citiesOffset, count: stationsViewController.citiesCount, success: {
            
            XCTAssertEqual(self.stationsViewController.fetchedResultsController.fetchedObjects?.count, 5, "Должно быть загружено 5 городов!")
            
            }) { 
                
        }
        
        
    }
    
}
