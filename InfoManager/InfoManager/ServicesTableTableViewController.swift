//
//  ServicesTableTableViewController.swift
//  InfoManager
//
//  Created by mac on 4/8/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import CoreData
class ServicesTableTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBAction func AddServices(_ sender: Any) {
        performSegue(withIdentifier: "servicesToService", sender: nil)
    }
    
    let fetchedResultController = CoreDataManager.instance.fetchedResultsController(entityName: "Services", keyForSort: "name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       fetchedResultController.delegate = self
        do {
           try fetchedResultController.performFetch()
        }
        catch {
            print(error)
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let services = fetchedResultController.object(at: indexPath as IndexPath) as! Services
        let cell = UITableViewCell()
        cell.textLabel?.text = services.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let services = fetchedResultController.object(at: indexPath) as! Services
        performSegue(withIdentifier: "servicesToService", sender: services)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "servicesToService" {
            let controller = segue.destination as! ServiceViewController
            controller.services = sender as? Services
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
                let services = fetchedResultController.object(at: indexPath) as! Services
                let cell = tableView.cellForRow(at: indexPath)
                cell!.textLabel?.text = services.name
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
            let managedObject = fetchedResultController.object(at: indexPath) as! Services
            // передаем объект контексту и удаляем его/сохраняем контекст
            CoreDataManager.instance.managedObjectContext.delete(managedObject)
            CoreDataManager.instance.saveContext()
        }
    }
}
