import UIKit

open class OptionHeaderView: UIView {
    
    public class func instanceFromNib() -> OptionHeaderView {
        return UINib(nibName: "OptionHeaderView", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: nil, options: nil)[0] as! OptionHeaderView
    }
}
