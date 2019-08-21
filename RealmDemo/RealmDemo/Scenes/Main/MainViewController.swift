//
//  ViewController.swift
//  RealmDemo
//
//  Created by nguyen.duc.huyb on 6/3/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit
import RealmSwift

final class MainViewController: UIViewController {
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var ageTextField: UITextField!
    @IBOutlet private weak var petNameTextField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    
    fileprivate var users: Results<User>?
    private var notificationToken: NotificationToken?
    private var isAscending: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        users = RealmService.shared.fetch(User.self)
        
        notificationToken = RealmService.shared.realmDB?.observe({ [unowned self] (notification, realm) in
            self.tableView.reloadData()
        })
        
        //Handle Realm Error
        RealmService.shared.observeRealmErrors(in: self) { [weak self] (error) in
            guard let self = self else { return }
            self.showAlert(message: error?.localizedDescription ?? "no error detected")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    deinit {
        notificationToken?.invalidate()
        RealmService.shared.stopObservingErrors(in: self)
    }
    
    @IBAction private func handleSaveButtonTapped(_ sender: Any) {
        guard let userName = usernameTextField.text,
            let age = ageTextField.text,
            let petName = petNameTextField.text else { return }

        let newPet = Pet(name: petName)
        let newUser = User(name: userName, age: Int(age), pet: newPet)
        RealmService.shared.create(newPet)
        RealmService.shared.create(newUser)
    }
    
    @IBAction func handleFilterButtonTapped(_ sender: Any) {
        showInputDialog(title: "Filtering under age",
                        subtitle: "Please enter the age below.",
                        actionTitle: "Apply",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "New age",
                        inputKeyboardType: .numberPad)
        { [weak self] (input: String?) in
            guard let self = self,
                let input = input,
                input != "" else { return }
            self.users = RealmService.shared.fetch(User.self)?.filter("age < " + input)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func handleSortButtonTapped(_ sender: Any) {
        isAscending = !isAscending
        guard users?.count != 0 else { return }
        users = users?.sorted(byKeyPath: "fullname", ascending: isAscending)
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        guard let userData = users?[indexPath.row] else { return TableViewCell() }
        cell.configCell(userData: userData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return }
        guard let userData = users?[indexPath.row] else { return }
        vc.userData = userData
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        guard let userData = users?[indexPath.row] else { return }
        RealmService.shared.delete(userData)
    }
}
