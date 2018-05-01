//
//  AlarmController.swift
//  Alarm
//
//  Created by Michael Duong on 1/22/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


class AlarmController {
    
    static var shared = AlarmController()
    
    var alarms: [Alarm] = []
    
    let mockAlarms: [Alarm] = {
        return [
            Alarm(fireTimeFromMidnight: 7, name: "Alarm One"),
            Alarm(fireTimeFromMidnight: 8, name: "Alarm Two"),
            Alarm(fireTimeFromMidnight: 9, name: "Alarm Three")
        ]
    }()
    
    init() {
        self.alarms = self.mockAlarms

        loadToPersistentStorage()
    }
    
    func addAlarm(fireTimeFromMidnight: TimeInterval, name: String) -> Alarm {
        let newAlarm = Alarm(fireTimeFromMidnight: fireTimeFromMidnight, name: name)
        alarms.append(newAlarm)
        
        saveToPersistentStorage()
        
        return newAlarm
        
    }
    
    func update(alarm: Alarm, fireTimeFromMidnight: TimeInterval, name: String) {
        alarm.fireTimeFromMidnight = fireTimeFromMidnight
        alarm.name = name
        
        saveToPersistentStorage()
    }
    
    func delete(alarm: Alarm) {
        guard let index = alarms.index(of: alarm) else { return }
        alarms.remove(at: index)
        
        saveToPersistentStorage()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        
        saveToPersistentStorage()
    }
    
    private func saveToPersistentStorage() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        NSKeyedArchiver.archiveRootObject(self.alarms, toFile: filePath)
    }
    
    private func loadToPersistentStorage() {
        guard let filePath = type(of: self).persistentAlarmsFilePath else { return }
        guard let alarms = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Alarm] else { return }
        self.alarms = alarms
    }
    
    static private var persistentAlarmsFilePath: String? {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        guard let documentsDirectory = directories.first as NSString? else { return nil }
        return documentsDirectory.appendingPathComponent("Alarms.plist")
    }
    
}

protocol AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Time's Up!"
        content.body = "Your alarm \(alarm.name) triggered."
        content.sound = UNNotificationSound.default()
        
        guard let fireDate = alarm.fireDate else { return }
        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .second], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        let identifier = alarm.uuid
        let notificationRequest = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Error adding notification request: \(error.localizedDescription)")
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}


