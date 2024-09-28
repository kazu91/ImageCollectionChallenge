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
    
    // MARK: UI setup
    
    func collectionViewSetup() {
        collectionView.register(UINib(nibName: "AsyncImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: AsyncImageCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        let itemWidth = (view.frame.width / 7) - 2
        let itemHeight = (view.frame.height / 10) - 2
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        
        // Setup Collection View
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
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
        viewModels = Array(1...140).map {_ in CellViewModel()}
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView Delegate
extension SpringboardPhotoViewController: UICollectionViewDelegate { }

// MARK: - UICollectionView Data Source
extension SpringboardPhotoViewController: UICollectionViewDataSource {
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

// MARK: - UICollectionView Prefetching
extension SpringboardPhotoViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            viewModels[indexPath.row].downloadImage { _ in }
            print(indexPath)
        }
    }
}
