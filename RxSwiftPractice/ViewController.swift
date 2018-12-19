//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by bupozhuang on 2018/12/10.
//  Copyright © 2018 bupozhuang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UITableViewController {
    var list:[String] = ["timeout and retry"]
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RxSwiftPractic"
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }


    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt RxSwift Resources:\(Resources.total)")
        let vc = TimeOutAndRetryViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") {
            cell.textLabel?.text = list[indexPath.row]
            return cell
        }
        return UITableViewCell()
        
    }
}



