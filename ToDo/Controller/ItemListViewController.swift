//
//  ItemListViewController.swift
//  ToDo
//
//  Created by Cesar Paiva on 13/10/19.
//  Copyright © 2019 Cesar Paiva. All rights reserved.
//

import UIKit

class ItemListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataProvider: (UITableViewDataSource & UITableViewDelegate & ItemManagerSettable)!
    
    let itemManager = ItemManager()

    override func viewDidLoad() {
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        dataProvider.itemManager = itemManager
        tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showDetails(sender:)), name: Notification.Name("ItemSelectedNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    @IBAction func additem(_ sender: UIBarButtonItem) {
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: "InputViewController") as? InputViewController {
            nextViewController.itemManager = itemManager
            present(nextViewController, animated: true, completion: nil)
        }
    }
    
    @objc func showDetails(sender: Notification) {
        
        guard let index = sender.userInfo?["index"] as? Int else { fatalError() }
        
        if let nextViewController = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailViewController.self)) as? DetailViewController {
            nextViewController.itemInfo = (itemManager, index)
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
