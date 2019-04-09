//
//  OrdersTableViewController.swift
//  InfoManager
//
//  Created by mac on 4/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import CoreData
class OrdersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Order", keyForSort: "date")
    
    
    @IBAction func AddOrder(_ sender: Any) {
        performSegue(withIdentifier: "ordersToOrder", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResultsController.delegate = self
        // Reading object
        do {
            try fetchResultsController.performFetch()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let order = fetchResultsController.object(at: indexPath) as! Order
        configCell(cell, order)
        return cell
    }
    
    func configCell(_ cell: UITableViewCell, _ order: Order) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let nameOfCustomer = (order.customer == nil) ? "-- Unknown --" : (order.customer!.name!)
        cell.textLabel?.text = formatter.string(from: order.date! as Date) + "\t" + nameOfCustomer
    }
    
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let managedObject = fetchResultsController.object(at: indexPath) as! Order
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = fetchResultsController.object(at: indexPath) as? Order
        performSegue(withIdentifier: "ordersToOrder", sender: order)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ordersToOrder" {
            let controller = segue.destination as! OrderViewController
            controller.order = sender as? Order
        }
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
                let order = fetchResultsController.object(at: indexPath) as! Order
                let cell = tableView.cellForRow(at: indexPath)
                configCell(cell!, order)
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
