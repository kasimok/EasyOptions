import UIKit

public class ImageUtils : NSObject {

    //// Cache

    private struct Cache {
        static var imageOfCheckMark: UIImage?
        static var checkMarkTargets: [AnyObject]?
    }

    //// Drawing Methods

    @objc dynamic public class func drawCheckMark(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 18, height: 18), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 18, height: 18), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 18, y: resizedFrame.height / 18)


        //// Color Declarations
        let e2e2e2 = UIColor(red: 0.738, green: 0.727, blue: 0.727, alpha: 1.000)

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 6, y: 13.17))
        bezierPath.addLine(to: CGPoint(x: 1.83, y: 9))
        bezierPath.addLine(to: CGPoint(x: 0.41, y: 10.41))
        bezierPath.addLine(to: CGPoint(x: 6, y: 16))
        bezierPath.addLine(to: CGPoint(x: 18, y: 4))
        bezierPath.addLine(to: CGPoint(x: 16.59, y: 2.59))
        bezierPath.addLine(to: CGPoint(x: 6, y: 13.17))
        bezierPath.close()
        bezierPath.usesEvenOddFillRule = true
        e2e2e2.setFill()
        bezierPath.fill()
        
        context.restoreGState()

    }

    //// Generated Images

    @objc dynamic public class var imageOfCheckMark: UIImage {
        if Cache.imageOfCheckMark != nil {
            return Cache.imageOfCheckMark!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 18, height: 18), false, 0)
            ImageUtils.drawCheckMark()

        Cache.imageOfCheckMark = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfCheckMark!
    }

    //// Customization Infrastructure

    @objc @IBOutlet dynamic var checkMarkTargets: [AnyObject]! {
        get { return Cache.checkMarkTargets }
        set {
            Cache.checkMarkTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: ImageUtils.imageOfCheckMark)
            }
        }
    }




    @objc(ImageUtilsResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
