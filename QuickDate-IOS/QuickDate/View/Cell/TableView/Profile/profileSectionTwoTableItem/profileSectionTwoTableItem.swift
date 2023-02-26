//
//  profileSectionTwoTableItem.swift
//  QuickDate
//

//  Copyright © 2020 ScriptSun. All rights reserved.
//

import UIKit
class profileSectionTwoTableItem: UITableViewCell {
    
    @IBOutlet weak var collectionViewProfileGride: UICollectionView!
    
    let HARIZONTAL_SPCE_IMAGE: CGFloat          = 1
    let VERTICAL_SPCE_IMAGE: CGFloat            = 1
    let COLUMN_IMAGE: CGFloat                   = 3
    
    var items: [[String : String]] = []
    var onDidSelect: ((IndexPath) -> ())?

    //    @IBOutlet var itemIconImage: UIImageView!
    //    @IBOutlet var labelItemTitle: UILabel!
    //    @IBOutlet var labelItemInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionViewProfileGride.register(UINib(nibName: "ProfileGideCell", bundle: nil), forCellWithReuseIdentifier: "ProfileGideCell")
        self.collectionViewProfileGride.delegate = self
        self.collectionViewProfileGride.dataSource = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func reloadCollectionView() {
        self.collectionViewProfileGride.reloadData()
    }
}

extension profileSectionTwoTableItem: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileGideCell", for: indexPath) as! ProfileGideCell
        cell.itemIconImage.image = UIImage(named: items[indexPath.row]["icon"]!)
        cell.labelItemTitle.text = items[indexPath.row]["title"]
        //cell.labelItemInfo.text = items[indexPath.row]["info"]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onDidSelect?(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat { return HARIZONTAL_SPCE_IMAGE }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat { return VERTICAL_SPCE_IMAGE }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.frame.width - ((COLUMN_IMAGE - 1) * HARIZONTAL_SPCE_IMAGE)) / COLUMN_IMAGE
        return CGSize(width: width, height: width)
    }
}
