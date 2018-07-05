//
//  PinterestLayout.swift
//  Pinterest
//
//  Created by Daniel Lee on 3/11/18.
//  Copyright © 2018 Developers Academy. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
    var numberOfColumns: Int {get}
    var cellPadding:CGFloat {get}
    func cellHeight(at index: Int, cellWidth:CGFloat) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
    
    weak var delegate: PinterestLayoutDelegate?
    var layoutCache: [UICollectionViewLayoutAttributes] = []
    
    var numberOfColumns: Int {
        get{
            return delegate?.numberOfColumns ?? 1 //defaults to just 1 column
        }
    }
    
    var contentWidth: CGFloat {
        get{
            return collectionView?.frame.width ?? 0
        }
    }
    
    var columnWidth: CGFloat{
        return contentWidth / CGFloat(numberOfColumns)
    }
    
    var cellPadding: CGFloat{
        return delegate?.cellPadding ?? 0
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    private var contentHeight: CGFloat = 0
    
    override func prepare() {
        
        guard layoutCache.isEmpty else {return}
        guard let collectionView = self.collectionView else {return}
        guard let delegate = self.delegate else {return}
        
        func getXOffset(columnIndex: Int) -> CGFloat{
            let xOffset = CGFloat(columnIndex) * columnWidth + CGFloat(columnIndex + 1) * cellPadding
            return xOffset
        }
        
        var yOffsets = [CGFloat].init(repeating: 0, count: numberOfColumns) // This is a temp variable that keeps track each of the column offset for the upcoming calculation
        
        for index in 0 ..< collectionView.numberOfItems(inSection: 0) { //only handles section 0 for now
            let indexPath = IndexPath(row: index, section: 0)
            let attributes = PinterestLayoutAttributes(forCellWith: indexPath)
            
            let currentColumn = index % numberOfColumns
            let height = CGFloat(delegate.cellHeight(at: index, cellWidth: columnWidth) + cellPadding)
            attributes.height = height
            let frame = CGRect(x: getXOffset(columnIndex: currentColumn), y: yOffsets[currentColumn], width: columnWidth, height: height)
            attributes.frame = frame
            frame.insetBy(dx: cellPadding, dy: cellPadding)
            yOffsets[currentColumn] = yOffsets[currentColumn] + height
            contentHeight = max(contentHeight, frame.maxY)
            
            layoutCache.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let retVal = layoutCache.filter({
            $0.frame.intersects(rect)
        })
        return retVal
    }
}

class PinterestLayoutAttributes: UICollectionViewLayoutAttributes
{
    var height: CGFloat = 0.0
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! PinterestLayoutAttributes
        copy.height = height
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? PinterestLayoutAttributes {
            if attributes.height == height {
                return super.isEqual(object)
            }
        }
        
        return false
    }
}
