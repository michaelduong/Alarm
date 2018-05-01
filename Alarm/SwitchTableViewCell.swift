//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Michael Duong on 1/22/18.
//  Copyright © 2018 Turnt Labs. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    var alarm: Alarm? {
        didSet {
            updateViews()
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchValueChanged(cell: self)
    }

    
    func updateViews(){
        
        guard let alarm = alarm else { return }
        nameLabel.text = alarm.name
        timeLabel.text = alarm.fireTimeAsString
        alarmSwitch.isOn = alarm.enabled
    }

}
