import Foundation

///The protocol for the toolbar's options, your custom toolbar option shoud adopt this protocol
public protocol ToolbarOption: CustomStringConvertible{
    var name: String {set get}
    var icon: UIImage? {set get}
}


public protocol ToolbarOptionsControllerDelegate: class {
    /// Did selected on a new option(diffrent than current option if any)
    func optionsViewController(_ optionsViewController: ToolbarOptionsViewControllerType, didSelectedNewOption option: ToolbarOption)
    /// Did selected on current option(if any)
    func optionsViewController(_ optionsViewController: ToolbarOptionsViewControllerType, didTapOnCurrentOption option: ToolbarOption)
}

///The protocol for presented toolbar options view controller
public protocol ToolbarOptionsViewControllerType: class{
    
    /// view's content height
    var viewHeight: CGFloat {get}
    
    /// all available options
    var options: [ToolbarOption] {get set}
    
    /// current selected option, setting it to none nil will have a checkmark on line end
    var currentOption: ToolbarOption? {get set}
    
    /// presenting view controller
    var currentVC: UIViewController? {get set}
    
}


