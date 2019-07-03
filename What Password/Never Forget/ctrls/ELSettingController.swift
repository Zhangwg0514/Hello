//
//  ELSettingController.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit

class ELSettingController: ELBaseController {
    
    var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Setting"
        table = UITableView()
        table.frame = kScreenBounds
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.tableFooterView = UIView()
        view.addSubview(table)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: NSNotification.Name("UserLogined"), object: nil)
    }
    
    @objc func refreshData() {
        table.reloadData()
    }
}

extension ELSettingController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            let vc = ELAboutUSController()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        if indexPath.row == 0 {
            let alert = UIAlertController(title: "Prompt", message: "Are you sure?", preferredStyle: .alert)
            let act = UIAlertAction(title: "yes", style: .default) { (act) in
                ELDatabase.instance.clearCurrentUserAccounts()
            }
            let cancel = UIAlertAction(title: "no", style: .default, handler: nil)
            alert.addAction(act)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func getCell(row:Int) -> UITableViewCell {
        if row == 1 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
            cell.textLabel?.text = "Abount US"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        if row == 0 {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
            cell.textLabel?.text = "Clear \(curUserName) Accounts"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        cell.textLabel?.text = "Version"
        cell.detailTextLabel?.text = "1.0 build 1.0"
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }
}
