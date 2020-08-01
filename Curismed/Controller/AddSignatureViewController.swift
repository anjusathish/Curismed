//
//  AddSignatureViewController.swift
//  Curismed
//
//  Created by PraveenKumar R on 09/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit

protocol SignatureDelegateMethode {
  func getSignatureImage(_ signatureImage: UIImage)
}


class AddSignatureViewController: UIViewController {
  
  @IBOutlet weak var signatureView: YPDrawSignatureView!
  var delegate: SignatureDelegateMethode?
  
  let window = UIApplication.shared.windows.first
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.contentSizeInPopup = CGSize(width: window!.frame.width, height: window!.frame.height - 200)
    signatureView.delegate = self
    
    if let _signatureImage = self.signatureView.getCroppedSignature() {
      print(_signatureImage)
    }
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if let signatureImage = self.signatureView.getSignature(scale: 10) {
      print(signatureImage)
    }
  }
  
  // Function for clearing the content of signature view
  @IBAction func clearSignature(_ sender: UIButton) {
    self.signatureView.clear()
  }
  
  @IBAction func closeAction(_ sender: UIButton){
    self.dismiss(animated: true, completion: nil)
  }
  
  // Function for saving signature
  @IBAction func saveSignature(_ sender: UIButton) {
    
    if let signatureImage = self.signatureView.getSignature(scale: 10) {
      
      UIImageWriteToSavedPhotosAlbum(signatureImage, nil, nil, nil)
      
      self.signatureView.clear()
      
      self.dismiss(animated: true, completion: nil)
    }
  }
  
}

//MRAK:- YPSignatureDelegate Methodes
extension AddSignatureViewController: YPSignatureDelegate{
  
  func didStart(_ view : YPDrawSignatureView) {
    print("Started Drawing")
  }
  
  func didFinish(_ view : YPDrawSignatureView) {
    
    if let _getSignatureImage = view.getCroppedSignature() {
      
      delegate?.getSignatureImage(_getSignatureImage)
    }
    
    print("Finished Drawing")
  }
}
