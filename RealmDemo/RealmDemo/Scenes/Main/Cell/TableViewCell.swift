//
//  TableViewCell.swift
//  RealmDemo
//
//  Created by nguyen.duc.huyb on 6/4/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class TableViewCell: UITableViewCell {
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userAgeLabel: UILabel!
    @IBOutlet private weak var petNameLabel: UILabel!
    
    func configCell(userData: User) {
        userNameLabel.text = userData.fullname
        petNameLabel.text = userData.pet?.name
        userAgeLabel.text = userData.ageString()
    }
}
