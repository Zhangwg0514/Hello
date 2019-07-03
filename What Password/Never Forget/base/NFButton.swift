//
//  NFButton.swift
//  Never Forget
//
//  Created by David on 05/06/2019.
//  Copyright © 2019 Ruiying. All rights reserved.
//

import UIKit

class NFButton: UIButton {

    var label = UILabel()
    var imageV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubView() {
        self.label = UILabel()
        self.label.font = UIFont.systemFont(ofSize: 12)
        self.label.textAlignment = .center
        self.addSubview(self.label)
        self.imageV = UIImageView()
        self.addSubview(self.imageV)
    }
}
