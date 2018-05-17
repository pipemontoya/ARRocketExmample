//
//  ArKitSceneViewModel.swift
//  PhysicsArKit
//
//  Created by Andres Montoya on 5/13/18.
//  Copyright © 2018 CityTaxi. All rights reserved.
//

import Foundation
import ARKit

class ArKitSceneViewModel {
    static let shared = ArKitSceneViewModel()
    var planeNodes = [SCNNode]()

    public func rederedDidAdd(node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor.transparentWhite
        var planeNode = SCNNode(geometry: plane)
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        planeNodes.append(planeNode)
        update(&planeNode, withGeometry: plane, type: .static)
        node.addChildNode(planeNode)
    }
    
    public func rendererDidRemove(node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor,
            let planeNode = node.childNodes.first
            else {return}
        planeNodes = planeNodes.filter { $0 != planeNode }
    }
    
    public func renderedDidUpdate (node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            var planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
        update(&planeNode, withGeometry: plane, type: .static)
    }
    
    func update(_ node: inout SCNNode, withGeometry geometry: SCNGeometry, type: SCNPhysicsBodyType) {
        let shape = SCNPhysicsShape(geometry: geometry, options: nil)
        let physicsBody = SCNPhysicsBody(type: type, shape: shape)
        node.physicsBody = physicsBody
    }
}
