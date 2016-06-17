//
//  GZ_DatePickerViewController.swift
//  Tutu iOS Test
//
//  Created by George Zinyakov on 6/17/16.
//  Copyright © 2016 George Zinyakov. All rights reserved.
//

import UIKit

class GZ_DatePickerViewController: UIViewController
{
    var selectedDate:NSDate?
}

// MARK: View Controller life cycle
extension GZ_DatePickerViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Выбор даты"
        setUpDatePicker()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - настройка датапикера
// спасибо туту.ру за классную библиотеку)
extension GZ_DatePickerViewController
{
    private func setUpDatePicker()
    {
        let datePickerView = RSDFDatePickerView(frame: self.view.bounds)
        datePickerView.delegate = self
        datePickerView.dataSource = self
        self.view.addSubview(datePickerView)
    }
}

// MARK: - делегат датапикера
extension GZ_DatePickerViewController : RSDFDatePickerViewDelegate, RSDFDatePickerViewDataSource
{
    func datePickerView(view: RSDFDatePickerView, didSelectDate date: NSDate)
    {
        selectedDate = date
        NSNotificationCenter.defaultCenter().postNotificationName(GZ_Const.kUserSelectedDate, object: self)
        dispatch_async(dispatch_get_main_queue()) { 
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
}