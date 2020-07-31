//
//  Element.swift
//  Vimac
//
//  Created by Dexter Leng on 18/7/20.
//  Copyright © 2020 Dexter Leng. All rights reserved.
//

import Cocoa
import AXSwift

class Element {
    let uuid = UUID()
    let axUIElement: AXUIElement
    lazy var cachedUIElement: CachedUIElement = CachedUIElement.init(axUIElement)

    init(axUIElement: AXUIElement) {
        self.axUIElement = axUIElement
    }
    
    func role() -> String? {
        return try? self.cachedUIElement.attribute(.role)
    }
    
    func position() -> NSPoint? {
        return try? self.cachedUIElement.attribute(.position)
    }
    
    func size() -> NSSize? {
        return try? self.cachedUIElement.attribute(.size)
    }
    
    func frame() -> NSRect? {
        guard let position = position(),
            let size = size() else {
                return nil
        }
        return NSRect(origin: position, size: size)
    }
    
    func children() -> [Element] {
        let childrenOptional = try? cachedUIElement.attribute(Attribute.children) as [AXUIElement]?
        guard let children = childrenOptional else {
            return []
        }
        return children.map({ Element(axUIElement: $0) })
    }
    
    func menuBar() -> Element? {
        // AXSwift wraps it https://github.com/tmandry/AXSwift/blob/2328ea6a967138052c292c76a099609793ea3234/Sources/UIElement.swift#L421
        let menuBarUIElement = try? cachedUIElement.attribute(Attribute.menuBar) as UIElement?
        let menuBarAXUIElementMaybe = menuBarUIElement.map { $0.element }
        guard let menuBarAXUIElement = menuBarAXUIElementMaybe else {
            return nil
        }
        return Element(axUIElement: menuBarAXUIElement)
    }
    
    func parent() -> Element? {
        let parentUIElement = try? cachedUIElement.attribute(Attribute.parent) as UIElement?
        let parentAXUIElementMaybe = parentUIElement.map { $0.element }
        guard let parentAXUIElement = parentAXUIElementMaybe else {
            return nil
        }
        return Element(axUIElement: parentAXUIElement)
    }
}