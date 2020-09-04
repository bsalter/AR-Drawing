//
//  ViewController.swift
//  AR Drawing
//
//  Created by Benjamin Salter on 8/23/20.
//  Copyright © 2020 Benjamin Salter. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var draw: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.showsStatistics = true
        sceneView.session.run(configuration)
    }
    
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {
            return
        }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let frontOfCamera = orientation + location
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = frontOfCamera
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
            } else {
                let pointerNode = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointerNode.name = "pointer"
                pointerNode.position = frontOfCamera
                self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                }
                pointerNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                self.sceneView.scene.rootNode.addChildNode(pointerNode)
            }
        }
    }
}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

