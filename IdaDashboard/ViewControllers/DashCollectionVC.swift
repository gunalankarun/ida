//
//  CollectionViewController.swift
//  IdaDashboard
//
//  Created by Gunalan Karun on 3/26/18.
//  Copyright © 2018 Ida. All rights reserved.
//

import UIKit
import UICircularProgressRing

class DashCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, UICircularProgressRingDelegate {
    
    @IBOutlet weak var scoreRing: UICircularProgressRingView!
    
    let cellIdentifiers = ["ScoreCell","DashCell1","DashCell2","DashCell3","DashCell4","StartTripCell"]
    let cellSizes = [
        CGSize(width:375, height:205),
        CGSize(width:188, height:175),
        CGSize(width:187, height:175),
        CGSize(width:188, height:175),
        CGSize(width:187, height:175),
        CGSize(width:369, height:65)]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifiers[indexPath.item], for: indexPath)
        if (indexPath.item == 0) {
            let scoreCell:ScoreCell = cell as! ScoreCell
            scoreCell.scoreRing.animationStyle = kCAMediaTimingFunctionLinear
            scoreCell.scoreRing.delegate = self
            scoreCell.scoreRing.setProgress(value: 92, animationDuration: 2)
        }
        if (indexPath.item < 5) {
            cell.contentView.layer.borderColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0).cgColor
            cell.contentView.layer.borderWidth = 0.5
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0).cgColor
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func finishedUpdatingProgress(forRing ring: UICircularProgressRingView) {
        print("From delegate: ScoreRing finished")
    }



}
