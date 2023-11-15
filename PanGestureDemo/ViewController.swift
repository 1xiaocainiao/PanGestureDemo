//
//  ViewController.swift
//  ScaleViewDemo
//
//  Created by  on 2023/2/22.
//

import UIKit

enum BtnType {
    case None
    case LeftUp
    case RightUp
    case LeftDown
    case RighDown
    case Center
    case Top
    case Left
    case Bottom
    case Right
}

class ViewController: UIViewController {
    
    private var _demoView: UIView!
    private var _imageView1: UIImageView!
    private var _imageView2: UIImageView!
    private var _imageView3: UIImageView!
    private var _imageView4: UIImageView!
    
    private var layoutConstraint_left: NSLayoutConstraint!
    private var layoutConstraint_width: NSLayoutConstraint!
    private var layoutConstraint_top: NSLayoutConstraint!
    private var layoutConstraint_height: NSLayoutConstraint!
    
    private var startedPoint: CGPoint = CGPointZero
    private var btnType: BtnType = .None
    private var demoViewStartedFrame: CGRect = CGRectZero
    private var isMoveBegin: Bool = false
    
    private let maxWidth: CGFloat = 3*40
    private let maxHeight: CGFloat = 3*40

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        // Do any additional setup after loading the view.
    }

    @IBAction func push(_ sender: UIButton) {
        self.navigationController?.pushViewController(OvlerayViewController(), animated: true)
    }
    
    @IBAction func pushRatio(_ sender: UIButton) {
        self.navigationController?.pushViewController(RatioOverlayController(), animated: true)
    }
}

extension ViewController{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point: CGPoint = touch?.location(in: self.view) ?? CGPointZero
        startedPoint = point
        demoViewStartedFrame = self.demoView.frame
        //最原始的位置
        
        if CGRectContainsPoint(demoView.frame, point){
            let pointFingerInView: CGPoint = touch?.location(in: demoView) ?? CGPointZero
            if CGRectContainsPoint(CGRectMake(0, 0, 50, 50), pointFingerInView){
                btnType = .LeftUp
            }else if CGRectContainsPoint(CGRectMake(demoView.frame.size.width - 50, 0, 50, 50), pointFingerInView){
                btnType = .RightUp
            }else if CGRectContainsPoint(CGRectMake(0,  demoView.frame.size.height - 50, 50, 50), pointFingerInView){
                btnType = .LeftDown
            }else if CGRectContainsPoint(CGRectMake( demoView.frame.size.width - 50,  demoView.frame.size.height - 50, 50, 50), pointFingerInView){
                btnType = .RighDown
            } else if CGRectContainsPoint(CGRectMake(50, 0, demoView.frame.width - 100, 30), pointFingerInView) {
                btnType = .Top
            } else if CGRectContainsPoint(CGRect(x: 0, y: 50, width: 30, height: demoView.frame.height - 100), pointFingerInView) {
                btnType = .Left
            } else if CGRectContainsPoint(CGRect(x: 50, y: demoView.frame.height - 30, width: demoView.frame.width - 100, height: 30), pointFingerInView) {
                btnType = .Bottom
            } else if CGRectContainsPoint(CGRect(x: demoView.frame.width - 30, y: 0, width: 30, height: demoView.frame.height - 100), pointFingerInView) {
                btnType = .Right
            } else {
                btnType = .Center
            }
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let point: CGPoint = touch?.location(in: self.view) ?? CGPointZero
        
        let movedWidth = point.x - startedPoint.x
        let movedHeight = point.y - startedPoint.y
        //设置最大和最小值
        //最小值 2 个按钮 宽度 + 中间间隔
        //最大值和最小值之间
            switch btnType {
            case .None:
                break
            case .LeftUp:
                //0~(self.view.width-3*40)
                layoutConstraint_left.constant = min(CGRectGetMaxX(demoViewStartedFrame) - maxWidth, max(CGRectGetMinX(demoViewStartedFrame) + movedWidth,0))
                layoutConstraint_width.constant = CGRectGetMaxX(demoViewStartedFrame) - layoutConstraint_left.constant
                
                layoutConstraint_top.constant = min(CGRectGetMaxY(demoViewStartedFrame) - maxHeight,max(CGRectGetMinY(demoViewStartedFrame) + movedHeight,0))
                layoutConstraint_height.constant = CGRectGetMaxY(demoViewStartedFrame) - layoutConstraint_top.constant
            case .RightUp:
                layoutConstraint_width.constant = min(max(CGRectGetWidth(demoViewStartedFrame) + movedWidth,maxWidth),CGRectGetWidth(self.view.frame) - layoutConstraint_left.constant)
                
                layoutConstraint_top.constant = min(CGRectGetMaxY(demoViewStartedFrame) - maxHeight,max(CGRectGetMinY(demoViewStartedFrame) + movedHeight,0))
                layoutConstraint_height.constant = CGRectGetMaxY(demoViewStartedFrame) - layoutConstraint_top.constant
            case .LeftDown:
                layoutConstraint_left.constant = min(CGRectGetMaxX(demoViewStartedFrame) - maxWidth,max(CGRectGetMinX(demoViewStartedFrame) + movedWidth,0))
                layoutConstraint_width.constant = CGRectGetMaxX(demoViewStartedFrame) - layoutConstraint_left.constant
                
                layoutConstraint_height.constant = min(CGRectGetHeight(self.view.frame) - layoutConstraint_top.constant,max(CGRectGetHeight(demoViewStartedFrame) + movedHeight,maxHeight))
            case .RighDown:
                
                layoutConstraint_width.constant = min(max(CGRectGetWidth(demoViewStartedFrame) + movedWidth,maxWidth),CGRectGetWidth(self.view.frame) - layoutConstraint_left.constant)
                layoutConstraint_height.constant = min(max(CGRectGetHeight(demoViewStartedFrame) + movedHeight,maxHeight),CGRectGetHeight(self.view.frame) - layoutConstraint_top.constant)
            case .Center:
                
                layoutConstraint_left.constant = min(max(demoViewStartedFrame.origin.x + movedWidth,0),CGRectGetWidth(self.view.frame) - CGRectGetWidth(demoViewStartedFrame))
                layoutConstraint_top.constant = min(max(demoViewStartedFrame.origin.y + movedHeight,0),CGRectGetHeight(self.view.frame) - CGRectGetHeight(demoViewStartedFrame))
                
            case .Top:
                layoutConstraint_top.constant = min(CGRectGetMaxY(demoViewStartedFrame) - maxHeight,max(CGRectGetMinY(demoViewStartedFrame) + movedHeight,0))
                layoutConstraint_height.constant = CGRectGetMaxY(demoViewStartedFrame) - layoutConstraint_top.constant
                
            case .Left:
                layoutConstraint_left.constant = min(CGRectGetMaxX(demoViewStartedFrame) - maxWidth, max(CGRectGetMinX(demoViewStartedFrame) + movedWidth,0))
                layoutConstraint_width.constant = CGRectGetMaxX(demoViewStartedFrame) - layoutConstraint_left.constant
                
            case .Bottom:
                layoutConstraint_height.constant = min(CGRectGetHeight(self.view.frame) - layoutConstraint_top.constant,max(CGRectGetHeight(demoViewStartedFrame) + movedHeight,maxHeight))
            case .Right:
                layoutConstraint_width.constant = min(max(CGRectGetWidth(demoViewStartedFrame) + movedWidth,maxWidth),CGRectGetWidth(self.view.frame) - layoutConstraint_left.constant)
            }
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        btnType = .None
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        btnType = .None
    }
}
extension ViewController{
    
