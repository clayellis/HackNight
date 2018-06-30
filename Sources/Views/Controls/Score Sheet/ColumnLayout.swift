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
    private(set) var itemSpacing: CGFloat = 6

    // TODO: didSet - invalidate cache
    // TODO: This isn't being used right now
    // var columnSpacing: CGFloat = 6

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

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }

        for column in 0 ..< numberOfColumns {
            for item in 0 ..< collectionView.numberOfItems(inSection: column) {

                let indexPath = IndexPath(item: item, section: column)

                let itemHeight = delegate.collectionView(collectionView, layout: self, heightForItemAt: indexPath)
                let height = itemSpacing + itemHeight
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: itemSpacing, dy: itemSpacing)

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
