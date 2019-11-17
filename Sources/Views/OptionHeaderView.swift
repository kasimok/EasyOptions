//
//  OptionHeaderView.swift
//  FilesBrowser
//
//  Created by William Zhang (RD-CN) on 2019/2/18.
//  Copyright © 2019 EvilisnJ. All rights reserved.
//

import UIKit

class OptionHeaderView: UIView {
    
    class func instanceFromNib() -> OptionHeaderView {
        return UINib(nibName: "OptionHeaderView", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! OptionHeaderView
    }
}
