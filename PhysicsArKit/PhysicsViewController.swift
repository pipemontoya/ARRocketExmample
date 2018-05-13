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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapGestureToSceneView()
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
        sceneView.delegate = self
        sceneView.session.run(configuration)
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
   
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addRocketshipToSceneView(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
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
        sceneView.scene.rootNode.addChildNode(rocketshipNode)
    }
}

