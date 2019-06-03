//
//  DetailViewController.swift
//  RealmDemo
//
//  Created by nguyen.duc.huyb on 6/4/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var userNameLabel: UITextField!
    @IBOutlet private weak var ageLabel: UITextField!
    @IBOutlet private weak var petNameLabel: UITextField!
    
    var userData: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction private func handleIUpdateButtonTapped(_ sender: Any) {
        guard let userName = userNameLabel.text,
            let age = ageLabel.text,
            let petName = petNameLabel.text,
            let pet = userData.pet else { return }

        let dictPet: [String: Any] = ["name": petName]
        let dictUser: [String: Any] = ["fullname": userName, "pet": pet, "age": age]
        RealmService.shared.update(pet, with: dictPet)
        RealmService.shared.update(userData, with: dictUser)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func handleDeleteButtonTapped(_ sender: Any) {
        RealmService.shared.delete(userData)
        navigationController?.popViewController(animated: true)
    }
}
