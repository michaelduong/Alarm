//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Michael Duong on 1/22/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController, SwitchTableViewCellDelegate, AlarmScheduler {
    
    func switchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let alarm = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleEnabled(for: alarm)
        
        if alarm.enabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
        
        tableView.reloadData()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmsCell", for: indexPath) as? SwitchTableViewCell
        
        cell?.delegate = self
        
        cell?.alarm = AlarmController.shared.alarms[indexPath.row]
        
        return cell ?? UITableViewCell()
    }
        

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmtoDelete = AlarmController.shared.alarms[indexPath.row]
            
            AlarmController.shared.delete(alarm: alarmtoDelete)
            cancelUserNotifications(for: alarmtoDelete)
            tableView.reloadData()
        }
    }
    


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        if segue.identifier == "toAlarmDetails" {
            // Pass the selected object to the new view controller.
            guard let destination = segue.destination as? AlarmDetailTableViewController else { return }
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let alarmId = AlarmController.shared.alarms[indexPath.row]
            
            destination.alarm = alarmId
            
        }
    }
}
