//
//  GZ_StationsTableViewController.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import CoreData

class GZ_StationsTableViewController: UITableViewController
{
    var chosenRoute:route?
    var shouldShowCountryForIndex = NSMutableDictionary()
    var searchController : UISearchController!
    var activityIndicator : UIActivityIndicatorView?
    var dimView : UIView?
    var dataIsParsing = false
    var searchStarted = false
    var stationsSubstringFilter = ""
    var filteredStations = NSMutableDictionary()
    var selectedIndexPath:NSIndexPath?
    
    let citiesCount = 10
    var citiesOffset = 0
    
    lazy var fetchedResultsController: NSFetchedResultsController =
        {
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).citiesNonPersistentManagedObjectContext
            
            let entity = NSEntityDescription.entityForName("GZ_City", inManagedObjectContext: managedObjectContext)
            let sortByCountry = NSSortDescriptor(key: "countryTitle", ascending: true)
            let sortByCity = NSSortDescriptor(key: "cityTitle", ascending: true)
            let req = NSFetchRequest()
            req.entity = entity
            req.sortDescriptors = [sortByCountry, sortByCity]
            
            let aFetchedResultsController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            
            var e: NSError?
            do {
                try aFetchedResultsController.performFetch()
            } catch var error as NSError {
                e = error
                print("fetch error: \(e!.localizedDescription)")
            } catch {
                fatalError()
            }
            
            return aFetchedResultsController
    }()
}

// MARK: - View controller life cycle
extension GZ_StationsTableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpData()
        setUpView()
        setUpSearchBar()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

// MARK: - процедуры настройки представления
extension GZ_StationsTableViewController
{
    private func setUpView()
    {
        if (chosenRoute == route.From)
        {
            self.title = "Станция отправления"
        }
        else if ( chosenRoute == route.To )
        {
            self.title = "Станция прибытия"
        }
        self.tableView.registerNib(UINib (nibName: "GZ_StationTableViewCell", bundle: nil), forCellReuseIdentifier: "stationTableViewCell")
    }
}

// MARK: - процедуры настройки данных
extension GZ_StationsTableViewController
{
    private func setUpData()
    {
        guard (chosenRoute != nil ) else
        {
            return
        }
        // в зависимости от выбранного пункта конфигурации точки отправления или прибытия, загрузить соответствующие данные
        clearContext()
        dataIsParsing = true
        addActivityIndicator()
        if ( chosenRoute == route.From)
        {
            GZ_CityManager.getAllCitiesFrom(citiesOffset, count: citiesCount, success: {
                
                // после записи данных в контекст, отфильтровать по нужному нам флагу направления пути и обновить представление, а также запретить парсить тот же json второй раз
                self.dataIsParsing = false
                self.citiesOffset += self.citiesCount
                self.setDefaultPredicate()
                self.removeActivityIndicator()
                self.refreshData()
                
                }, failure: { 
                    
                    self.dataIsParsing = false
                    self.removeActivityIndicator()
                    self.refreshData()
                    
            })
        }
        else if ( chosenRoute == route.To)
        {
            GZ_CityManager.getAllCitiesTo(citiesOffset, count: citiesCount, success: {
                
                self.dataIsParsing = false
                self.citiesOffset += self.citiesCount
                self.setDefaultPredicate()
                self.removeActivityIndicator()
                self.refreshData()
                
                }, failure: { 
                    
                    self.dataIsParsing = false
                    self.removeActivityIndicator()
                    self.refreshData()
                    
            })
        }
        else
        {
            self.removeActivityIndicator()
            self.refreshData()
        }
        
    }
    
    // добавить новые города с новым отступом
    func parseAndInsertNewCities()
    {
        self.dataIsParsing = true
        if ( chosenRoute == route.From )
        {
            GZ_CityManager.getAllCitiesFrom(citiesOffset, count: citiesCount, success: {
                
                self.dataIsParsing = false
                self.citiesOffset += self.citiesCount
                self.setDefaultPredicate()
                self.refreshData()
                
                }, failure: {
                    
                    self.dataIsParsing = false
                    self.refreshData()
                    
            })
        }
        else if ( chosenRoute == route.To )
        {
            GZ_CityManager.getAllCitiesTo(citiesOffset, count: citiesCount, success: {
                
                self.dataIsParsing = false
                self.citiesOffset += self.citiesCount
                self.setDefaultPredicate()
                self.refreshData()
                
                }, failure: {
                    
                    self.dataIsParsing = false
                    self.refreshData()
                    
            })
        }
        else
        {
            self.refreshData()
        }
    }
    
