//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Michael Duong on 1/22/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmName: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = alarmName.text,
            let thisMorningMidnight = DateHelper.thisMorningAtMidnight else { return }
        let timeIntervalSinceMidnight = datePicker.date.timeIntervalSince(thisMorningMidnight)
        
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
            cancelUserNotifications(for: alarm)
        } else {
            let alarm = AlarmController.shared.addAlarm(fireTimeFromMidnight: timeIntervalSinceMidnight, name: title)
            self.alarm = alarm
            scheduleUserNotifications(for: alarm)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        guard let alarm = alarm else { return }
        AlarmController.shared.toggleEnabled(for: alarm)
        if alarm.enabled {
        scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        updateViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    var alarm: Alarm? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    
    private func updateViews() {
        guard let alarm = alarm, let thisMorningAtMidnight = DateHelper.thisMorningAtMidnight, isViewLoaded else {
            enableButton.isHidden = true
            return
        }

        datePicker.setDate(Date(timeInterval: alarm.fireTimeFromMidnight, since: thisMorningAtMidnight), animated: false)
        
            alarmName.text = alarm.name
        
            enableButton.isHidden = false
            if alarm.enabled {
            enableButton.setTitle("Disable", for: UIControlState())
            enableButton.setTitleColor(.white, for: UIControlState())
            enableButton.backgroundColor = .red
        }
            else {
            enableButton.setTitle("Enable", for: UIControlState())
            enableButton.setTitleColor(.blue, for: UIControlState())
            enableButton.backgroundColor = .gray
        }
        
        self.title = alarm.name
    }
}
