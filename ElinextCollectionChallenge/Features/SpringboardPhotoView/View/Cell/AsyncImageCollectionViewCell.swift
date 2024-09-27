//
//  AsyncImageCollectionViewCell.swift
//  ElinextCollectionChallenge
//
//  Created by Kazu on 26/9/24.
//

import UIKit

class AsyncImageCollectionViewCell: UICollectionViewCell {
    // MARK: - Cell Identifier
    static let identifier = "AsyncImageCollectionViewCell"
    
    @IBOutlet weak var imageView: UIImageView!
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func setupViews() {
        contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func configure(viewModel: CellViewModel) {
        activityIndicator.startAnimating()
        viewModel.downloadImage { [weak self] image in
            guard let self else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
                self.activityIndicator.stopAnimating()
            }
            
        }
    }

}
