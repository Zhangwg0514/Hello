//
//  ELTabController.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/21.
//

import UIKit

class ELTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let ctrlStrings = [ELAccountController.self, ELUsersController.self, ELSettingController.self]
        let icons = ["accountTabIcon", "userTabIcon", "settingTabIcon"]
        let titles = ["Accounts", "Users", "Setting"]
        
        for (i,ctrl) in ctrlStrings.enumerated() {
            let vc = ELNavController(rootViewController: ctrl.init())
            let img = UIImage(named: icons[i])
            vc.tabBarItem = UITabBarItem(title: titles[i], image: img, tag: i)
            addChild(vc)
        }
    }
}