    private func configureViews(){
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(demoView)
        self.consraintsForSubViews();
        
    }
    // MARK: - views actions

    // MARK: - getter and setter
    
    private var demoView: UIView {
        get{
            if _demoView == nil{
                _demoView = UIView()
                _demoView.translatesAutoresizingMaskIntoConstraints = false
                _demoView.backgroundColor = UIColor.orange
//                _demoView.layer.anchorPoint = CGPointMake(1, 1)
                _demoView.addSubview(imageView1)
                _demoView.addSubview(imageView2)
                _demoView.addSubview(imageView3)
                _demoView.addSubview(imageView4)
                //_imageView1
                _demoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view(==40)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView1]));
                _demoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view(==40)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView1]))
                
                //_imageView2
                _demoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==40)]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView2]));
                _demoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view(==40)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView2]))
                
                //_imageView3
                _demoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view(==40)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView3]));
                _demoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==40)]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView3]))
                
                //_imageView4
                _demoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view(==40)]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView4]));
                _demoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view(==40)]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _imageView4]))

            }
            return _demoView
            
        }
        set{
            _demoView = newValue
        }
    }
   
    private var imageView1: UIImageView {
        get{
            if _imageView1 == nil{
                _imageView1 = UIImageView()
                _imageView1.translatesAutoresizingMaskIntoConstraints = false
                _imageView1.backgroundColor = UIColor.red
             
            }
            return _imageView1
            
        }
        set{
            _imageView1 = newValue
        }
    }
    
    private var imageView2: UIImageView {
        get{
            if _imageView2 == nil{
                _imageView2 = UIImageView()
                _imageView2.translatesAutoresizingMaskIntoConstraints = false
                _imageView2.backgroundColor = UIColor.yellow
                
            }
            return _imageView2
            
        }
        set{
            _imageView2 = newValue
        }
    }
    
    private var imageView3: UIImageView {
        get{
            if _imageView3 == nil{
                _imageView3 = UIImageView()
                _imageView3.translatesAutoresizingMaskIntoConstraints = false
                _imageView3.backgroundColor = UIColor.green
                
            }
            return _imageView3
            
        }
        set{
            _imageView3 = newValue
        }
    }
    
    private var imageView4: UIImageView {
        get{
            if _imageView4 == nil{
                _imageView4 = UIImageView()
                _imageView4.translatesAutoresizingMaskIntoConstraints = false
                _imageView4.backgroundColor = UIColor.brown
                
            }
            return _imageView4
            
        }
        set{
            _imageView4 = newValue
        }
    }
    // MARK: - consraintsForSubViews
    private func consraintsForSubViews() {
        //_demoView
        let arr1 = NSLayoutConstraint.constraints(withVisualFormat: "H:|-50-[view(\(CGRectGetWidth(self.view.frame) - 100))]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _demoView])
        layoutConstraint_left = arr1.first
        layoutConstraint_width = arr1.last
        self.view.addConstraints(arr1)
        
        let arr2 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[view(==150)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": _demoView]);
        layoutConstraint_top = arr2.first
        layoutConstraint_height = arr2.last
        
        self.view.addConstraints(arr2)
    }
    
}
