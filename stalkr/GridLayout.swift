//
//  GridLayout.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 06/02/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

protocol GridLayoutDelegate {
    
    func cellSlotSize(section: Int, row: Int) -> (width: Int, height: Int)
    func gridNumberOfRows() -> Int
    func gridNumberOfColumns() -> Int
}

class GridLayout: UICollectionViewLayout {
    
    var delegate: GridLayoutDelegate!
    
    var cellPadding: CGFloat = 6.0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        let numberOfColumns = delegate.gridNumberOfColumns()
        let numberOfRows = delegate.gridNumberOfRows()
        
        if cache.isEmpty {
            // inicializar variáveis com as dimensões
            let columnWidth = contentWidth / CGFloat(numberOfColumns)
            let columnRow = collectionView!.bounds.height / CGFloat(numberOfRows)
            var xOffset = [CGFloat]()
            for column in 0..<numberOfColumns {
                xOffset.append(CGFloat(column) * columnWidth)
            }
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            // preencher collection view
            var column: Int
            //for section in 0..<numberOfRows {
            for section in 0..<collectionView!.numberOfSections {
                column = 0
                
                for item in 0..<collectionView!.numberOfItems(inSection: section) {
                    let indexPath = IndexPath(item: item, section: section)
                    
                    // definir o tamanho da célula
                    let slotSize = delegate.cellSlotSize(section: section, row: item)
                    let slotWidth = slotSize.width
                    let slotHeight = slotSize.height
                    
                    let cellWidth = CGFloat(slotWidth) * columnWidth
                    let cellHeight = CGFloat(slotHeight) * columnRow
                    var height = cellPadding + cellHeight + cellPadding
                    if slotHeight > 1 { // se a célula ocupa mais que um slot horizontal, acrescentar à célula o espaço de padding
                        height += CGFloat(slotHeight) * cellPadding
                    }
                    
                    // checar se tem espaço nessa coluna; se não tiver, ir para o próximo espaço vago
                    while yOffset[column] > CGFloat(Int(columnRow) * (section + 1)) {
                        column += 1
                        if column == numberOfColumns {
                            print("[WARNING GridLayout] Célula de \(section):\(item) ultrapassou os limites!")
                        }
                    }
                    
                    // desenhar o frame da célula e adicioná-la ao cache
                    let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellWidth, height: height)
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
                    
                    // atualizar yOffset e contentHeight
                    contentHeight = max(contentHeight, frame.maxY)
                    
                    for i in 0..<slotWidth {
                        yOffset[column + i] = yOffset[column + i] + height
                    }
                    column += slotWidth
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
}
