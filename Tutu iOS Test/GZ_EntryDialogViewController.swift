//
//  GZ_EntryDialogViewController.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import CoreData

class GZ_EntryDialogViewController: UIViewController {
    
    var chosenRoute:route?
    var nextCommitId:Int16?
    
    @IBOutlet weak var departureStationLabel: UILabel!
    @IBOutlet weak var arrivalStationLabel: UILabel!
    @IBOutlet weak var tripDateLabel: UILabel!
    @IBOutlet weak var departureStationButton: UIButton!
    @IBOutlet weak var arrivalStationButton: UIButton!
    @IBOutlet weak var tripDateButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var submitRequestButton: UIButton!
    
    @IBAction func departureStationButtonPressed(sender: AnyObject)
    {
        chosenRoute = route.From
        self.performSegueWithIdentifier("fromDialogToStations", sender: self)
    }
    
    @IBAction func arrivalStationButtonPressed(sender: AnyObject)
    {
        chosenRoute = route.To
        self.performSegueWithIdentifier("fromDialogToStations", sender: self)
    }
    
    @IBAction func tripDateButtonPressed(sender: AnyObject)
    {
        self.performSegueWithIdentifier("fromDialogToDataPicker", sender: self)
    }
    
    @IBAction func submitRequestButtonPressed(sender: AnyObject)
    {
        if ( fetchedResultsController.fetchedObjects?.count == 0 )
        {
            presentSimpleAlert("Невозможно сохранить", text: "Пожалуйста, выберите пункт отправления и прибытия, а также дату поездки.")
        }
        else
        {
            let commitModel = fetchedResultsController.fetchedObjects![0] as? GZ_UserCommit
            if ( commitModel?.date != nil && commitModel?.stationFrom != nil && commitModel?.stationTo != nil )
            {
                saveUserCommit()
            }
            else
            {
                presentSimpleAlert("Невозможно сохранить", text: "Пожалуйста, убедитесь, что вы заполнили все поля формы.")
            }
            
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController =
        {
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            
            let entity = NSEntityDescription.entityForName("GZ_UserCommit", inManagedObjectContext: managedObjectContext)
            let sort = NSSortDescriptor(key: "id", ascending: false)
            let req = NSFetchRequest()
            req.entity = entity
            req.sortDescriptors = [sort]
            
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

// MARK: - View Controller life cycle
extension GZ_EntryDialogViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewEmptyCommit()
        
        // событие, которое срабатывает в момент выбора станции, передает станцию обратно, записывает ее в персистентный контекст коммитов пользователя
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GZ_EntryDialogViewController.addSelectedStation), name: GZ_Const.kUserSelectedStation, object: nil)
        // аналогичное с датой
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GZ_EntryDialogViewController.addSelectedDate), name: GZ_Const.kUserSelectedDate, object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        //extendMainContentSize()
        initialiseView()
        updateView()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: GZ_Const.kUserSelectedStation, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - запись и вывод пришедших данных
extension GZ_EntryDialogViewController
{
    @objc private func addSelectedStation ( notification : NSNotification )
    {
        let detailViewController = (notification.object as! GZ_StationDetailViewController)
        let selectedStation = detailViewController.stationToDisplay
        let selectedRoute = detailViewController.stationRoute
        if ( selectedRoute == route.From )
        {
            GZ_CommitManager.createOrUpdateUserCommit(withId: nextCommitId!,
                                                      stationFrom: selectedStation,
                                                      stationTo: nil,
                                                      date: nil, success: {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), { 
                                                            self.updateView()
                                                        })
            }) {
                
            }
        }
        else if ( selectedRoute == route.To )
        {
            GZ_CommitManager.createOrUpdateUserCommit(withId: nextCommitId!,
                                                      stationFrom: nil,
                                                      stationTo: selectedStation,
                                                      date: nil, success: {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), {
                                                            self.updateView()
                                                        })
            }) {
                
            }
        }
        
    }
    
    @objc private func addSelectedDate ( notification : NSNotification )
    {
        let datePickerViewController = (notification.object as! GZ_DatePickerViewController)
        let date = datePickerViewController.selectedDate
        GZ_CommitManager.createOrUpdateUserCommit(withId: nextCommitId!,
                                                  stationFrom: nil,
                                                  stationTo: nil,
                                                  date: date, success: {
                                                    
                                                    dispatch_async(dispatch_get_main_queue(), {
                                                        self.updateView()
                                                    })
        }) {
            
        }
    }
    
    // создаем новый пустой коммит для заполнения
    private func createNewEmptyCommit()
    {
        nextCommitId = Int16( (self.fetchedResultsController.fetchedObjects?.count)! )
        GZ_CommitManager.createOrUpdateUserCommit(withId: nextCommitId!,
                                                  stationFrom: nil,
                                                  stationTo: nil,
                                                  date: nil, success: {
                                                    
        }) {
            
        }
    }
}

