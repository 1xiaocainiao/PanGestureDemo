//
//  OvlerayViewController.swift
//  ScaleViewDemo
//
//  Created by  on 2023/2/22.
//

import UIKit

enum PanEdge {
    case none
    case top
    case bottom
    case left
    case right
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center
}

/// 有镂空效果
class OvlerayViewController: UIViewController {
    
    var containerView: UIView!
    
    var overlay: OverlayView = OverlayView()
    
    var topConstraint: NSLayoutConstraint!
    var leftConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    var startPoint: CGPoint = .zero
    var panEdge: PanEdge = .none
    var startFrame: CGRect = .zero
    
    let maxWidth: CGFloat = 150
    let maxHeight: CGFloat = 150
    
    var panGesture: UIPanGestureRecognizer!
    
    lazy var shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.contents = UIImage(named: "test")?.cgImage
        
        containerView = UIView()
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(containerView)
        
        self.view.addSubview(overlay)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        overlay.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = overlay.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50)
        topConstraint.isActive = true
        leftConstraint = overlay.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50)
        leftConstraint.isActive = true
        widthConstraint = overlay.widthAnchor.constraint(equalToConstant: self.view.frame.width - 100)
        widthConstraint.isActive = true
        heightConstraint = overlay.heightAnchor.constraint(equalToConstant: 150)
        heightConstraint.isActive = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureAnction(_:)))
        self.view.addGestureRecognizer(panGesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        addLouKong()
    }
    
    /// 镂空部分
    func addLouKong() {
        self.view.layoutIfNeeded()
        
        let path = UIBezierPath(rect: containerView.frame)
        let overlayPath = UIBezierPath(rect: overlay.frame)
        path.append(overlayPath)
        
        shapeLayer.path = path.cgPath
        shapeLayer.fillRule = .evenOdd
        containerView.layer.mask = shapeLayer
    }
    
    @objc func handlePanGestureAnction(_ pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self.view)
        
        switch pan.state {
        case .began:
            startPoint = point
            startFrame = overlay.frame
            
            panEdge = calculatePanEdge(at: point)
        case .changed:
            updateOverlayFrame(at: point)
            
            addLouKong()
        default:
            panEdge = .none
        }
    }
    
    func calculatePanEdge(at point: CGPoint) -> PanEdge {
        let frame = overlay.frame.insetBy(dx: -20, dy: -20)
        
        if !CGRectContainsPoint(frame, point) {
            return .none
        }
        
        let cornerSize = CGSize(width: 50, height: 50)
        
        let topLeftRect = CGRect(origin: frame.origin, size: cornerSize)
        if topLeftRect.contains(point) {
            return .topLeft
        }
        
        let topRightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.minY), size: cornerSize)
        if topRightRect.contains(point) {
            return .topRight
        }
        
        let bottomLeftRect = CGRect(origin: CGPoint(x: frame.minX, y: frame.maxY - cornerSize.height), size: cornerSize)
        if bottomLeftRect.contains(point) {
            return .bottomLeft
        }
        
        let bottomRightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.maxY - cornerSize.height), size: cornerSize)
        if bottomRightRect.contains(point) {
            return .bottomRight
        }
        
        let topRect = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: cornerSize.height))
        if topRect.contains(point) {
            return .top
        }
        
        let bottomRect = CGRect(origin: CGPoint(x: frame.minX, y: frame.maxY - cornerSize.height), size: CGSize(width: frame.width, height: cornerSize.height))
        if bottomRect.contains(point) {
            return .bottom
        }
        
        let leftRect = CGRect(origin: frame.origin, size: CGSize(width: cornerSize.width, height: frame.height))
        if leftRect.contains(point) {
            return .left
        }
        
        let rightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.minY), size: CGSize(width: cornerSize.width, height: frame.height))
        if rightRect.contains(point) {
            return .right
        }
        
        return .center
    }
    
    func updateOverlayFrame(at point: CGPoint) {
        if panEdge == .none { return }
        
        let movedWidth = point.x  - startPoint.x
        let movedHeight = point.y - startPoint.y
        
        switch panEdge {
        case .topLeft:
            leftConstraint.constant =  min(CGRectGetMaxX(startFrame) - maxWidth, max(CGRectGetMinX(startFrame) + movedWidth,0))
            widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
            
            topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeight,max(CGRectGetMinY(startFrame) + movedHeight,0))
            heightConstraint.constant = CGRectGetMaxY(startFrame) - topConstraint.constant
        case .topRight:
            widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth,maxWidth),CGRectGetWidth(self.view.frame) - leftConstraint.constant)
            
            topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeight,max(CGRectGetMinY(startFrame) + movedHeight,0))
            heightConstraint.constant =  CGRectGetMaxY(startFrame) - topConstraint.constant
            
        case .bottomLeft:
            leftConstraint.constant = min(CGRectGetMaxX(startFrame) - maxWidth,max(CGRectGetMinX(startFrame) + movedWidth,0))
            widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
            
            heightConstraint.constant = min(CGRectGetHeight(self.view.frame) - CGRectGetMinY(overlay.frame),max(CGRectGetHeight(startFrame) + movedHeight,maxHeight))
            
        case .bottomRight:
            widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth,maxWidth),CGRectGetWidth(self.view.frame) - leftConstraint.constant)
            heightConstraint.constant = min(max(CGRectGetHeight(startFrame) + movedHeight,maxHeight),CGRectGetHeight(self.view.frame) - topConstraint.constant)
        
        case .center:
            leftConstraint.constant = min(max(startFrame.origin.x + movedWidth,0),CGRectGetWidth(self.view.frame) - CGRectGetWidth(startFrame))
            topConstraint.constant = min(max(startFrame.origin.y + movedHeight,0),CGRectGetHeight(self.view.frame) - CGRectGetHeight(startFrame))
            
        case .top:
            topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeight,max(CGRectGetMinY(startFrame) + movedHeight,0))
            heightConstraint.constant = CGRectGetMaxY(startFrame) - topConstraint.constant
            
        case .left:
            leftConstraint.constant =  min(CGRectGetMaxX(startFrame) - maxWidth, max(CGRectGetMinX(startFrame) + movedWidth,0))
            widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
            
        case .bottom:
            heightConstraint.constant = min(CGRectGetHeight(self.view.frame) - topConstraint.constant,max(CGRectGetHeight(startFrame) + movedHeight,maxHeight))
            
        case .right:
            widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth,maxWidth),CGRectGetWidth(self.view.frame) - leftConstraint.constant)
        case .none:
            print("")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
