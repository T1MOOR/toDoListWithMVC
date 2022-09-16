//
//  ViewController.swift
//  ToDoList MVC2
//
//  Created by Тимур Гарипов on 09.09.22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let idCell = "idCell"
    var model = Model()
    var alert = UIAlertController()
    var search = UISearchController()
    var customCell = CustomTableViewCell()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        
// Добавляем строку поиска
        search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
        
// Добавляем кнопку настроек
        let btnSettings = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(goToSettings))
        navigationItem.rightBarButtonItem = btnSettings
        btnSettings.tintColor = UIColor(named: "colorSingleLineTV")
        btnSettings.image = UIImage(systemName: "gearshape.fill")
        
// Добавляем кнопку создания нового задания
        let btnAdd = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.leftBarButtonItem = btnAdd
        btnAdd.tintColor = UIColor(named: "colorSingleLineTV")
    }
    
    
    
    @objc func addTask(){
        alert = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Put your task here"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        
        let createAlertAction = UIAlertAction(title: "Create", style: .default) { (createAlert) in
            // add new task
            
            guard let unwrTextFieldValue = self.alert.textFields?[0].text else {
                return
            }
            self.model.addNewTask(itemName: unwrTextFieldValue)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.tableView.reloadData()
 
        }
        
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(cancelAlertAction)
        alert.addAction(createAlertAction)
        present(alert, animated: true, completion: nil)
        createAlertAction.isEnabled = false
    }
    
    @objc func alertTextFieldDidChange(_ sender: UITextField) {

            guard let senderText = sender.text, alert.actions.indices.contains(1) else {
                return
            }

            let action = alert.actions[1]
            action.isEnabled = senderText.count > 0
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
//Метод перехода на окно настроек
    @objc func goToSettings (){
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
// Добавим левый Свайп для отметки для редактирования
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeEdit = UIContextualAction(style: .normal, title: "Редактировать") { [weak self] (action, view, completionHandler) in
            self?.editCellContent(indexPath: indexPath)
                completionHandler(true)
        }
        
        swipeEdit.backgroundColor = UIColor(named: "ColorEdit")
        swipeEdit.image = UIImage(systemName: "square.and.pencil")
        
        return UISwipeActionsConfiguration(actions: [swipeEdit])
    }
    
// Добавим правый Свайп для удаления задания
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        
        
        let swipeDelete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, success) in
            self?.tableView.performBatchUpdates({
                self?.model.removeItem(indexPath: indexPath)
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                success(true)
            }, completion: nil)
            print ("Delete Swipe")
    }
        
            swipeDelete.image = UIImage(systemName: "trash")
            swipeDelete.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)

            return UISwipeActionsConfiguration(actions: [swipeDelete])
    }
    
// Функция форматирования ячейки
    func editCellContent(indexPath: IndexPath) {
        let cell = tableView(tableView, cellForRowAt: indexPath) as! CustomTableViewCell
        
        alert = UIAlertController(title: "Edit your task", message: nil, preferredStyle: .alert)

        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField.text = cell.taskLabel.text
            
        })
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let editAlertAction = UIAlertAction(title: "Submit", style: .default) { (createAlert) in
            
            guard let textFields = self.alert.textFields, textFields.count > 0 else{
                return
            }
            
            guard let textValue = self.alert.textFields?[0].text else {
                return
            }
            
            self.model.updateItem(at: indexPath.row, with: textValue)
            
            self.tableView.reloadData()

        }
        
        alert.addAction(cancelAlertAction)
        alert.addAction(editAlertAction)
        present(alert, animated: true, completion: nil)
        
    }

   
}

        
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch(){
            return model.toDoItemFiltered.count
        }
        return model.toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as! CustomTableViewCell

        var toDoItems:Item
        if isSearch(){
            toDoItems = model.toDoItemFiltered[indexPath.row]
        }else{
            toDoItems = model.toDoItems[indexPath.row]
        }
        
        cell.taskLabel.text = toDoItems.taskName
        return cell
    }
    
    
    func tableView(_ tableView:UITableView, heightForRowAt IndexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("Tapped \(indexPath.row)")
    }
    
// Передаем метод filterToDoItems из Модели
    func filterSearchItem(taskName: String){
        model.filterToDoItems(taskName: taskName)
        tableView.reloadData()
    }
    
//Проверям пустой ли SearchBar
    func searchBarIsEmpty() -> Bool{
        return search.searchBar.text?.isEmpty ?? true
    }
    
    func isSearch() -> Bool{
        return search.isActive && !searchBarIsEmpty()
    }
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterSearchItem(taskName: searchController.searchBar.text!)
    }
}
