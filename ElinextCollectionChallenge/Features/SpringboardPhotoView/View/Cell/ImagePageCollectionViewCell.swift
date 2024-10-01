//
//  ImagePageCollectionViewCell.swift
//  ElinextCollectionChallenge
//
//  Created by Kazu on 1/10/24.
//

import UIKit

class ImagePageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImagePageCollectionViewCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModels = [CellViewModel]()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModels.removeAll()
    }
    
    // MARK: - Collection View set up
    
    func collectionViewSetup() {
        collectionView.register(UINib(nibName: "AsyncImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: AsyncImageCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let itemWidth = collectionView.frame.width / 7 - 2
        let itemHeight = collectionView.frame.height / 10 - 2
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        // Setup Collection View
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        
    }
}

// MARK: - UICollectionViewDelegate
extension ImagePageCollectionViewCell: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource
extension ImagePageCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AsyncImageCollectionViewCell.identifier, for: indexPath) as! AsyncImageCollectionViewCell
        
        cell.setupViews()
        
        cell.configure(viewModel: viewModels[indexPath.row])
        
        return cell
    }
    
    
}
