//
//  CustomersTableViewController.swift
//  InfoManager
//
//  Created by mac on 4/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import CoreData

class CustomersTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    typealias Select = (Customer?) -> ()
    var didSelect: Select?
    
    @IBAction func AddCustomer(_ sender: Any) {
        performSegue(withIdentifier: "customersToCustomer", sender: nil)
    }
    
    var fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "Customer", keyForSort: "name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customer = fetchedResultsController.object(at: indexPath as IndexPath) as! Customer
        let cell = UITableViewCell()
        cell.textLabel?.text = customer.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = fetchedResultsController.object(at: indexPath) as? Customer
        if let dSelect = self.didSelect {
            dSelect(customer)
            dismiss(animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "customersToCustomer", sender: customer)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customersToCustomer" {
            let controller = segue.destination as! CustomerViewController
            controller.customer = sender as? Customer
        }
    }
    
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
            if let indexPath = newIndexPath {
                // получаем по индексу строку и обновляем данные в таблице
                let customer = fetchedResultsController.object(at: indexPath) as! Customer
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = customer.name
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // получаем текущий объект по индексу
            let managedObject = fetchedResultsController.object(at: indexPath) as! Customer
            // передаем объект контексту и удаляем его/сохраняем контекст
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
}

