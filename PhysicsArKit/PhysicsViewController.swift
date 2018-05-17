//
//  ViewController.swift
//  PhysicsArKit
//
//  Created by Andres Montoya on 5/13/18.
//  Copyright © 2018 CityTaxi. All rights reserved.
//

import UIKit
import ARKit

class PhysicsViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let viewModel = ArKitSceneViewModel.shared
    let rocketShipNodeName = "rocketship"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
        addSwipeGesturesToSceneView()
        configureLighting()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupSceneView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sceneView.session.pause()
    }
    
    func setupSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        //sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        sceneView.delegate = self
        sceneView.session.run(configuration)
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func addSwipeGesturesToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addRocketshipToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
   
    func addTapGestureToSceneView() {
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.applyForceToRocketship(withGestureRecognizer:)))
        swipeUpGestureRecognizer.direction = .up
        sceneView.addGestureRecognizer(swipeUpGestureRecognizer)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.launchRocketShip(withGestureRecgnizer:)))
        swipeDownGestureRecognizer.direction = .down
        sceneView.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    @objc func addRocketshipToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        guard let hitTestResult = hitTestResults.first else { return }
        
        let translation = hitTestResult.worldTransform.translation
        let x = translation.x
        let y = translation.y + 0.1
        let z = translation.z
        
        guard let rocketshipScene = SCNScene(named: "rocketship.scn"),
            let rocketshipNode = rocketshipScene.rootNode.childNode(withName: "rocketship", recursively: false)
            else { return }
        rocketshipNode.position = SCNVector3(x,y,z)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        rocketshipNode.physicsBody = physicsBody
        rocketshipNode.name = rocketShipNodeName
        sceneView.scene.rootNode.addChildNode(rocketshipNode)
    }
    
    func getRocketshipNode(from swipeLocation: CGPoint) -> SCNNode? {
        let hitTestResults = sceneView.hitTest(swipeLocation)
        
        guard let parentNode = hitTestResults.first?.node.parent,
            parentNode.name == rocketShipNodeName
            else { return nil }
        
        return parentNode
    }
    
    @objc func applyForceToRocketship(withGestureRecognizer recognizer: UIGestureRecognizer) {
        guard recognizer.state == .ended else { return }
        let swipeLocation = recognizer.location(in: sceneView)
        guard let rocketshipNode = getRocketshipNode(from: swipeLocation),
            let physicsBody = rocketshipNode.physicsBody
            else { return }
        let direction = SCNVector3(0, 3, 0)
        physicsBody.applyForce(direction, asImpulse: true)
    }
    
    @objc func launchRocketShip(withGestureRecgnizer recognizer: UIGestureRecognizer) {
        guard recognizer.state == .ended else {return}
        let swipeLocation = recognizer.location(in: sceneView)
        guard let rocketShipNode = getRocketshipNode(from: swipeLocation),
            let physicsBody = rocketShipNode.physicsBody,
            let reactorParticleSystem = SCNParticleSystem(named: "reactor", inDirectory: nil),
            let engineNode = rocketShipNode.childNode(withName: "node2", recursively: false)
            else {return}
        physicsBody.isAffectedByGravity = false
        physicsBody.damping = 0
        reactorParticleSystem.colliderNodes = viewModel.planeNodes
        engineNode.addParticleSystem(reactorParticleSystem)
        let action = SCNAction.moveBy(x: 0, y: 0.3, z: 0, duration: 3)
        action.timingMode = .easeInEaseOut
        rocketShipNode.runAction(action)
    }
    
}

