//
//  OrderViewController.swift
//  InfoManager
//
//  Created by mac on 4/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {

    var order: Order?

    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var textFieldCustomer: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchMade: UISwitch!
    @IBOutlet weak var switchPaid: UISwitch!
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        saveOrder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choiceCustomer(_ sender: Any) {
        performSegue(withIdentifier: "orderToCustomers", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create object
        if order == nil {
            order = Order()
            order?.date = NSDate()
        }
        
        // Reading object to form
        if let order = order {
            dataPicker.date = order.date! as Date
            switchMade.isOn = order.made
            switchPaid.isOn = order.paid
            textFieldCustomer.text = order.customer?.name
        }
    }
    
    // Saving object to Model
    func saveOrder() {
        if let order = order { // проверка если объект существует
            order.date = dataPicker.date as NSDate
            order.made = switchMade.isOn
            order.paid = switchPaid.isOn
            CoreDataManager.instance.saveContext()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "orderToCustomers" {
            let viewController = segue.destination as! CustomersTableViewController
            viewController.didSelect = { [unowned self] customer in
                if let customer = customer {
                    self.order?.customer = customer
                    self.textFieldCustomer.text = customer.name!
                }
            }
        }
    }


}
