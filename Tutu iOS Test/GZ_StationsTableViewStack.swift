//
//  GZ_StationsTableViewStack.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Table view delegate
extension GZ_StationsTableViewController
{
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        calculateCountriesIndexTitles(section)
        if ( (shouldShowCountryForIndex.valueForKey("\(section)") as! Bool) == true )
        {
            return 44.0
        }
        return 22.0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cityModel = fetchedResultsController.fetchedObjects![section] as! GZ_City
        
        // специальный хедер со страной и городом
        if ( (shouldShowCountryForIndex.valueForKey("\(section)") as! Bool) == true )
        {
            let sectionCountryHeaderView = NSBundle.mainBundle().loadNibNamed("GZ_CountryHeaderView",
                                                                       owner: self,
                                                                       options: nil)[0] as! GZ_CountryHeaderView
            sectionCountryHeaderView.configureSelfWithDataModel(cityModel.countryTitle)
            
            
            let sectionCityHeaderView = NSBundle.mainBundle().loadNibNamed("GZ_CityHeaderView",
                                                                       owner: self,
                                                                       options: nil)[0] as! GZ_CityHeaderView
            sectionCityHeaderView.configureSelfWithDataModel(cityModel.cityTitle)
            sectionCityHeaderView.frame.origin.y += sectionCountryHeaderView.frame.height
            
            let connectedView = UIView()
            connectedView.addSubview(sectionCountryHeaderView)
            connectedView.addSubview(sectionCityHeaderView)
            return connectedView
        }
        else
        {
            let cityModel = fetchedResultsController.fetchedObjects![section] as! GZ_City
            let sectionCityHeaderView = NSBundle.mainBundle().loadNibNamed("GZ_CityHeaderView",
                                                                       owner: self,
                                                                       options: nil)[0] as! GZ_CityHeaderView
            sectionCityHeaderView.configureSelfWithDataModel(cityModel.cityTitle)
            return sectionCityHeaderView
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        selectedIndexPath = indexPath
        self.performSegueWithIdentifier("fromStationsToDetail", sender: self)
    }
}

// MARK: - Table view data source
extension GZ_StationsTableViewController
{
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // количество секций равно количеству городов
        let info = self.fetchedResultsController.sections![0]
        return info.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // количество рядов в секции равно количеству станций для данного города
        let cityModel = fetchedResultsController.fetchedObjects![section] as! GZ_City
        
        // в случае поиска фильтруем станции города
        if ( self.stationsSubstringFilter != "" )
        {
            return filterCityStations(cityModel, section: section).count
        }
        
        return cityModel.stations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if ((indexPath.section + 1) % self.citiesCount == 0
            && (indexPath.section + 1) == self.citiesOffset
            && self.dataIsParsing == false)
        {
            if ( self.stationsSubstringFilter != "" )
            {
                parseAndInsertNewCitiesBySubstring(self.stationsSubstringFilter)
            }
            else
            {
                parseAndInsertNewCities()
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("stationTableViewCell", forIndexPath: indexPath) as! GZ_StationTableViewCell
        // если идет поиск, то взять станции из отфильтрованного массива станций для данного города
        if ( self.stationsSubstringFilter != "" && self.filteredStations.count != 0 )
        {
            let stations = self.filteredStations.valueForKey("\(indexPath.section)") as! [GZ_Station]
            let station = stations[indexPath.row]
            cell.configureSelfWithData(station.stationTitle)
            return cell
        }
        
        let cityModel = fetchedResultsController.fetchedObjects![indexPath.section] as! GZ_City
        let station = cityModel.stations.allObjects[indexPath.row] as! GZ_Station
        cell.configureSelfWithData(station.stationTitle)
        return cell
    }
}