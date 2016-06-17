//
//  GZ_DATA_WRAPPER.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation
import SwiftyJSON

class GZ_DATA_WRAPPER
{
    // MARK: - общая процедура парсинга JSON
    private class func genericJSONParser ( data : NSData? ,
                                           success : ( data : NSArray? ) -> Void ,
                                           failure : ( errorCode : Int ) -> Void) -> Void
    {
        if ( data != nil )
        {
            let result = JSON(data: data!, options: NSJSONReadingOptions(), error: nil)
            if ( result != nil
                    && (result.arrayValue.count != 0 || result.dictionaryValue.count != 0) )
            {
                if ( result.arrayValue.count != 0 )
                {
                    success ( data: result.arrayObject )
                }
                else if ( result.dictionaryValue.count != 0 )
                {
                    let resultDictionary = NSDictionary(dictionary: result.dictionaryObject!)
                    success(data: [resultDictionary] )
                }
            }
            else
            {
                failure ( errorCode: 0 )
            }
            //print("raw data : \(NSString(data: data!, encoding: NSUTF8StringEncoding))")
        }
        else
        {
            failure ( errorCode: 0 )
        }
        
    }
}

// MARK: - Вернуть сериализованный объект со всеми городами отправления
extension GZ_DATA_WRAPPER
{
    class func returnCitiesFromData (success : ( data : NSArray? ) -> Void ,
                                 failure : ( errorCode : Int ) -> Void ) -> Void
    {
        let fileName = NSBundle.mainBundle().pathForResource("citiesFrom", ofType: "json")
        if (fileName != nil)
        {
            let data = NSData(contentsOfFile: fileName!)
            genericJSONParser ( data ,
                                success: success ,
                                failure: failure)
        }
        else
        {
            failure(errorCode: 0)
        }
    }
}

// MARK: - Вернуть сериализованный объект со всеми городами прибытия
extension GZ_DATA_WRAPPER
{
    class func returnCitiesToData (success : ( data : NSArray? ) -> Void ,
                                     failure : ( errorCode : Int ) -> Void ) -> Void
    {
        let fileName = NSBundle.mainBundle().pathForResource("citiesTo", ofType: "json")
        if (fileName != nil)
        {
            let data = NSData(contentsOfFile: fileName!)
            genericJSONParser ( data ,
                                success: success ,
                                failure: failure)
        }
        else
        {
            failure(errorCode: 0)
        }
    }
}