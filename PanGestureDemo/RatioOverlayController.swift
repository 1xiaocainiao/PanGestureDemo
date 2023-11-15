//
//  RatioOverlayController.swift
//  PanGestureDemo
//
//  Created by sioeye on 2023/11/9.
//


/// 按比例
import UIKit

class RatioOverlayController: UIViewController {
    var containerView: UIView!
    
    var overlay: UIView!
    
    var topConstraint: NSLayoutConstraint!
    var leftConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    
    var startPoint: CGPoint = .zero
    var panEdge: PanEdge = .none
    var startFrame: CGRect = .zero
    
    let maxWidth: CGFloat = 80
    let maxHeight: CGFloat = 80
    
    var panGesture: UIPanGestureRecognizer!
    
    var ratio: CGFloat = 0
    
    lazy var ratioBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("比例", for: .normal)
        btn.addTarget(self, action: #selector(ratioBtnDidTouched(_:)), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.contents = UIImage(named: "test")?.cgImage
        
        containerView = UIView()
        containerView.backgroundColor = .gray
        self.view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 120).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16).isActive = true
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureAnction(_:)))
        containerView.addGestureRecognizer(panGesture)
        
        self.view.addSubview(ratioBtn)
        ratioBtn.translatesAutoresizingMaskIntoConstraints = false
        ratioBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ratioBtn.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20).isActive = true
        // Do any additional setup after loading the view.
    }
    
    @objc func ratioBtnDidTouched(_ sender: UIButton) {
        let freeAction = UIAlertAction(title: "自由比例", style: .default) { action in
            self.ratio = 0
            self.refreshRatioBtnTitle()
            self.resetOverlay()
        }
        
        let action_16_9 = UIAlertAction(title: "16 : 9", style: .default) { action in
            self.ratio = 16 / 9.0
            self.refreshRatioBtnTitle()
            self.resetOverlay()
        }
        
        let action_4_3 = UIAlertAction(title: "4 : 3", style: .default) { action in
            self.ratio = 4 / 3.0
            self.refreshRatioBtnTitle()
            self.resetOverlay()
        }
        
        let actionCancel = UIAlertAction(title: "取消", style: .cancel) { action in
            
        }
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(freeAction)
        actionSheet.addAction(action_16_9)
        actionSheet.addAction(action_4_3)
        actionSheet.addAction(actionCancel)
        present(actionSheet, animated: true)
    }
    
    func refreshRatioBtnTitle() {
        var title: String = "比例"
        if ratio == 0 {
            title = "自由比例"
        } else if ratio == 16 / 9.0 {
            title = "16 : 9"
        } else if ratio == 4 / 3.0 {
            title = "4 : 3"
        }
        ratioBtn.setTitle(title, for: .normal)
    }
    
    func resetOverlay() {
        if overlay != nil {
            overlay.removeFromSuperview()
            overlay = nil
        }
        
        overlay = UIView()
        overlay.backgroundColor = .red.withAlphaComponent(0.3)
        containerView.addSubview(overlay)
        
        if ratio == 0 {
            overlay.translatesAutoresizingMaskIntoConstraints = false
            topConstraint = overlay.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50)
            topConstraint.isActive = true
            leftConstraint = overlay.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 50)
            leftConstraint.isActive = true
            let defaultWidth: CGFloat = 150
            widthConstraint = overlay.widthAnchor.constraint(equalToConstant: defaultWidth)
            widthConstraint.isActive = true
            heightConstraint = overlay.heightAnchor.constraint(equalToConstant: defaultWidth)
            heightConstraint.isActive = true
        } else {
            /// 此处逻辑抄的 TOCropViewController  方法 - (void)setAspectRatio:(CGSize)aspectRatio animated:(BOOL)animated
            /// 此处未记录按比例后的 坐标计算，旋转后就不对了，后续可以自行处理
            let imageViewSize = containerView.frame.size
            var boxFrame: CGRect = CGRect(x: 0, y: 0, width: imageViewSize.width, height: imageViewSize.height)
            var boxIsPortrait: Bool = false
            if ratio == 1.0 {
                boxIsPortrait = imageViewSize.width > imageViewSize.height
            } else {
                boxIsPortrait = ratio < 1
            }
            if boxIsPortrait {
                let newWidth = boxFrame.height * ratio
                var delta = boxFrame.width - newWidth
                boxFrame.size.width = newWidth
                boxFrame.origin.x += delta * 0.5
                
                if delta < CGFloat.ulpOfOne {
                    boxFrame.origin.x = 0
                }
                
                let boundsWidth = imageViewSize.width
                if newWidth > boundsWidth {
                    let scale = boundsWidth / newWidth
                    let newHeight = boxFrame.height * scale
                    delta = boxFrame.height - newHeight
                    boxFrame.size.height = newHeight
                    boxFrame.origin.y += delta * 0.5
                    boxFrame.size.width = boundsWidth
                }
            } else {
                let newHeight = boxFrame.width / ratio
                var delta = boxFrame.height - newHeight
                boxFrame.size.height = newHeight
                boxFrame.origin.y += delta * 0.5
                
                if delta < CGFloat.ulpOfOne {
                    boxFrame.origin.y = 0
                }
                
                let boundsHeight = imageViewSize.height
                if newHeight > boundsHeight {
                    let scale = boundsHeight / newHeight
                    
                    let newWidth = boxFrame.width * scale
                    delta = boxFrame.width - newWidth
                    boxFrame.size.width = newWidth
                    boxFrame.origin.x += delta * 0.5
                    
                    boxFrame.size.height = boundsHeight
                }
            }
            overlay.translatesAutoresizingMaskIntoConstraints = false
            topConstraint = overlay.topAnchor.constraint(equalTo: containerView.topAnchor, constant: boxFrame.minY)
            topConstraint.isActive = true
            leftConstraint = overlay.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: boxFrame.minX)
            leftConstraint.isActive = true
            widthConstraint = overlay.widthAnchor.constraint(equalToConstant: boxFrame.width)
            widthConstraint.isActive = true
            heightConstraint = overlay.heightAnchor.constraint(equalToConstant: boxFrame.height)
            heightConstraint.isActive = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
        
        resetOverlay()
    }
    
    @objc func handlePanGestureAnction(_ pan: UIPanGestureRecognizer) {
        let point = pan.location(in: containerView)
        
        switch pan.state {
        case .began:
            startPoint = point
            startFrame = overlay.frame
            
            panEdge = calculatePanEdge(at: point)
        case .changed:
            updateOverlayFrame(at: point)
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
            if ratio != 0 {
                let top = min(startFrame.maxY - maxHeight,max(startFrame.minY + movedWidth, 0))
                let height = overlay.frame.maxY - top
                let maxWidth = overlay.frame.maxX
                let maxHeight = maxWidth / ratio
                
                topConstraint.constant = max(top, startFrame.maxY - maxHeight)
                heightConstraint.constant = min(height, maxHeight)
                widthConstraint.constant = heightConstraint.constant * ratio
                leftConstraint.constant = startFrame.maxX - widthConstraint.constant
            } else {
                leftConstraint.constant =  min(startFrame.maxX - maxWidth, max(startFrame.minX + movedWidth,0))
                widthConstraint.constant = startFrame.maxX - leftConstraint.constant
                
                topConstraint.constant = min(startFrame.maxY - maxHeight,max(startFrame.minY + movedHeight,0))
                heightConstraint.constant = startFrame.maxY - topConstraint.constant
            }
        case .topRight:
            if ratio != 0 {
                let top = min(startFrame.maxY - maxHeight,max(startFrame.minY - movedWidth, 0))
                let height = overlay.frame.maxY - top
                let maxWidth = containerView.frame.width - overlay.frame.minX
                let maxHeight = maxWidth / ratio
                
                topConstraint.constant = max(top, startFrame.maxY - maxHeight)
                heightConstraint.constant = min(height, maxHeight)
                widthConstraint.constant = heightConstraint.constant * ratio
            } else {
                widthConstraint.constant = min(max(startFrame.width + movedWidth, maxWidth),containerView.frame.width - leftConstraint.constant)
                
                topConstraint.constant = min(startFrame.maxY - maxHeight,max(startFrame.minY + movedHeight,0))
                heightConstraint.constant =  startFrame.maxY - topConstraint.constant
            }
            
        case .bottomLeft:
            if ratio != 0 {
                let calculatorMaxWidth = maxHeight * ratio
                let left = min(startFrame.maxX - calculatorMaxWidth,max(CGRectGetMinX(startFrame) + movedWidth,0))
                
                let width = overlay.frame.maxX - left
                let maxHeight = containerView.frame.height - overlay.frame.minY
                let maxWidth = maxHeight * ratio
                
                leftConstraint.constant = max(left, startFrame.maxX - maxWidth)
                
                widthConstraint.constant = min(width, maxWidth)
                heightConstraint.constant = widthConstraint.constant / ratio
            } else {
                leftConstraint.constant = min(startFrame.maxX - maxWidth,max(CGRectGetMinX(startFrame) + movedWidth,0))
                widthConstraint.constant = startFrame.maxX - leftConstraint.constant
                
                heightConstraint.constant = min(containerView.frame.height - overlay.frame.minY, max(startFrame.height + movedHeight, maxHeight))
            }
            
        case .bottomRight:
            if ratio != 0 {
                let height = min(containerView.frame.height - topConstraint.constant, max(startFrame.height + movedHeight, maxHeight))
                let maxHeight = (containerView.frame.width - overlay.frame.minX) / ratio
                
                heightConstraint.constant = min(height, maxHeight)
                widthConstraint.constant = heightConstraint.constant * ratio
            } else {
                widthConstraint.constant = min(max(startFrame.width + movedWidth, maxWidth), containerView.frame.width - leftConstraint.constant)
                heightConstraint.constant = min(max(startFrame.height + movedHeight, maxHeight),containerView.frame.height - topConstraint.constant)
            }
        
        case .center:
            leftConstraint.constant = min(max(startFrame.origin.x + movedWidth,0), containerView.frame.width - CGRectGetWidth(startFrame))
            topConstraint.constant = min(max(startFrame.origin.y + movedHeight,0), containerView.frame.height - startFrame.height)
        case .top:
            if ratio != 0 {
                let top = min(startFrame.maxY - maxHeight,max(startFrame.minY + movedHeight,0))
                let height = overlay.frame.maxY - top
                let maxWidth = containerView.frame.width - overlay.frame.minX
                let maxHeight = maxWidth / ratio
                
                topConstraint.constant = max(top, startFrame.maxY - maxHeight)
                heightConstraint.constant = min(height, maxHeight)
                widthConstraint.constant = heightConstraint.constant * ratio
            } else {
                topConstraint.constant = min(startFrame.maxY - maxHeight,max(startFrame.minY + movedHeight,0))
                heightConstraint.constant = startFrame.maxY - topConstraint.constant
            }
        case .bottom:
            if ratio != 0 {
                let height = min(containerView.frame.height - topConstraint.constant, max(startFrame.height + movedHeight, maxHeight))
                let maxHeight = (containerView.frame.width - overlay.frame.minX) / ratio
                
                heightConstraint.constant = min(height, maxHeight)
                widthConstraint.constant = heightConstraint.constant * ratio
            } else {
                heightConstraint.constant = min(containerView.frame.height - topConstraint.constant,max(startFrame.height + movedHeight, maxHeight))
            }
        case .left:
            if ratio != 0 {
                let calculatorMaxWidth = maxHeight * ratio
                let left = min(startFrame.maxX - calculatorMaxWidth, max(startFrame.minX + movedWidth,0))
                
                let width = overlay.frame.maxX - left
                let maxHeight = containerView.frame.height - overlay.frame.minY
                let maxWidth = maxHeight * ratio
                
                leftConstraint.constant = max(left, startFrame.maxX - maxWidth)
                
                widthConstraint.constant = min(width, maxWidth)
                heightConstraint.constant = widthConstraint.constant / ratio
                
            } else {
                leftConstraint.constant =  min(startFrame.maxX - maxWidth, max(startFrame.minX + movedWidth,0))
                widthConstraint.constant = startFrame.maxX - leftConstraint.constant
            }
        case .right:
            if ratio != 0 {
                let calculatorMaxWidth = maxHeight * ratio
                let width = min(max(startFrame.width + calculatorMaxWidth, maxWidth),containerView.frame.width - leftConstraint.constant)
                let maxWidth = (containerView.frame.height - overlay.frame.minY) * ratio
                
                widthConstraint.constant = min(width, maxWidth)
                heightConstraint.constant = widthConstraint.constant / ratio
            } else {
                widthConstraint.constant = min(max(startFrame.width + movedWidth,maxWidth),containerView.frame.width - leftConstraint.constant)
            }
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
