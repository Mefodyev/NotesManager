//
//  TableViewController.swift
//  Notes Manager
//
//  Created by Alexey Mefodyev on 29.01.2020.
//  Copyright © 2020 LexMefodyev. All rights reserved.
//

import UIKit
import RealmSwift

class WorkTableViewController: UITableViewController {

    var workTasks: Results<WorkTask>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        workTasks = realm.objects(WorkTask.self)


    }

    // MARK: - Table view data source, delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workTasks.isEmpty ? 0 : workTasks.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkCell", for: indexPath as IndexPath) as! WorkTableViewCell
        
        let tasks = workTasks[indexPath.row]
        cell.taskNameLabel.text = tasks.name
        let dateString = (tasks.taskDate)?.toString(dateFormat: "dd MM yyyy HH:mm")
        cell.startDateLabel.text = dateString
        cell.workTaskImage.image = UIImage(data: tasks.imageData!)
        
        cell.workTaskImage.layer.cornerRadius = cell.workTaskImage.frame.size.height/2
        cell.workTaskImage.clipsToBounds = true

        return cell
    }
    
    //deleting a row from tableView
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let workTask = workTasks[indexPath.row]
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            
            StorageManager.deleteWorkObject(workTask)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
   
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newVC = segue.source as? AddNewTaskToWorkViewController else { return }
        
        newVC.saveWorkTask()
        tableView.reloadData()
        
    }
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsOfTask" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let workTask = workTasks[indexPath.row]
            let newWorkTaskVC = segue.destination as! AddNewTaskToWorkViewController
            newWorkTaskVC.currentTask = workTask
        }
    }

}

extension Date {
    
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


//<div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