    // добавить новые города с новым отступом, с фильтрацией по поисковой подстроке
    func parseAndInsertNewCitiesBySubstring(searchText: String)
    {
        self.dataIsParsing = true
        addActivityIndicator()
        if ( chosenRoute == route.From )
        {
            GZ_CityManager.getAllCitiesFromByStationSubstring(searchText,
                                                            offset: citiesOffset,
                                                            count: citiesCount,
                                                            success: {
                                                                
                                                                self.dataIsParsing = false
                                                                self.citiesOffset += self.citiesCount
                                                                self.removeActivityIndicator()
                                                                self.setDefaultPredicate()
                                                                self.refreshData()
                }, failure: {
                    
                    self.dataIsParsing = false
                    self.removeActivityIndicator()
                    self.refreshData()
                    
            })
        }
        else if ( chosenRoute == route.To )
        {
            GZ_CityManager.getAllCitiesToByStationSubstring(searchText,
                                                            offset: citiesOffset,
                                                            count: citiesCount,
                                                            success: {
                
                                                                self.dataIsParsing = false
                                                                self.citiesOffset += self.citiesCount
                                                                self.removeActivityIndicator()
                                                                self.setDefaultPredicate()
                                                                self.refreshData()
                }, failure: { 
                    
                    self.dataIsParsing = false
                    self.removeActivityIndicator()
                    self.refreshData()
                    
            })
        }
        else
        {
            self.removeActivityIndicator()
            self.refreshData()
        }
    }
    
    // возвращаем дефолтный предикат для возврату к общей ленте станций
    private func setDefaultPredicate()
    {
        if (chosenRoute == route.From)
        {
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "routingFrom = YES")
        }
        else if (chosenRoute == route.To)
        {
            self.fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "routingTo = YES")
        }
        try? self.fetchedResultsController.performFetch()
        print("в контексте \(self.fetchedResultsController.fetchedObjects?.count) городов")
        print("offset \(self.citiesOffset)")
    }
    
    // очистка контекста. используется при начале поиска, чтобы очистить предыдущие результаты и данные
    private func clearContext()
    {
        let fetchRequest = NSFetchRequest(entityName: "GZ_City")
        fetchRequest.includesPropertyValues = false
        let cities = try? self.fetchedResultsController.managedObjectContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        for city in cities! {
            self.fetchedResultsController.managedObjectContext.deleteObject(city)
        }
        try? self.fetchedResultsController.performFetch()
    }
}

// MARK: - методы работы с поиском
extension GZ_StationsTableViewController: UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating
{
    private func setUpSearchBar()
    {
        self.searchController =
            UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController?.searchBar.sizeToFit()
        self.searchController?.searchBar.tintColor = UIColor.whiteColor()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.definesPresentationContext = true
        self.extendedLayoutIncludesOpaqueBars = true
        
        tableView.tableHeaderView = self.searchController.searchBar
    }
    
    // процедура поиска по подстроке
    private func filterContentForSearchText(searchText: String)
    {
        self.citiesOffset = 0
        clearContext()
        parseAndInsertNewCitiesBySubstring(searchText)
        
        self.stationsSubstringFilter = searchText
        setDefaultPredicate()
        self.refreshData()
    }
    
    // производим поиск после 2х секунд после ввода текста в серч бар
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchTerm = searchController.searchBar.text else
        {
            return
        }
        
        // если только выбрано, то не производить действий
        if ( searchTerm == "" && self.stationsSubstringFilter == "" )
        {
            return
        }
            // если опустошено поле, то произвести сброс
        else if ( searchTerm == "" && self.stationsSubstringFilter != "" )
        {
            dismissSearchResultsAndShowDefault()
            return
        }
        
