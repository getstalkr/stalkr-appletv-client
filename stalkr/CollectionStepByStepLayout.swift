//
//  CollectionStepByStepLayout.swift
//  stalkr
//
//  Created by Bruno Macabeus Aquino on 06/03/17.
//  Copyright © 2017 Bruno Macabeus Aquino. All rights reserved.
//

import UIKit

protocol CollectionStepyByStepLayoutDelegate {
    
    func numberOfInputsAtStep(section: Int) -> Int
    func cellTypeAt(section: Int, row: Int) -> CellStepByStepType
}

enum CellStepByStepType {
    case step
    case name
    case input
    case finish
}

class CollectionStepByStepLayout: UICollectionViewLayout {

    var delegate: CollectionStepyByStepLayoutDelegate!
    
    var cellPadding: CGFloat = 0.0
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    private var contentHeight: CGFloat  = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        
        if cache.isEmpty {
            // inicializar variáveis com as dimensões
            let stepColumnWidth = contentWidth * 5 / 100
            let rightColumnWidth = contentWidth * 85 / 100
            
            // preencher collection view
            var previusY: Int = 0
            for section in 0..<collectionView!.numberOfSections {
                
                for item in 0..<collectionView!.numberOfItems(inSection: section) {
                    let indexPath = IndexPath(item: item, section: section)
                    
                    // definir o tamanho da célula
                    let slotWidth: CGFloat
                    let slotHeight: CGFloat
                    let frame: CGRect
                    
                    let cellType = delegate.cellTypeAt(section: section, row: item)
                    switch cellType {
                    case .step:
                        slotWidth = stepColumnWidth
                        slotHeight = CGFloat((delegate!.numberOfInputsAtStep(section: section) + 1) * 50)
                        frame = CGRect(x: 0, y: CGFloat(previusY), width: slotWidth, height: slotHeight)
                    case .finish:
                        slotWidth = contentWidth
                        slotHeight = 50
                        frame = CGRect(x: 0, y: CGFloat(previusY), width: slotWidth, height: slotHeight)
                    default:
                        slotWidth = rightColumnWidth
                        slotHeight = 50
                        frame = CGRect(x: 60, y: CGFloat(previusY), width: slotWidth, height: slotHeight)
                        previusY += 50
                    }
                    
                    // desenhar o frame da célula e adicioná-la ao cache
                    let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                    
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = insetFrame
                    cache.append(attributes)
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
