//
//  ViewController.swift
//  ElinextCollectionChallenge
//
//  Created by Kazu on 26/9/24.
//

import UIKit


class SpringboardPhotoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
                
    var viewModels: [CellViewModel] = []
    
    var totalPage: Int {
        if viewModels.isEmpty { return 1 }
    
        return Int(ceil(Double(viewModels.count) / Double(70)))
    }
    
    // MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Photos"
        
        setupTopBarButtons()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadAllImages()
    }
    
    // MARK: UI setup
    
    func collectionViewSetup() {
        collectionView.register(UINib(nibName: "ImagePageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ImagePageCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 0
        let itemWidth = collectionView.frame.width
        let itemHeight = collectionView.frame.height
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        // Setup Collection View
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
       // collectionView.prefetchDataSource = self
        
        collectionView.decelerationRate = .fast

    }
    
    // MARK: - Navigation Controller Setup
    
    func setupTopBarButtons() {
        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.addTarget(self, action: #selector(addNewImage), for: .touchUpInside)
        let barButton1 = UIBarButtonItem(customView: plusButton)
        
        let reloadButton = UIButton(type: .system)
        reloadButton.setTitle("Reload All", for: .normal)
        reloadButton.addTarget(self, action: #selector(reloadAllImages), for: .touchUpInside)
        let barButton2 = UIBarButtonItem(customView: reloadButton)
        
        navigationItem.rightBarButtonItems = [barButton1, barButton2]
        
    }
    
    //MARK: Functions
    
    @objc func addNewImage() {
        viewModels.append(.init())
        collectionView.reloadData()
    }
    
    @objc func reloadAllImages() {
        viewModels.removeAll()
        ImageCache.shared.clearCache()
        collectionView.reloadData()
        viewModels = Array(1...140).map {_ in CellViewModel()}
        collectionView.reloadData()
    }
    
    
}

// MARK: - UICollectionView Delegate
extension SpringboardPhotoViewController: UICollectionViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let collectionView = scrollView as? UICollectionView {
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let bounds = scrollView.bounds
            let xTarget = targetContentOffset.pointee.x
            
            // This is the max contentOffset.x to allow. With this as contentOffset.x, the right edge of the last column of cells is at the right edge of the collection view's frame.
            let xMax = collectionView.contentSize.width - collectionView.bounds.width
            
            if abs(velocity.x) <= snapToMostVisibleColumnVelocityThreshold {
                let xCenter = scrollView.bounds.midX
                let poses = layout.layoutAttributesForElements(in: bounds) ?? []
                // Find the column whose center is closest to the collection view's visible rect's center.
                let x = poses.min(by: { abs($0.center.x - xCenter) < abs($1.center.x - xCenter) })?.frame.origin.x ?? 0
                targetContentOffset.pointee.x = x
            } else if velocity.x > 0 {
                let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
                // Find the leftmost column beyond the current position.
                let xCurrent = scrollView.contentOffset.x
                let x = poses.filter({ $0.frame.origin.x > xCurrent}).min(by: { $0.center.x < $1.center.x })?.frame.origin.x ?? xMax
                targetContentOffset.pointee.x = min(x, xMax)
            } else {
                let poses = layout.layoutAttributesForElements(in: CGRect(x: xTarget - bounds.size.width, y: 0, width: bounds.size.width, height: bounds.size.height)) ?? []
                // Find the rightmost column.
                let x = poses.max(by: { $0.center.x < $1.center.x })?.frame.origin.x ?? 0
                targetContentOffset.pointee.x = max(x, 0)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1 * UIScreen.main.scale)
        } else {
            return UIEdgeInsets.zero
        }
    }

    // Velocity is measured in points per millisecond.
    private var snapToMostVisibleColumnVelocityThreshold: CGFloat { return 0.5}
    
  
}

// MARK: - UICollectionView Data Source
extension SpringboardPhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalPage
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagePageCollectionViewCell.identifier, for: indexPath) as! ImagePageCollectionViewCell
        
        let startIndex = 70 * indexPath.row
        let endIndex = min(startIndex + 70, viewModels.count)
        cell.viewModels.removeAll()
        cell.viewModels = Array(viewModels[startIndex..<endIndex])
        cell.collectionViewSetup()
        return cell
    }
}

// MARK: - UICollectionView Prefetching
extension SpringboardPhotoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModels[indexPath.row].downloadImage { _ in }
            print(indexPath)
        }
    }
}
