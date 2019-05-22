//
//  OrderViewController.swift
//  InfoManager
//
//  Created by mac on 4/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import CoreData
class OrderViewController: UIViewController, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    var order: Order?
    var table = NSFetchedResultsController<NSFetchRequestResult>()
    
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
    
    @IBAction func AddRowOfOrder(_ sender: Any) {
        if let order = order {
            let newRowOfOrder = RowOfOrder()
            newRowOfOrder.order = order
            performSegue(withIdentifier: "orderToRowOfOrder", sender: newRowOfOrder)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
            table = Order.getRowsOfOrder(order)
            table.delegate = self
            
            do {
                try table.performFetch()
            } catch {
                print(error.localizedDescription)
            }
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
        switch segue.identifier! {
        case "orderToCustomers":
            let viewController = segue.destination as! CustomersTableViewController
            viewController.didSelect = { [unowned self] customer in
                if let customer = customer {
                    self.order?.customer = customer
                    self.textFieldCustomer.text = customer.name!
                }
            }
        case "orderToRowOfOrder":
            let controller = segue.destination as! RowOfOrderViewController
            controller.rowOfOrder = sender as? RowOfOrder
        default:
            break
        }
    }
    // MARK: - Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = table.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowOfOrder = table.object(at: indexPath) as! RowOfOrder
        let cell = UITableViewCell()
        let nameOfService = (rowOfOrder.service == nil) ? "-- Unknown --" : (rowOfOrder.service!.name!)
        cell.textLabel?.text = nameOfService + " - " + String(rowOfOrder.sum)
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = table.object(at: indexPath) as! NSManagedObject
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowOfOrder = table.object(at: indexPath) as! RowOfOrder
        performSegue(withIdentifier: "orderToRowOfOrder", sender: rowOfOrder)
    }
    
    // MARK: - Fetched Results Controller Delegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let rowOfOrder = table.object(at: indexPath) as! RowOfOrder
                let cell = tableView.cellForRow(at: indexPath)!
                let nameOfService = (rowOfOrder.service == nil) ? "-- Unknown --" : (rowOfOrder.service!.name!)
                cell.textLabel?.text = nameOfService + " - " + String(rowOfOrder.sum)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

}
