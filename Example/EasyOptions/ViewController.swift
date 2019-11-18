//
//  ViewController.swift
//  EasyOptions
//
//  Created by kasimok on 11/15/2019.
//  Copyright (c) 2019 kasimok. All rights reserved.
//

import UIKit
import EasyOptions

struct FlowerOption: ToolbarOption {
    var name: String
    
    var icon: UIImage?
    
    var description: String
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showOptionMenu1(_ sender: Any) {
        let flowerNameOptions = ["Rose","Lily","Tulip","Orchids","Carnation"]
        /*
         let fileActionVC = FileMoreActionsViewController.init(broswerViewController: self, fileMoreActionsType: .single, selectedFile: file)
         fileActionVC.delegate = self
         let naviController = UINavigationController(rootViewController: fileActionVC)
         
         halfModalTransitioningDelegate = HalfModalTransitioningDelegate(viewController: self, presentingViewController: naviController, viewHeight: fileActionVC.viewHeight, allowPanToMaximise: fileActionVC.isMaximiseAllowed)
         naviController.modalPresentationStyle = .custom
         naviController.transitioningDelegate = halfModalTransitioningDelegate
         present(naviController, animated: true, completion: nil)
         */
        let options: [FlowerOption] = flowerNameOptions.map{FlowerOption(name: $0, icon: UIImage(named: $0), description: $0)}
        let picker = EZOptionsViewController(options: options, currentVC: self, selectedOption: nil)
        present(picker, animated: true, completion: nil)
    }
    
}