// MARK: - Navigation
extension GZ_EntryDialogViewController
{
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if ( segue.identifier == "fromDialogToStations" )
        {
            let destinationViewController = segue.destinationViewController as! GZ_StationsTableViewController
            destinationViewController.chosenRoute = chosenRoute!
        }
    }
}

//MARK: - настройка вида
extension GZ_EntryDialogViewController
{
    private func initialiseView()
    {
        self.departureStationButton.setTitle("Изменить", forState: UIControlState.Selected)
        self.departureStationButton.setTitle("Выбрать", forState: UIControlState.Normal)
        self.arrivalStationButton.setTitle("Изменить", forState: UIControlState.Selected)
        self.arrivalStationButton.setTitle("Выбрать", forState: UIControlState.Normal)
        self.tripDateButton.setTitle("Изменить", forState: UIControlState.Selected)
        self.tripDateButton.setTitle("Выбрать", forState: UIControlState.Normal)
        setDefaultView()
    }
    
    // берем активный коммит из контекста и выводим на ui все его заполненные поля, адаптируем кнопки
    private func updateView()
    {
        try? self.fetchedResultsController.performFetch()
        let commitModel = fetchedResultsController.fetchedObjects![0] as? GZ_UserCommit
        if ( commitModel?.stationFrom != nil )
        {
            self.departureStationLabel.text = commitModel?.stationFrom.stationTitle
            self.departureStationLabel.text?.appendContentsOf(", " + (commitModel?.stationFrom.cityTitle)!)
            self.departureStationButton.selected = true
        }
        if ( commitModel?.stationTo != nil )
        {
            self.arrivalStationLabel.text = commitModel?.stationTo.stationTitle
            self.arrivalStationLabel.text?.appendContentsOf(", " + (commitModel?.stationTo.cityTitle)!)
            self.arrivalStationButton.selected = true
        }
        if ( commitModel?.date != nil )
        {
            self.tripDateLabel.text = GZ_CalendarUtils.convertDateToReadableString((commitModel?.date)!)
            self.tripDateButton.selected = true
        }
    }
    
    // значения полей по умолчанию
    private func setDefaultView()
    {
        self.departureStationLabel.text = "Ваш пункт отправления"
        self.arrivalStationLabel.text = "Ваш пункт прибытия"
        self.tripDateLabel.text = "Ваша дата"
        self.departureStationButton.selected = false
        self.arrivalStationButton.selected = false
        self.tripDateButton.selected = false
    }
    
    // расширяем скролл в случае, если данные не влезли
    private func extendMainContentSize() -> Void
    {
        scrollView.contentSize = self.view.frame.size
        var buttomMaxPoint = submitRequestButton.frame.origin.y + submitRequestButton.frame.height
        
        if ( buttomMaxPoint <= self.view.frame.size.height )
        {
            buttomMaxPoint = self.view.frame.size.height + 5.0
        }
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, buttomMaxPoint )
    }
    
    private func presentSimpleAlert( title : String, text : String )
    {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Ок", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true) {
        }
    }
}

// MARK: - обработка нажатия кнопки заказа
extension GZ_EntryDialogViewController {
    // обработка заказа билета - сохранить билет в персистентный контекст
    private func saveUserCommit()
    {
        let alertController = UIAlertController(title: "Подтвердить", message: "Вы действительно хотите заказать билет?", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Да", style: .Default) { (action) in
            
            try? self.fetchedResultsController.managedObjectContext.save()
            self.createNewEmptyCommit()
            self.setDefaultView()
            self.presentSimpleAlert("Сохранено", text: "Ваша запись успешно сохранена")
            
        }
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Нет", style: .Cancel) { (action) in
            
        }
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
}
