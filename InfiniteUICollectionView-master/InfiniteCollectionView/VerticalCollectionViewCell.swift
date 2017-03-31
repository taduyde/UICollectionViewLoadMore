//
//  VerticalCollectionViewCell.swift
//  InfiniteCollectionView
//

import UIKit

class VerticalCollectionViewCell: UICollectionViewCell {

    @IBOutlet var collectionView: UICollectionView!

    var numberOfCells = 10
    var loadingStatus = LoadMoreStatus.haveMore

    func reloadData() {
        numberOfCells = 10
        collectionView.reloadData()
        if numberOfCells > 0 {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        }
    }

    func loadMore() {
        
        if numberOfCells >= 25 {
            loadingStatus = .finished
            collectionView.reloadData()
            return
        }
        
        // Replace code with web service and append to data source
        
        Timer.schedule(delay: 2) { timer in
            self.numberOfCells += 5
            self.collectionView.reloadData()
        }
    }

}

extension VerticalCollectionViewCell: UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.kHorizontallCellIdentifier, for: indexPath) as! HorizontalCollectionViewCell
        cell.label.text = "\(indexPath.row)"
        
        if(indexPath.row==numberOfCells - 1) {
            if loadingStatus == .haveMore {
                self.perform(#selector(VerticalCollectionViewCell.loadMore), with: nil, afterDelay: 0)
            }
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var footerView:LoadMoreCollectionReusableView!
        
        if (kind ==  UICollectionElementKindSectionFooter) && (loadingStatus != .finished){
            footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.kLoadMoreVerticalCollectionFooterViewCellIdentifier, for: indexPath) as! LoadMoreCollectionReusableView
            
        }
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return (loadingStatus == .finished) ? CGSize.zero : CGSize(width: self.frame.height, height: self.frame.height)
    }
    
}

extension VerticalCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.height, height: self.frame.height)
    }
    
}
