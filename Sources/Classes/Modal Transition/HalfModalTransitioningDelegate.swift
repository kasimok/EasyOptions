import UIKit

class HalfModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var viewController: UIViewController
    var presentingViewController: UIViewController
    var interactionController: HalfModalInteractiveTransition
    
    var interactiveDismiss = false
    
    var modalViewHeight: CGFloat = 0
    
    var allowMaximum: Bool = false
    
    var wantsBlurBg: Bool = false
    
    init(viewController: UIViewController, presentingViewController: UIViewController, viewHeight heightForModalMode: CGFloat,allowPanToMaximise: Bool, wantsBlurDimmingView: Bool = false) {
        self.viewController = viewController
        self.presentingViewController = presentingViewController
        self.interactionController = HalfModalInteractiveTransition(viewController: self.viewController, withView: self.presentingViewController.view, presentingViewController: self.presentingViewController)
        self.modalViewHeight = heightForModalMode
        self.allowMaximum = allowPanToMaximise
        self.wantsBlurBg = wantsBlurDimmingView
        super.init()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HalfModalTransitionAnimator(type: .Dismiss)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfModalPresentationController(presentedViewController: presented, presenting: presenting,modalHeight: modalViewHeight, allowPanToMaximise: allowMaximum, wantsBlur: wantsBlurBg)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactiveDismiss {
            return self.interactionController
        }
        
        return nil
    }
    
}
