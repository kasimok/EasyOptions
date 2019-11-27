import Foundation


open class EZOptionsViewController: UIViewController{
    
    let optionTableViewController: OptionsTableViewController
    
    ///Delegate View Controller responsible for model presentation between `presenting` view controller and `presented` view controller
    var halfModelTransitioningDelegate : HalfModalTransitioningDelegate!
    
    public weak var delegate: ToolbarOptionsControllerDelegate?{
        didSet{
            optionTableViewController.delegate = delegate
        }
    }
    
    public init(options: [ToolbarOption],
         currentVC: UIViewController,
         selectedOption: ToolbarOption?,
         wantsBlurDimmingView: Bool = false) {
        //1. Make Optionstableviewcontroller
        optionTableViewController = OptionsTableViewController(options: options, currentVC: currentVC, selectedOption: selectedOption)
        
        super.init(nibName: nil, bundle: nil)
        
        addChild(optionTableViewController)
        view.addSubview(optionTableViewController.view)
        
        halfModelTransitioningDelegate = HalfModalTransitioningDelegate(viewController: currentVC, presentingViewController: self, viewHeight: optionTableViewController.viewHeight, allowPanToMaximise: false, wantsBlurDimmingView: wantsBlurDimmingView)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = halfModelTransitioningDelegate
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
