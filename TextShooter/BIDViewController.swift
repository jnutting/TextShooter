//
//  BIDViewController.swift
//  TextShooter
//
//  Created by Jack Nutting on 2025-08-04.
//  Copyright © 2025 Apress. All rights reserved.
//

import AppStoreCatalog
import SpriteKit
import SwiftUI
import UIKit

class BIDViewController: UIViewController {
    private var catalog: AppStoreCatalog?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        catalog = AppStoreCatalog.embeddedCatalog
        Task {
            do {
                catalog = try await AppStoreCatalog.remoteCatalog()
            } catch {
                print("Fetching remote catalog failed: \(error)")
            }
        }
        
        let skView = self.view as! SKView
        
        let scene: SKScene = BIDStartScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        authenticateLocalPlayer()
        
        skView.presentScene(scene)
    }
    
    override var shouldAutorotate: Bool { return true }
    override var prefersStatusBarHidden: Bool { return true }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        } else {
            return .allButUpsideDown
        }
    }
    
    private func authenticateLocalPlayer() {
        let gcm = RBSGameCenterManager.shared()!
        gcm.shouldShowAuthenticationDialogImmediately = {
            let skView = self.view as! SKView
            return skView.scene!.isKind(of: BIDStartScene.self)
        }
        
        gcm.authenticateLocalPlayer { success in
            let skView = self.view as! SKView
            let startScene = skView.scene!.isKind(of: BIDStartScene.self) ? skView.scene as? BIDStartScene : nil
            if success {
                startScene?.gameCenterButtonEnabled = true
            } else {
                startScene?.gameCenterButtonEnabled = false
            }
        }
    }
    
    @objc func showOtherApps() {
        guard let catalog else { return }
        let hostingController = UIHostingController(rootView: AppStoreCatalogView(catalog: catalog, enableCloseButton: true))
        
        present(hostingController, animated: true)
    }
}

extension AppStoreCatalog {
    // This uses force-unwrap and force-try. Valid in this case, as the resources are required to be present in the build, and valid. If any of these fail due to changes, this will crash early in development builds.
    static var embeddedCatalog: AppStoreCatalog {
        let catalogUrl = Bundle.main.url(forResource: "RebisoftAppCatalog", withExtension: "json")!
        let data = try! Data(contentsOf: catalogUrl)
        let catalog = try! AppStoreCatalog(data: data, excluding: "814735204")
        return catalog
    }
    
    static func remoteCatalog() async throws -> AppStoreCatalog {
        let url = URL(string: "https://rebisoft.com/xp/RebisoftAppCatalog.json")!
        let (data, _) = try await URLSession.shared.data(from: url)

        return try AppStoreCatalog(data: data, excluding: "814735204")
    }
}
