//
//  ViewController.swift
//  InfiniteCollectionView
//

import UIKit

class ViewController: UIViewController {

    var verticalDataSource = [String]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var numberOfCells = 10
    var loadingStatus = LoadMoreStatus.haveMore
    
    func loadMore() {
        
        if numberOfCells >= 25 {
            loadingStatus = .finished
            collectionView.reloadData()
            return
        }
        
        // Replace code with web service and append to data source
        Timer.schedule(delay: 2) { timer in
            print(timer ?? "")
            self.numberOfCells += 5
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - Rotation methods

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        switch UIDevice.current.orientation {
        case .portrait:
            text="Portrait"
        case .portraitUpsideDown:
            text="PortraitUpsideDown"
        case .landscapeLeft:
            text="LandscapeLeft"
        case .landscapeRight:
            text="LandscapeRight"
        default:
            text="Another"
        }
        NSLog("You have moved: \(text)")
        
        collectionView.reloadData()

    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return numberOfCells
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.row==numberOfCells-1) {
            if loadingStatus == .haveMore {
                self.perform(#selector(ViewController.loadMore), with: nil, afterDelay: 0)
            }
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.kVerticalCellIdentifier, for: indexPath) as! VerticalCollectionViewCell
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
        
        return (loadingStatus == .finished) ? CGSize.zero : CGSize(width: self.view.frame.width, height: 150)

    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.view.frame.width, height: 150)
        
    }
    
}

