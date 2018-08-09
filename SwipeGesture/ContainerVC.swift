//
//  ContainerVC.swift
//  SwipeGesture
//
//  Created by shahnawaz on 8/8/18.
//

import UIKit

class ContainerVC: UIViewController {
    
    var currentVC: UIViewController? = nil
    
    @IBOutlet weak var containerView: UIView!
    
    fileprivate lazy var homeVC: HomeViewController = {
        
        let viewController = self.childViewControllers[0]
        //self.add(asChildViewController: viewController)
        
        return viewController as! HomeViewController
    }()
    
    fileprivate lazy var discoverVC: DiscoverViewController = {
        
        let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "discoverVC"))! as! DiscoverViewController
        //self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    fileprivate lazy var alertVC: AlertViewController = {
        
        let viewController = (self.storyboard?.instantiateViewController(withIdentifier: "alertVC"))! as! AlertViewController
        //self.add(asChildViewController: viewController)
        
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        currentVC = homeVC
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        
        containerView.addGestureRecognizer(leftSwipe)
        containerView.addGestureRecognizer(rightSwipe)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnAction(_ sender: UIButton) {
        
        let newVC: UIViewController?
        
        if currentVC == homeVC{
            newVC = discoverVC
        }else if currentVC == discoverVC{
            newVC = alertVC
        }else{
            return
        }
        cycleFromViewController(oldVC: currentVC!, newVC: newVC!)
    }
    
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        
        if (sender.direction == .left) {
            print("Swipe Left")
            
            let newVC: UIViewController?
            
            if currentVC == homeVC{
                newVC = discoverVC
            }else if currentVC == discoverVC{
                newVC = alertVC
            }else{
                return
            }
            cycleFromViewController(oldVC: currentVC!, newVC: newVC!)
            
        }
        
        if (sender.direction == .right) {
            print("Swipe Right")
            
            let newVC: UIViewController?
            
            if currentVC == alertVC{
                newVC = discoverVC
            }else if currentVC == discoverVC{
                newVC = homeVC
            }else{
                return
            }
            cycleFromViewController(oldVC: currentVC!, newVC: newVC!)
           
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ContainerVC{
    
    func cycleFromViewController(oldVC: UIViewController, newVC: UIViewController)  {
        
        if oldVC == newVC{
            return
        }
        oldVC.willMove(toParentViewController: nil)
        self.addChildViewController(newVC)
        
        //containerView.addSubview(newVC.view)
        
        newVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //find out left or right animation
        
        var xPos = 0.0
        
        if (newVC == discoverVC && oldVC == homeVC) || (newVC == alertVC && oldVC == discoverVC) || (newVC == alertVC && oldVC == homeVC){
            xPos = Double(containerView.bounds.size.width)
        }else{
            xPos = -(Double)(containerView.bounds.size.width)
        }
        
        newVC.view.frame = CGRect(x: CGFloat(xPos), y: containerView.bounds.origin.y, width: containerView.bounds.size.width, height: containerView.bounds.size.height)
        
        self.transition(from: oldVC, to: newVC, duration: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
            //oldVC.view.alpha = 0
            //newVC.view.alpha = 0
            newVC.view.frame = self.containerView.bounds
        }, completion: { finished in
            
            
            //newVC.view.alpha = 1
            oldVC.view.removeFromSuperview()
            oldVC.removeFromParentViewController()
            newVC.didMove(toParentViewController: self)
        })
        currentVC = newVC
        
        
    }
}
