//
//  ServiceViewController.swift
//  InfoManager
//
//  Created by mac on 4/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController {
   
    var services: Services?
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if saveServices() {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Reading object
        if let services = services {
            nameTextField.text = services.name
            infoTextField.text = services.info
        }
    }
    
    func saveServices() -> Bool {
        if nameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Validation Error", message: "Input the name of the Services", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
        if services == nil {
            services = Services()
        }
        
        if let services = services {
            services.name = nameTextField.text
            services.info = infoTextField.text
            CoreDataManager.instance.saveContext()
        }
        return true
    }
}
