//
//  CollectionViewController.swift
//  IdaDashboard
//
//  Created by Gunalan Karun on 3/26/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit

class DashCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellIdentifiers = ["ScoreCell","DashCell1","DashCell2","DashCell3","DashCell4","StartTripCell"]
    let cellSizes = [CGSize(width:373, height:215),CGSize(width:185, height:180),CGSize(width:185, height:180),CGSize(width:185, height:180),CGSize(width:185, height:180),CGSize(width:369, height:69)]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifiers[indexPath.item], for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }

}
