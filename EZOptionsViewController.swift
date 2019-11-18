import Foundation


public class EZOptionsViewController: UINavigationController{
    
    let optionTableViewController: OptionsTableViewController
    
    ///Delegate View Controller responsible for model presentation between `presenting` view controller and `presented` view controller
    var halfModelTransitioningDelegate : HalfModalTransitioningDelegate!
    
    public init(options: [ToolbarOption],
         currentVC: UIViewController,
         selectedOption: ToolbarOption?) {
        //1. Make Optionstableviewcontroller
        optionTableViewController = OptionsTableViewController(options: options, currentVC: currentVC, selectedOption: selectedOption)
        
        super.init(rootViewController: optionTableViewController)
        
        halfModelTransitioningDelegate = HalfModalTransitioningDelegate(viewController: currentVC, presentingViewController: self, viewHeight: optionTableViewController.viewHeight, allowPanToMaximise: false)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = halfModelTransitioningDelegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
