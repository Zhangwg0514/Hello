//
//  ELCatePickView.swift
//  Never Forget
//
//  Created by Ruiying on 2019/5/23.
//

import UIKit

class ELCatePickView: UIView {

    var callBack:((String)->())!
    convenience init(callback:@escaping ((String)->())) {
        self.init(frame:kScreenBounds)
        callBack = callback
        frame = kKeyWin.bounds
        backgroundColor = .clear
        addSubview(bgView)
        addSubview(conView)
        conView.addSubview(cateTable)
    }
    
    lazy var bgView:UIButton = {
        let v = UIButton()
        v.backgroundColor = .clear
        v.addTarget(self, action: #selector(hide), for: .touchUpInside)
        v.frame = bounds
        return v
    }()
    lazy var conView:UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.size = CGSize(width: kScreenWidth - 20, height: 80)
        v.midx = kScreenWidth/2
        v.y = 280
        v.setRadius(radius: 10)
        return v
    }()
    lazy var cateTable:UICollectionView = {
        let frm = CGRect(x: 10, y: 0, width: kScreenWidth - 40, height: 80)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let v = UICollectionView(frame: frm, collectionViewLayout: layout)
        v.backgroundColor = .clear
        v.delegate = self
        v.dataSource = self
        v.register(CateCell.self, forCellWithReuseIdentifier: "CateCellId")
        return v
    }()
    
    
    func show() {
        kKeyWin.addSubview(self)
        conView.alpha = 0
        bgView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.conView.alpha = 1
            self.bgView.alpha = 1
        }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {[unowned self] in
            self.conView.alpha = 0
            self.bgView.alpha = 0
        }) {[unowned self] (f) in
            if f {
                self.callBack = nil
                self.removeFromSuperview()
            }
        }
    }
}

extension ELCatePickView : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CateCellId", for: indexPath) as! CateCell
        cell.cateImg = "cateIcon\(indexPath.row)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cate = "cateIcon\(indexPath.row)"
        callBack(cate)
    }
}

class CateCell : UICollectionViewCell {
    var cateImg:String! {
        didSet {
            cateImgv.image = UIImage(named: cateImg)
        }
    }
    lazy var cateImgv:UIImageView = {
        let v = UIImageView()
        addSubview(v)
        return v
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        cateImgv.frame = bounds.insetBy(dx: 5, dy: 5)
        cateImgv.setRadius(radius: cateImgv.height/2)
        
    }
}
