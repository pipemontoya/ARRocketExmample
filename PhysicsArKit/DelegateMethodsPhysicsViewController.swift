//
//  DelegateMethodsPhysicsViewController.swift
//  PhysicsArKit
//
//  Created by Andres Montoya on 5/13/18.
//  Copyright © 2018 CityTaxi. All rights reserved.
//

import Foundation
import UIKit
import ARKit

extension PhysicsViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        viewModel.rederedDidAdd(node: node, for: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        viewModel.rendererDidRemove(node: node, for: anchor)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        viewModel.renderedDidUpdate(node: node, for: anchor)
    }
    
}
