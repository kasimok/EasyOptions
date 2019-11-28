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
    
    var selectedFlower: FlowerOption?

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
        let options: [FlowerOption] = flowerNameOptions.map{FlowerOption(name: $0, icon: UIImage(named: $0.lowercased()), description: $0)}
        let picker = EZOptionsViewController(options: options, currentVC: self, selectedOption: selectedFlower, wantsBlurDimmingView: true, iconTintColor: UIColor.red)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension ViewController: ToolbarOptionsControllerDelegate{
    func optionsViewController(_ optionsViewController: EZOptionsViewController, didSelectedNewOption option: ToolbarOption) {
        print("Clicked new \(option)")
        selectedFlower = option as? FlowerOption
    }
    
    func optionsViewController(_ optionsViewController: EZOptionsViewController, didTapOnSelected option: ToolbarOption) {
        print("Clicked current selected: \(option)")
    }
    
    
}

