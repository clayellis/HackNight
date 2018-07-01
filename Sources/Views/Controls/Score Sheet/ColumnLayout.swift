//
//  ColumnLayout.swift
//  Yahtzee
//
//  Created by Clay Ellis on 6/30/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

protocol ColumnLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, layout: ColumnLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
}

class ColumnLayout: UICollectionViewLayout {

    weak var delegate: ColumnLayoutDelegate!

    // TODO: didSet - invalidate cache
    /// The vertical spacing between items in the same column.
    private(set) var itemSpacing: CGFloat = 8

    // TODO: didSet - invalidate cache
    /// The horizontal spacing between columns.
    private(set) var columnSpacing: CGFloat = 10

    private var numberOfColumns: Int {
        guard let collectionView = collectionView, let dataSource = collectionView.dataSource else {
            return 0
        }

        return dataSource.numberOfSections?(in: collectionView) ?? 0
    }

    private var cache = [UICollectionViewLayoutAttributes]()

    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }

        return collectionView.bounds.width - collectionView.contentInset.horizontal
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }

        let columnWidth = (contentWidth - columnSpacing * CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns)
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * (columnWidth + columnSpacing))
        }

        for column in 0 ..< numberOfColumns {
            for item in 0 ..< collectionView.numberOfItems(inSection: column) {

                let indexPath = IndexPath(item: item, section: column)
                let itemHeight = delegate.collectionView(collectionView, layout: self, heightForItemAt: indexPath)

                let height: CGFloat
                if item == 0 {
                    height = itemHeight
                } else {
                    height = itemHeight + itemSpacing
                }

                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)

                // Every item except the first in the column should have an inset from the top
                let topInset = item == 0 ? 0 : itemSpacing
                let insets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
                let insetFrame = frame.inset(by: insets)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                cache.append(attributes)

                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] += height
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    override func invalidateLayout() {
        cache = []
    }
}
