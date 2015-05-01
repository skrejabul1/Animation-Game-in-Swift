import UIKit

class ViewController: UIViewController {

    var newView = UIView()
    var animator: UIDynamicAnimator?
    var pushBehavior: UIPushBehavior?
    
    func newViewWithCenter(center: CGPoint, backgroundColor: UIColor) -> UIView {
     
        newView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        newView.backgroundColor = backgroundColor
        newView.center = view.center
        return newView
    }
    
    
    func createGestureRexognizer() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func handleTap(tap: UITapGestureRecognizer) {
        
        let tapPoint = tap.locationInView(view)
        let squareLabelCenterPoint = newView.center
        let deltaX = tapPoint.x - squareLabelCenterPoint.x
        let deltaY = tapPoint.y - squareLabelCenterPoint.y
        let angle = atan2(deltaY, deltaX)
        pushBehavior?.angle = angle
        let distanceBetweenPoints = sqrt(pow(tapPoint.x - squareLabelCenterPoint.x,2.0) + pow(tapPoint.y - squareLabelCenterPoint.y, 2.0))
        pushBehavior?.magnitude = distanceBetweenPoints / 200.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let topView = newViewWithCenter(CGPoint(x: 100, y: 0), backgroundColor: UIColor.greenColor())
        let bottomView = newViewWithCenter(CGPoint(x: 100, y: 50), backgroundColor: UIColor.redColor())
        pushBehavior = UIPushBehavior(items: [topView,bottomView], mode: .Continuous)
        
        view.addSubview(topView)
        view.addSubview(bottomView)
        
        animator = UIDynamicAnimator(referenceView: view)
        //let gravity = UIGravityBehavior(items: [topView, bottomView])
        //animator?.addBehavior(gravity)
        let collision = UICollisionBehavior(items: [topView, bottomView])
        animator?.addBehavior(collision)
        
        let moreElasticItem = UIDynamicItemBehavior(items: [bottomView])
        moreElasticItem.elasticity = 1
        //moreElasticItem.density = 0.1
        moreElasticItem.allowsRotation = true

        let lessElasticItems = UIDynamicItemBehavior(items: [topView])
        lessElasticItems.elasticity = 1
        //lessElasticItems.density = 0.1
        lessElasticItems.allowsRotation = true

        collision.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(moreElasticItem)
        animator?.addBehavior(lessElasticItems)
        animator?.addBehavior(pushBehavior)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createGestureRexognizer()
    }
}