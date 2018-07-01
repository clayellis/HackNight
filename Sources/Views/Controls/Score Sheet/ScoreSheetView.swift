//
//  ScoreSheetView.swift
//  Yahtzee
//
//  Created by Clay Ellis on 5/17/18.
//  Copyright © 2018 Clay Ellis. All rights reserved.
//

import UIKit

protocol ScoreSheetDelegate: class {
    func scoreSheet(_ scoreSheet: ScoreSheetView, didSelect cell: ScoreSheetCell)
}

final class ScoreSheetView: UIView {

    weak var delegate: ScoreSheetDelegate?

    var cells: [ScoreSheetCell] {
        return collectionView.visibleCells.compactMap { $0 as? ScoreSheetCell }
    }

    lazy var data: [Section: [ScoreSheetCellType]] = {
        let scoreOptionTypes = ScoreOption.allCases.map { ScoreSheetCellType.scoreOption($0) }
        var cellTypes = scoreOptionTypes + [.upperSectionBonus, .grandTotal]
        return Dictionary(grouping: cellTypes, by: { $0.belongsTo(section: .upper) ? .upper : .lower })
    }()

    fileprivate lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.collectionViewLayout)
    fileprivate lazy var collectionViewLayout = ColumnLayout()

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configureSubviews()
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSubviews() {
        collectionView.backgroundColor = .clear
        collectionView.register(ScoreSheetCell.self)
        collectionViewLayout.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = false
        collectionView.forceDelaysContentTouches(false)
        collectionView.clipsToBounds = false
    }

    private func configureLayout() {
        addAutoLayoutSubview(collectionView)
        collectionView.fill(self)
    }

    func focus(on options: Set<ScoreOption>) {
        if options.isEmpty {
            setCellsEnabled(true, for: Set(ScoreOption.allCases))
        }

        let others = Set(ScoreOption.allCases).subtracting(options)
        setCellsEnabled(true, for: options)
        setCellsEnabled(false, for: others)
    }

    private func setCellsEnabled(_ isEnabled: Bool, for options: Set<ScoreOption>) {
//        options.compactMap { cells[.scoreOption($0)] }
//            .forEach { $0.isEnabled = isEnabled }
    }

    private func section(for section: Int) -> Section {
        return data.keys.sorted()[section]
    }

    private func section(for indexPath: IndexPath) -> Section {
        return section(for: indexPath.section)
    }

    private func scoreSheetCellType(at indexPath: IndexPath) -> ScoreSheetCellType {
        return data[section(for: indexPath)]![indexPath.item]
    }

    private func scoreSheetCell(at indexPath: IndexPath) -> ScoreSheetCell? {
        return collectionView.cellForItem(at: indexPath) as? ScoreSheetCell
    }

    func reload() {
        collectionView.reloadData()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 300)
    }
}

extension ScoreSheetView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[self.section(for: section)]!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ScoreSheetCell.self, for: indexPath)
        let cellType = scoreSheetCellType(at: indexPath)
        cell.type = cellType
        return cell
    }
}

extension ScoreSheetView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let scoreSheetCell = self.scoreSheetCell(at: indexPath) else {
            return
        }

        delegate?.scoreSheet(self, didSelect: scoreSheetCell)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {

    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {

    }
}

extension ScoreSheetView: ColumnLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: ColumnLayout, heightForItemAt indexPath: IndexPath) -> CGFloat {
        let itemCount = CGFloat(self.collectionView(collectionView, numberOfItemsInSection: indexPath.section))
        let spacing = layout.itemSpacing * (itemCount - 1)
        let collectionViewHeight = max(collectionView.bounds.height, 400)
        let availableHeight = collectionViewHeight - collectionView.contentInset.vertical - spacing
        let itemHeight = availableHeight / itemCount
        return itemHeight
    }
}
