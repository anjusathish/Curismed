//
//  MenuViewController.swift
//  Curismed
//
//  Created by PraveenKumar R on 03/05/20.
//  Copyright © 2020 Praveen. All rights reserved.
//

import UIKit
import SideMenuSwift

class MenuViewController: BaseViewController {
  
  @IBOutlet weak var menuTableView: UITableView!
  
  var menuItems : [String] = ["My Appointments", "About Us", "Help", "Logout"]
  var menuIcons = [UIImage(named: "Appointment"), UIImage(named: "AboutUs"), UIImage(named: "Help"), UIImage(named: "Logout")]
  var selectedIndex  = 0
  var selectedSubIndex : Int?
  var selectedAddIndex : Int?
  
  //MARK:- ViewController LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    guard let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC") else { return }
    let helpVC = UIStoryboard.helpStoryboard().instantiateViewController(withIdentifier: "Help")
    let AboutUsVC = UIStoryboard.aboutUsStoryboard().instantiateViewController(withIdentifier: "AboutUs")
    
    cacheViewControllers(controller: [dashboardVC,helpVC,AboutUsVC], forKey: ["dashboardVC","Help","AboutUs"])
  }
  
  func cacheViewControllers(controller : [UIViewController], forKey key : [String]) {
    
    for (vc, _key) in zip(controller, key) {
      let navigationController = UINavigationController(rootViewController: vc)
      navigationController.isNavigationBarHidden = true
      sideMenuController?.cache(viewControllerGenerator: { navigationController }, with: _key)
    }
  }
  
  func alert(){
    let alert = UIAlertController(title: "", message: "Do you want to logout?", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: {
      action in
      self.selectedIndex = 0
      self.menuTableView.reloadData()
    }))
    alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: {
      action in
      let viewController = UIStoryboard.onBoardingStoryboard().instantiateViewController(withIdentifier: "LoginVC")
      let navController = UINavigationController(rootViewController: viewController)
      navController.isNavigationBarHidden = true
      UIApplication.shared.windows.first?.rootViewController = navController
        
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

//MARK:- UITableViewDataSource,UITableViewDelegate Methodes

extension MenuViewController: UITableViewDataSource,UITableViewDelegate{
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuTableViewCell
    cell.menuLabel.text = menuItems[indexPath.row]
    cell.iconView.image = menuIcons[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch indexPath.row {
      
    case 0: sideMenuController?.setContentViewController(with: "dashboardVC")
      
    case 1:  sideMenuController?.setContentViewController(with: "AboutUs")
      
    case 2: sideMenuController?.setContentViewController(with: "Help")
      
    case 3: alert()
      
    default: break
    }
    
    sideMenuController?.hideMenu()
    menuTableView.reloadData()
    
  }
  
}
