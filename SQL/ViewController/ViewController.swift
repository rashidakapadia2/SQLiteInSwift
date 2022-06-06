//
//  ViewController.swift
//  SQL
//
//  Created by Neosoft on 24/05/22.
//

import UIKit

class ViewController: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var user = User()
    var viewModel: ViewModelType = FormViewModel()
    var data = [[TableDataModel]]()
    var dataFilter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        searchBar.delegate = self
        setUpNavBar()
        customSetUpNavBar()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataFromSQL()
        //        viewModel.paginationIdxArr = [0]
        //        paginationFetching()
    }
    
    func paginationFetching(){
        viewModel.paginationTableDataInDatabase(pageNo: 0, cellQnty: 2) { user in
            self.data = user
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } failure: { err in
            print(err)
        }
    }
    
    //MARK:- Fetching data to display on users screen
    func fetchDataFromSQL() {
        viewModel.readTableDataFromDatabase { user in
            self.data = user
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } failure: { err in
            print(err)
        }
    }
    
    func setUpTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    //MARK:- Custom TableViewCell registration
    func registerCell() {
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    func customSetUpNavBar() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let filter = UIBarButtonItem(title: ">=18", style: .plain, target: self, action: #selector(filterTapped))
        self.navigationItem.rightBarButtonItems = [add, filter]
    }
    
    //MARK:- Alert to delete Query
    func alert(id: Int){
        let alert = UIAlertController(title: "Are you sure you want to delete this user?", message: nil, preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.viewModel.deleteTableDataFromDatabase(id: id, success: {print("DATA DELETED SUCCESS")}) { err in
                print(err)
            }
            self.fetchDataFromSQL()
        } ))
        self.present(alert, animated: true)
    }
    
    //MARK:- Nav Buttons
    @objc func addTapped() {
        print("ADD TAPPED")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let formViewController = storyBoard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        self.navigationController?.pushViewController(formViewController, animated: true)
    }
    @objc func filterTapped() {
        viewModel.ageFilter(col_name: "\(ColumnsForUserTable.age)") { user in
            self.data = user
            print("...........")
            print(self.data)
            DispatchQueue.main.async {
                self.dataFilter = true
                self.tableView.reloadData()
            }
        } failure: { err in
            print(err)
        }
    }
    
    //MARK:- mapping input data to model
    func sendingDataToModel(id: Int, name: String, num: String, mail: String, age: Int, pic: String) -> User {
        var user = User()
        user.id = id
        user.name = name
        user.number = num
        user.email = mail
        user.age = age
        user.pic = pic
        return user
    }
    
    //Func not used...
    //MARK:- Creating Alert to Update Data
    func alertToUpdateDataSQL() {
        let alert = UIAlertController(title: nil, message: "Want to update data?", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default))
        self.present(alert, animated: true)
    }
}

//Mark:- TableViewDelegate, TableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count//userData.count
    }
    
    //MARK:- Displaying data i.e. read functionality implementation
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let tableData = data[indexPath.row]//userData[indexPath.row]
        
        user.mapDataFromTableModel(tableModel: tableData)
        
        cell.configureCell(name: user.name ?? "", email: user.email ?? "", number: user.number ?? "" , age: user.age ?? 0, pic: Data(base64Encoded: (user.pic ?? "")) ?? Data())
        return cell
    }
    
    //MARK:- Implementing delete functionality
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let tableData = data[indexPath.row]//userData[indexPath.row]
        
        user.mapDataFromTableModel(tableModel: tableData)
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            let id = self.user.id!
            self.alert(id: id)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
    //MARK:- Implementing Update functionality
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //alertToUpdateDataSQL()
        let tableData = data[indexPath.row]//userData[indexPath.row]
        user.mapDataFromTableModel(tableModel: tableData)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
        vc.isUpdateUserData = true
        vc.id = self.user.id
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !dataFilter {
            if indexPath.row == data.count - 1 {
                let arr = viewModel.getPaginationIndexArray()
                if arr.contains(indexPath.row){ return }
                viewModel.paginationTableDataInDatabase(pageNo: indexPath.row, cellQnty: 2) { user in
                    DispatchQueue.main.async {
                        self.data.append(contentsOf: user)
                        self.viewModel.paginationIndexArray(idx: indexPath.row)
                        self.tableView.reloadData()
                    }
                } failure: { err in
                    print(err)
                }
            }
        }
    }
}

//MARK:- Searchbar implementation
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTxt = searchBar.text!
        viewModel.filterTableDataInDatabase(col_pos: "\(ColumnsForUserTable.name)", col_val: searchTxt){ user in
            self.data = user
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } failure: { err in
            print(err)
        }
    }
}
