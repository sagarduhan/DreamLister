//
//  MainVC.swift
//  DreamLister
//
//  Created by Sagar Duhan on 02/06/18.
//  Copyright © 2018 Sagar Duhan. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    var controller : NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        attemptFetch()
        //generateTestData()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell(cell: ItemCell, indexPath: NSIndexPath){
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let objs = controller.fetchedObjects, objs.count > 0{
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemsDetailsVC", sender: item)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemsDetailsVC"{
            let destination = segue.destination as? ItemsDetailsVC
            if let item = sender as? Item{
                destination?.itemToEdit = item
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections{
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections{
            return sections.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func attemptFetch(){
    
        let fetchRequest : NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segment.selectedSegmentIndex == 0{
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1{
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2{
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        self.controller = controller
    
        do{
            try controller.performFetch()
        }catch{
            let error = error as NSError
            print("\(error)")
        }
        
    }

    @IBAction func segmentChange(_ sender: Any) {
        attemptFetch()
        tableView.reloadData()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
            
        case.insert:
            if let indexpath = newIndexPath{
                tableView.insertRows(at: [indexpath], with: .fade)
            }
            break
        case.delete:
            if let indexpath = indexPath{
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            break
        case.update:
            if let indexpath = indexPath{
                let cell = tableView.cellForRow(at: indexpath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as! NSIndexPath)
            }
            break
        case.move:
            if let indexpath = indexPath{
                tableView.deleteRows(at: [indexpath], with: .fade)
            }
            if let indexpath = newIndexPath{
                tableView.insertRows(at: [indexpath], with: .fade)
            }
            break
            
        }
        
    }
    
    func generateTestData(){
        let item = Item(context: context)
        item.title = "New Macbook Pro"
        item.price = 1800
        item.details = "I can't wait until the September event, I hope they release new MBPs"
        
        let item2 = Item(context: context)
        item2.title = "Boss Headphones"
        item2.price = 300
        item2.details = "But man, its so nice to block out everyone with the noise canceling tech"
        
        let item3 = Item(context: context)
        item3.title = "Tesla Model S"
        item3.price = 110000
        item3.details = "oh man this is a beautiful car. And one day, I will own it"
        
        ad.saveContext()
    }
    
}

