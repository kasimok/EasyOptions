import UIKit

enum ModalScaleState {
    case fullScreen
    case halfScreen
}

class HalfModalPresentationController : UIPresentationController {
    var isMaximized: Bool = false
    
    var _dimmingView: UIView?
    var panGestureRecognizer: UIPanGestureRecognizer
    var direction: CGFloat = 0
    var state: ModalScaleState = .halfScreen
    var halfHeight: CGFloat = 200
    var wantsBlurDimmingView :Bool = false
    var dimmingView: UIView {
        if let dimmedView = _dimmingView {
            return dimmedView
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height))
        
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.35)
        if wantsBlurDimmingView{
            // Blur Effect
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            view.addSubview(blurEffectView)
            
            // Vibrancy Effect
            let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
            let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
            vibrancyEffectView.frame = view.bounds
            
            // Add the vibrancy view to the blur view
            blurEffectView.contentView.addSubview(vibrancyEffectView)
        }
        _dimmingView = view
        let panGes = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        _dimmingView?.addGestureRecognizer(panGes)
        return view
    }
    
    /// tap to dismiss
    @objc func dismiss(_ sender: UITapGestureRecognizer){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    override func containerViewDidLayoutSubviews() {
        dimmingView.frame = CGRect(x: 0, y: 0, width: containerView!.bounds.width, height: containerView!.bounds.height)
        adjustPresentedViewFrame()
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, modalHeight: CGFloat, allowPanToMaximise: Bool = true, wantsBlur: Bool = false) {
        self.panGestureRecognizer = UIPanGestureRecognizer()
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.halfHeight = modalHeight
        self.wantsBlurDimmingView = wantsBlur
        if allowPanToMaximise{
            panGestureRecognizer.addTarget(self, action: #selector(onPan(pan:)))
            presentedViewController.view.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    @objc func onPan(pan: UIPanGestureRecognizer) -> Void {
        let endPoint = pan.translation(in: pan.view?.superview)
        
        switch pan.state {
        case .began:
            presentedView!.frame.size.height = containerView!.frame.height
        case .changed:
            let velocity = pan.velocity(in: pan.view?.superview)
            
            switch state {
            case .halfScreen:
                presentedView!.frame.origin.y = endPoint.y + containerView!.frame.height / 2
            case .fullScreen:
                presentedView!.frame.origin.y = endPoint.y
            }
            direction = velocity.y
            
            break
        case .ended:
            if direction < 0 {
                changeScale(to: .fullScreen)
            } else {
                if state == .fullScreen {
                    changeScale(to: .halfScreen)
                } else {
                    presentedViewController.dismiss(animated: true, completion: nil)
                }
            }
            
            break
        default:
            break
        }
    }
    
    fileprivate func adjustPresentedViewFrame() {
        if let presentedView = presentedView, let containerView = self.containerView{
            presentedView.frame = containerView.frame
            let containerFrame = containerView.frame
            let halfFrame = CGRect(origin: CGPoint(x: 0, y: containerFrame.height - self.halfHeight),
                                   size: CGSize(width: containerFrame.width, height: self.halfHeight))
            let frame = state == .fullScreen ? containerView.frame : halfFrame
            
            presentedView.frame = frame
        }
        
    }
    
    func changeScale(to state: ModalScaleState) {
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { () -> Void in
            self.adjustPresentedViewFrame()
            
            if let navController = self.presentedViewController as? UINavigationController {
                self.isMaximized = true
                
                navController.setNeedsStatusBarAppearanceUpdate()
                
                // Force the navigation bar to update its size
                navController.isNavigationBarHidden = true
                navController.isNavigationBarHidden = false
            }
        }, completion: { (isFinished) in
            self.state = state
        })
        
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: containerView!.bounds.height - halfHeight, width: containerView!.bounds.width, height: halfHeight)
    }
    
    override func presentationTransitionWillBegin() {
        let dimmedView = dimmingView
        
        if let containerView = self.containerView, let coordinator = presentingViewController.transitionCoordinator {
            
            dimmedView.alpha = 0
            containerView.addSubview(dimmedView)
            dimmedView.addSubview(presentedViewController.view)
            
            coordinator.animate(alongsideTransition: { (context) -> Void in
                dimmedView.alpha = 1
                //we want no transform here
                //self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentingViewController.transitionCoordinator {
            
            coordinator.animate(alongsideTransition: { (context) -> Void in
                self.dimmingView.alpha = 0
                self.presentingViewController.view.transform = CGAffineTransform.identity
            }, completion: { (completed) -> Void in
            })
            
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
            _dimmingView = nil
            
            isMaximized = false
        }
    }
}

protocol HalfModalPresentable { }

extension HalfModalPresentable where Self: UIViewController {
    func maximizeToFullScreen() -> Void {
        if let presetation = navigationController?.presentationController as? HalfModalPresentationController {
            presetation.changeScale(to: .fullScreen)
        }
    }
}

extension HalfModalPresentable where Self: UINavigationController {
    func isHalfModalMaximized() -> Bool {
        if let presentationController = presentationController as? HalfModalPresentationController {
            return presentationController.isMaximized
        }
        
        return false
    }
}
