//
//  GZ_CityManager.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import CoreData

class GZ_CityManager
{
    // очередь парсинга списка городов
    static var citiesParsingOperationQueue = NSOperationQueue()
}

// MARK: - Получить все города отправления
extension GZ_CityManager
{
    class func getAllCitiesFrom ( offset : Int , count : Int , success : () -> Void , failure : () -> Void ) -> Void
    {
        citiesParsingOperationQueue.maxConcurrentOperationCount = 1
        citiesParsingOperationQueue.cancelAllOperations()
        
        let citiesFromParsingOperation = GZ_CitiesFromParsingOperation(offset: offset,
                                                                       count: count,
                                                                       success: {
            
            success()
            
            }) { (code) in
                
                print("error with code \(code)")
                failure()
                
        }
        citiesParsingOperationQueue.addOperation(citiesFromParsingOperation)
        
    }
    
    class func getAllCitiesFromByStationSubstring ( substring : String , offset : Int , count : Int , success : () -> Void , failure : () -> Void ) -> Void
    {
        citiesParsingOperationQueue.maxConcurrentOperationCount = 1
        citiesParsingOperationQueue.cancelAllOperations()
        
        let citiesFromParsingOperation = GZ_CitiesFromParsingOperation(substring: substring,
                                                                       offset: offset,
                                                                       count: count,
                                                                       success: {
                                                                        
                                                                        success()
                                                                        
        }) { (code) in
            
            print("error with code \(code)")
            failure()
            
        }
        citiesParsingOperationQueue.addOperation(citiesFromParsingOperation)
        
    }
}

// MARK: - Получить все города прибытия
extension GZ_CityManager
{
    class func getAllCitiesTo ( offset : Int , count : Int , success : () -> Void , failure : () -> Void ) -> Void
    {
        citiesParsingOperationQueue.maxConcurrentOperationCount = 1
        citiesParsingOperationQueue.cancelAllOperations()
        
        let citiesToParsingOperation = GZ_CitiesToParsingOperation( offset: offset,
                                                                    count: count,
                                                                    success: {
            
            success()
            
        }) { (code) in
            
            print("error with code \(code)")
            failure()
            
        }
        citiesParsingOperationQueue.addOperation(citiesToParsingOperation)
        
    }
    
    // поиск всех городов с фильтрацией станций по подстроке
    class func getAllCitiesToByStationSubstring ( substring : String , offset : Int , count : Int , success : () -> Void , failure : () -> Void ) -> Void
    {
        citiesParsingOperationQueue.maxConcurrentOperationCount = 1
        citiesParsingOperationQueue.cancelAllOperations()
        
        let citiesToParsingOperation = GZ_CitiesToParsingOperation( substring: substring,
                                                                    offset: offset,
                                                                    count: count,
                                                                    success: {
                                                                        
                                                                        success()
                                                                        
        }) { (code) in
            
            print("error with code \(code)")
            failure()
            
        }
        citiesParsingOperationQueue.addOperation(citiesToParsingOperation)
        
    }
}