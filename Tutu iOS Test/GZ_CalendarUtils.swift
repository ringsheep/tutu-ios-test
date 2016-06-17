//
//  GZ_CalendarUtils.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/16/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation

class GZ_CalendarUtils
{
    static let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
}


extension GZ_CalendarUtils
{
    // конвертация номера месяца в название
    private class func russianMonthConverter ( input : Int ) -> String
    {
        let monthNames = ["января" , "февраля" , "марта" , "апреля" , "мая" , "июня" , "июля" , "августа" , "сентября" , "октября" , "ноября" , "декабря" ]
        return monthNames [ input - 1 ]
    }
    
    // конвертация английских дней в русские
    private class func russianDayName ( input : String ) -> String
    {
        let daysNames = ["понедельник" : "пн" , "вторник" : "вт" , "среда" : "ср" , "четверг" : "чт" , "пятница" : "пт" , "суббота" : "сб" , "воскресенье" : "вс" ]
        let daysNamesENG = ["Monday" : "пн" , "Tuesday" : "вт" , "Wednesday" : "ср" , "Thursday" : "чт" , "Friday" : "пт" , "Saturday" : "сб" , "Sunday" : "вс" ]
        
        
        if let name = daysNames [ input ]
        {
            return name
        }
        else
        {
            if let name = daysNamesENG [ input ]
            {
                return name
            }
            else
            {
                return "n/a"
            }
        }
    }
    
    // преобразовать NSDate в читабельную строку
    class func convertDateToReadableString ( date : NSDate ) -> String
    {
        let dayNumber = String((calendar?.component(NSCalendarUnit.Day, fromDate: date))!)
        let monthNumber = (calendar?.component(NSCalendarUnit.Month, fromDate: date))!
        let month = russianMonthConverter(monthNumber)
        let resultString = dayNumber + " " + month
        return resultString
    }
}