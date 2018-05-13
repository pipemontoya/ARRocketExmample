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
    public func rederedDidAdd(node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor.transparentWhite
        let planeNode = SCNNode(geometry: plane)
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        node.addChildNode(planeNode)
    }
    
    public func renderedDidUpdate (node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
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
    }
}
