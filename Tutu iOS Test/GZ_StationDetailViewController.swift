//
//  GZ_StationDetailViewController.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/15/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit
import MapKit

class GZ_StationDetailViewController: UIViewController {

    var stationToDisplay:GZ_Station?
    var stationRoute:route?
    
    @IBOutlet weak var stationTitleLabel: UILabel!
    @IBOutlet weak var stationDescriptionLabel: UILabel!
    @IBOutlet weak var stationLocationMap: MKMapView!
    @IBOutlet weak var stationSelectButton: UIButton!
    @IBAction func stationSelectButtonPressed(sender: AnyObject)
    {
        NSNotificationCenter.defaultCenter().postNotificationName(GZ_Const.kUserSelectedStation, object: self)
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController?.popToRootViewControllerAnimated(true)
        })
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        setUpView()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - настройка вида
extension GZ_StationDetailViewController
{
    private func setUpView()
    {
        self.title = "О станции"
        stationTitleLabel.text = stationToDisplay?.stationTitle
        stationDescriptionLabel.text = stationToDisplay?.countryTitle
        if ( stationToDisplay?.regionTitle != "" )
        {
            stationDescriptionLabel.text?.appendContentsOf( ", " + (stationToDisplay?.regionTitle)! )
        }
        if ( stationToDisplay?.districtTitle != "" )
        {
            stationDescriptionLabel.text?.appendContentsOf( ", " + (stationToDisplay?.districtTitle)! )
        }
        if ( stationToDisplay?.cityTitle != "" )
        {
            stationDescriptionLabel.text?.appendContentsOf( ", " + (stationToDisplay?.cityTitle)! )
        }
        setUpMap()
    }
    
    private func setUpMap()
    {
        let initialLocation = CLLocation(latitude: stationToDisplay!.latitude, longitude: stationToDisplay!.longitude)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        stationLocationMap.setRegion(coordinateRegion, animated: true)
        let stationAnnotation = GZ_MapPin(latitude: stationToDisplay!.latitude, longitude: stationToDisplay!.longitude)
        stationLocationMap.addAnnotation(stationAnnotation)
        stationLocationMap.userInteractionEnabled = false
        stationLocationMap.zoomEnabled = false
        stationLocationMap.scrollEnabled = false
    }
}