//
//  ViewController.swift
//  Poke3D
//
//  Created by Parsa Shobany on 18/11/2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
        
        configuration.trackingImages = imageToTrack
        
        configuration.maximumNumberOfTrackedImages = 2
        
        print("Images Successfully Added")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func modelRender (imageAnchor : ARImageAnchor){

    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            print("modelRender trigered")
            print("Model Name :\(imageAnchor.referenceImage.name)")
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0.5)
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            print("Plane node created")
            
            let nameText = SCNText(string: imageAnchor.referenceImage.name, extrusionDepth: 2)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            nameText.materials = [material]
            let textNode = SCNNode()
            textNode.position = SCNVector3(x: -0.03, y: 0.005, z: 0.0)
            print(planeNode.position)
            textNode.scale = SCNVector3(x:0.001, y:0.001, z:0.001)
            textNode.geometry = nameText
            textNode.castsShadow = true
            textNode.eulerAngles.x = -.pi / 4
            node.addChildNode(textNode)
            
            let pokeScene = SCNScene(named: "art.scnassets/\(imageAnchor.referenceImage.name ?? "").scn")
            if let pokeNode = pokeScene?.rootNode.childNodes.first {
                pokeNode.eulerAngles.x = .pi / 2
            planeNode.addChildNode(pokeNode)}}
        return node}}
