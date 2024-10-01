//
//  PagedCollectionViewLayout.swift
//  ElinextCollectionChallenge
//
//  Created by Kazu on 2/10/24.
//

import UIKit

class PagedCollectionViewLayout: UICollectionViewLayout {

    private let numberOfColumns = 7
    private let numberOfRows = 10
    private let itemSpacing: CGFloat = 2 // 2px spacing between items
    private var itemSize: CGSize = .zero
    private var contentSize: CGSize = .zero
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }

        // Calculate item size based on collection view's size minus the spacing
        let totalHorizontalSpacing = itemSpacing * CGFloat(numberOfColumns - 1)
        let totalVerticalSpacing = itemSpacing * CGFloat(numberOfRows - 1)

        let availableWidth = collectionView.bounds.width - totalHorizontalSpacing
        let availableHeight = collectionView.bounds.height - totalVerticalSpacing

        itemSize = CGSize(width: availableWidth / CGFloat(numberOfColumns),
                          height: availableHeight / CGFloat(numberOfRows))

        layoutAttributes.removeAll()

        let sections = collectionView.numberOfSections
        var totalContentWidth: CGFloat = 0
        let totalContentHeight = collectionView.bounds.height

        for section in 0..<sections {
            let items = collectionView.numberOfItems(inSection: section)
            let numberOfPages = Int(ceil(Double(items) / Double(numberOfColumns * numberOfRows)))

            for page in 0..<numberOfPages {
                for row in 0..<numberOfRows {
                    for column in 0..<numberOfColumns {
                        
                        let index = page * numberOfColumns * numberOfRows + row * numberOfColumns + column
                        
                        if index < items {
                            let indexPath = IndexPath(item: index, section: section)
                            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                            let xPosition = CGFloat(page) * collectionView.bounds.width + CGFloat(column) * (itemSize.width + itemSpacing)
                            let yPosition = CGFloat(row) * (itemSize.height + itemSpacing)

                            attributes.frame = CGRect(x: xPosition, y: yPosition, width: itemSize.width, height: itemSize.height)
                            
                            layoutAttributes.append(attributes)
                        }
                    }
                }
            }
            totalContentWidth += CGFloat(numberOfPages) * collectionView.bounds.width
        }

        contentSize = CGSize(width: totalContentWidth, height: totalContentHeight)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutAttributes.first { $0.indexPath == indexPath }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
