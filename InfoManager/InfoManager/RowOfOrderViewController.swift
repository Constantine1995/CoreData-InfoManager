//
//  RowOfOrderViewController.swift
//  InfoManager
//
//  Created by mac on 4/12/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

class RowOfOrderViewController: UIViewController {
    
    var rowOfOrder: RowOfOrder?
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        SaveRow()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choiceService(_ sender: Any) {
        performSegue(withIdentifier: "rowOfOrderToServices", sender: nil)
    }
    
    @IBOutlet weak var TextFieldService: UITextField!
    @IBOutlet weak var TextFieldSum: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let rowOfOrder = rowOfOrder {
            TextFieldService.text = rowOfOrder.service?.name
            TextFieldSum.text = String(rowOfOrder.sum)
        } else {
            rowOfOrder = RowOfOrder()
        }
    }
    
    func SaveRow() {
        if let rowOfOrder = rowOfOrder {
            rowOfOrder.sum = Float(TextFieldSum.text!)!
            CoreDataManager.instance.saveContext()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "rowOfOrderToServices" {
            let controller = segue.destination as! ServicesTableTableViewController
            controller.didSelect = {[unowned self] (service) in
                if let service = service {
                    self.rowOfOrder!.service = service
                    self.TextFieldService.text = service.name
                }
            }
        }
    }
}
