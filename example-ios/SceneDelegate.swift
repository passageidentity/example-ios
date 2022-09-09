//
//  SceneDelegate.swift
//  example-ios
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let incomingURL = userActivity.webpageURL,
            let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
            let magicLink = components.queryItems?.filter({$0.name == "psg_magic_link"}).first?.value else {
            return
        }
        guard let navigationController = window?.rootViewController as? UINavigationController,
              let checkEmailViewController = navigationController.topViewController as? CheckEmailViewController else {
            return
        }
        checkEmailViewController.handleMagicLink(magicLink)
    }

}
