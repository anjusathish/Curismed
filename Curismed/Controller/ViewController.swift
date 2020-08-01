//
//  ViewController.swift
//  Curismed
//
//  Created by PraveenKumar R on 02/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import SwiftyGif
import CoreTelephony


class ViewController: UIViewController {
  
  @IBOutlet weak var imageViewCurismedGif: UIImageView!
  @IBOutlet weak var imageViewAmromedLogoGif: UIImageView!
  
  //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let gif = try UIImage(gifName: "Curismed_Logo_Animation.gif")
            let gif1 = try UIImage(gifName: "Amromed-logo_Final_2")
            self.imageViewCurismedGif.setGifImage(gif)
            self.imageViewAmromedLogoGif.setGifImage(gif1)
            imageViewCurismedGif.delegate = self
            imageViewAmromedLogoGif.delegate = self
            
        }catch{
            print(error)
        }
    }
  
    @objc func splashTimeOut(sender : Timer){
        
        let viewController = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "LoginVC")
        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navController
    }
  
}
extension ViewController : SwiftyGifDelegate {
    
    func gifURLDidFinish(sender: UIImageView) {
        print("gifURLDidFinish")
    }
    
    func gifURLDidFail(sender: UIImageView) {
        print("gifURLDidFail")
    }
    
    func gifDidStart(sender: UIImageView) {
        print("gifDidStart")
    }
    
    func gifDidLoop(sender: UIImageView) {
        print("gifDidLoop")
        let viewController = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "LoginVC")
        let navController = UINavigationController(rootViewController: viewController)
        navController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navController
    }
    
    func gifDidStop(sender: UIImageView) {
        print("gifDidStop")
    }
}
