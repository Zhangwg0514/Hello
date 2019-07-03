//
//  ELAboutUSController.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/23.
//

import UIKit

class ELAboutUSController: ELBaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "About US"
        
        let bgView = UIView()
        bgView.backgroundColor = .white
        bgView.setRadius(radius: 20)
        bgView.x = 30
        bgView.y = kTopBarHeight + 40
        bgView.width = view.width - 60
        view.addSubview(bgView)

        let iconImgv = UIImageView()
        iconImgv.image = UIImage(named: "appIcon180")
        iconImgv.size = CGSize(width: 80, height: 80)
        iconImgv.y =  30
        iconImgv.midx = bgView.width/2
        iconImgv.backgroundColor = .lightGray
        iconImgv.setRadius(radius: 16)
        bgView.addSubview(iconImgv)
        
        
        let mobilett = UILabel()
        mobilett.text = "Mobile"
        mobilett.textColor = kKeyColor
        mobilett.font = .systemFont(ofSize: 16)
        mobilett.size = CGSize(width: 80, height: 30)
        mobilett.x = 30
        mobilett.y = iconImgv.by + 40
        bgView.addSubview(mobilett)
        
        let mobileLbl = UILabel()
        mobileLbl.text = kMobileNumber
        mobileLbl.textColor = kKeyColor
        mobileLbl.font = .systemFont(ofSize: 16)
        mobileLbl.textAlignment = .right
        mobileLbl.size = CGSize(width: 200, height: 30)
        mobileLbl.rx = bgView.width - 30
        mobileLbl.y = mobilett.y
        bgView.addSubview(mobileLbl)

        let line = UIView(frame: CGRect(x: 0, y: 0, width: bgView.width - 30, height: 1))
        line.backgroundColor = UIColor("cccccc66")
        line.midx = bgView.width/2
        line.y = mobilett.by + 20
        bgView.addSubview(line)
        
        let mailtt = UILabel()
        mailtt.text = "Email"
        mailtt.textColor = kKeyColor
        mailtt.font = .systemFont(ofSize: 16)
        mailtt.size = CGSize(width: 80, height: 30)
        mailtt.x = 30
        mailtt.y = line.by + 20
        bgView.addSubview(mailtt)
        
        let mailLbl = UILabel()
        mailLbl.text = kEmailAddress
        mailLbl.textColor = kKeyColor
        mailLbl.font = .systemFont(ofSize: 16)
        mailLbl.textAlignment = .right
        mailLbl.size = CGSize(width: 250, height: 30)
        mailLbl.rx = bgView.width - 30
        mailLbl.y = mailtt.y
        bgView.addSubview(mailLbl)
        
//        line = UIView(frame: CGRect(x: 0, y: 0, width: bgView.width - 30, height: 1))
//        line.backgroundColor = UIColor("cccccc66")
//        line.midx = bgView.width/2
//        line.y = mailtt.by + 10
//        bgView.addSubview(line)
        
        
        bgView.height = mailLbl.by + 60
        
    }
}