        if ( searchStarted == false )
        {
            self.searchStarted = true
            let secondsToWait:Double = 2
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(secondsToWait * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.stationsSubstringFilter = self.searchController.searchBar.text!
                self.filterContentForSearchText(self.stationsSubstringFilter)
                self.searchStarted = false
            }
        }
    }
    
    // а также после нажатия кнопки поиска
    func searchBarTextDidEndEditing(searchBar: UISearchBar)
    {
        guard ( self.stationsSubstringFilter != "" ) else
        {
            dismissSearchResultsAndShowDefault()
            return
        }
        self.filterContentForSearchText(self.stationsSubstringFilter)
    }
    
    // возвращаемся обратно при нажатии на кнопку отмены, а также если ничего не введено
    func willDismissSearchController(searchController: UISearchController)
    {
        dismissSearchResultsAndShowDefault()
    }
    
    // сброс в дефолтное состояние с общим списком городов
    func dismissSearchResultsAndShowDefault()
    {
        self.stationsSubstringFilter = ""
        self.clearContext()
        self.citiesOffset = 0
        self.setUpData()
    }
    
    // ручная фильтрация станций в городах - поиск и frc фильтруют только по городам, а целевой объект ниже по иерархии
    func filterCityStations( cityModel : GZ_City , section : Int ) -> [GZ_Station]
    {
        let sortedArray = (cityModel.stations.filter({ (station) -> Bool in
            return (station as! GZ_Station).stationTitle.lowercaseString.rangeOfString(self.stationsSubstringFilter.lowercaseString) != nil
        })) as! [GZ_Station]
        self.filteredStations.setValue(sortedArray, forKey: "\(section)")
        return sortedArray
    }
    
}

// MARK: - Navigation
extension GZ_StationsTableViewController
{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if ( segue.identifier == "fromStationsToDetail" )
        {
            let cityModel = fetchedResultsController.fetchedObjects![selectedIndexPath!.section] as! GZ_City
            let station = cityModel.stations.allObjects[selectedIndexPath!.row] as! GZ_Station
            
            let destinationViewController = segue.destinationViewController as! GZ_StationDetailViewController
            destinationViewController.stationToDisplay = station
            destinationViewController.stationRoute = chosenRoute
        }
    }
}

// MARK: - процедуры активити индикатора
extension GZ_StationsTableViewController
{
    private func addActivityIndicator () -> Void
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            if ( self.activityIndicator == nil )
            {
                self.tableView.userInteractionEnabled = false
                
                self.activityIndicator = UIActivityIndicatorView()
                self.activityIndicator?.frame = CGRectMake(0.0, 0.0, 20.0, 20.0)
                self.activityIndicator?.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                self.activityIndicator?.center = self.view.center
                self.activityIndicator?.center.y -= 40
                self.activityIndicator!.startAnimating()
                self.view.addSubview(self.activityIndicator!)
                
                self.dimView = UIView()
                self.dimView?.frame = self.view.frame
                self.dimView?.backgroundColor = UIColor.grayColor()
                self.dimView?.alpha = 0.25
                self.view.addSubview(self.dimView!)
            }
            
        }
    }
    
    private func removeActivityIndicator () -> Void
    {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.tableView.userInteractionEnabled = true
            self.tableView.alpha = 1
            self.activityIndicator?.stopAnimating()
            self.activityIndicator?.removeFromSuperview()
            self.activityIndicator = nil
            
            self.dimView?.removeFromSuperview()
            self.dimView = nil
        }
    }
}

// MARK: - вспомогательные методы
extension GZ_StationsTableViewController
{
    private func refreshData()
    {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    // проверяем, не отличается ли у предыдущего города название страны. если да, или если предыдущего нет вовсе - вывести специальный хедер
    func calculateCountriesIndexTitles( section : Int )
    {
        guard ( section - 1 >= 0 ) else
        {
            shouldShowCountryForIndex.setValue(true, forKey: "\(0)")
            return
        }
        
        let cityModel = fetchedResultsController.fetchedObjects![section] as! GZ_City
        let previousCityModel = fetchedResultsController.fetchedObjects![section - 1] as! GZ_City
        
        if ( cityModel.countryTitle != previousCityModel.countryTitle )
        {
            shouldShowCountryForIndex.setValue(true, forKey: "\(section)")
        }
        else
        {
            shouldShowCountryForIndex.setValue(false, forKey: "\(section)")
        }
        
    }
}
