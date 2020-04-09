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

    
    private var workTasks: Results<WorkTask>!
    private var ascendingSorting = true
    //задавая в рез-татах нил, мы хотим, чтоб рез-тат поиска отображался на том же вью, где и находится изначальный контент
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredTasks: Results<WorkTask>!
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {return false}
        return text.isEmpty
    }
    //переменная для отслеживания активации поискового запроса
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = false
        workTasks = realm.objects(WorkTask.self)
        
        //Search controller settings. 1)получателем инфы об изменениях текста должен быть наш класс
        searchController.searchResultsUpdater = self
        //чтоб вк позволял взаимодействовать с отображаемым контентом
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        //чтоб строка поиска уходила при переходе на другой экран
        definesPresentationContext = true
    
    }
    


    // MARK: - Table view data source, delegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //при поиске
        if isFiltering {
            return filteredTasks.count
        }

        return workTasks.isEmpty ? 0 : workTasks.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkCell", for: indexPath as IndexPath) as! WorkTableViewCell
        
        var tasks = WorkTask()
        
        if isFiltering {
            tasks = filteredTasks[indexPath.row]
        } else {
            tasks = workTasks[indexPath.row]
        }
        cell.taskNameLabel.text = tasks.name
        let dateString = (tasks.taskDate)?.toString(dateFormat: "dd MMM yyyy HH:mm")
        cell.startDateLabel.text = dateString
        cell.workTaskImage.image = UIImage(data: tasks.imageData!)
        cell.taskLocationLabel.text = tasks.taskLocation
        
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
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        
        //toggle меняет булево значение на противоположное
        ascendingSorting.toggle()
        
        if ascendingSorting == true {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    
    //логика сортировки используя ascending sorting
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            workTasks = workTasks.sorted(byKeyPath: "taskDate", ascending: ascendingSorting)
        } else {
            workTasks = workTasks.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsOfTask" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            //багфикс правильно отображаемой ячейки
            let workTask: WorkTask
            if isFiltering {
                workTask = filteredTasks[indexPath.row]
            } else {
                workTask = workTasks[indexPath.row]
            }
            
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

extension WorkTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredTasks = workTasks.filter("name CONTAINS[c] %@ OR taskDescription CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
    
}


//<div>Icons made by <a href="https://www.flaticon.com/authors/freepik" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>
