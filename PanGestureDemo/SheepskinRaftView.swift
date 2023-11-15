////
////  SheepskinRaftView.swift
//
//import Foundation
//import UIKit
//import Kingfisher
//
///// 注释掉的是两个拖动框限制
//
//class SheepskinRaftViewBottomView: UIView {
//    func creatLabel(_ text: String?) -> UILabel {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12)
//        label.textColor = Color.textBlack3.value
//        label.text = text
//        label.textAlignment = .center
//        return label
//    }
//    
//    func creatImageView(_ color: UIColor?) -> UIImageView {
//        let imageView = UIImageView()
//        imageView.backgroundColor = color
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.widthAnchor.constraint(equalToConstant: 66).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 2).isActive = true
//        return imageView
//    }
//    
//    var areaImageView: UIImageView!
//    var thresholdImageView: UIImageView!
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
//        self.isUserInteractionEnabled = false
//        
//        let topStackView = UIStackView()
//        topStackView.spacing = 28
//        topStackView.axis = .horizontal
//        self.addSubview(topStackView)
//        
//        let areaStackView = UIStackView()
//        areaStackView.spacing = 7
//        areaStackView.axis = .horizontal
//        areaStackView.alignment = .center
//        self.addSubview(areaStackView)
//        let areaLabel = creatLabel(R.string.localizable.detectionArea())
//        self.addSubview(areaLabel)
//        areaImageView = creatImageView(Color.buttonTitleBlue.value)
//        self.addSubview(areaImageView)
//        areaStackView.addArrangedSubViews([areaLabel, areaImageView])
//        
//        let thresholdStackView = UIStackView()
//        thresholdStackView.spacing = 7
//        thresholdStackView.axis = .horizontal
//        thresholdStackView.alignment = .center
//        self.addSubview(thresholdStackView)
//        let thresholdLabel = creatLabel(R.string.localizable.movingObjectThreshold())
//        self.addSubview(thresholdLabel)
//        thresholdImageView = creatImageView(Color.red.value)
//        self.addSubview(thresholdImageView)
//        thresholdStackView.addArrangedSubViews([thresholdLabel, thresholdImageView])
//        
//        topStackView.addArrangedSubViews([areaStackView, thresholdStackView])
//        
//        let tipLabel = creatLabel(R.string.localizable.detectionAreaMessage())
//        tipLabel.numberOfLines = 0
//        self.addSubview(tipLabel)
//        
//        topStackView.snp.makeConstraints { make in
//            make.top.equalTo(7)
//            make.centerX.equalToSuperview()
//        }
//        
//        tipLabel.snp.makeConstraints { make in
//            make.top.equalTo(topStackView.snp.bottom).offset(4)
//            make.leading.trailing.equalToSuperview().inset(15)
//            if #available(iOS 11.0, *) {
//                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-7)
//            } else {
//                make.bottom.equalTo(self).offset(-7)
//            }
//        }
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setLineColor(areaHexColor: String,
//                      thresholdHexColor: String) {
//        areaImageView.backgroundColor = UIColor(hexColor: areaHexColor)
//        thresholdImageView.backgroundColor = UIColor(hexColor: thresholdHexColor)
//    }
//}
//
//class SheepskinRaftView: UIView {
//    lazy var imageContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.layer.masksToBounds = true
//        return view
//    }()
//    
//    lazy var backgroundImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.isUserInteractionEnabled = true
////        imageView.layer.masksToBounds = true
//        return imageView
//    }()
//    
//    lazy var bottomView: SheepskinRaftViewBottomView = {
//        let view = SheepskinRaftViewBottomView()
//        return view
//    }()
//    
//    lazy var tipsLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.textColor = Color.gray9e9e9e.value
//        label.text = R.string.localizable.ifNoRecentPhotoIsTakenClickRefresh()
//        label.isHidden = true
//        return label
//    }()
//    
//    fileprivate var areaOverLayView: OverlayView!
//    fileprivate var thresholdOverLayView: OverlayView!
//    
//    
//    var areaTopConstraint: NSLayoutConstraint!
//    var areaLeftConstraint: NSLayoutConstraint!
//    var areaWidthConstraint: NSLayoutConstraint!
//    var areaHeightConstraint: NSLayoutConstraint!
//    var areaStartPoint: CGPoint = .zero
//    var areaPanEdge: PanEdge = .none
//    var areaStartFrame: CGRect = .zero
//    
//    let maxWidthDefault: CGFloat = 80
//    let maxHeightDefault: CGFloat = 80
//    
//    var thresholdTopConstraint: NSLayoutConstraint!
//    var thresholdLeftConstraint: NSLayoutConstraint!
//    var thresholdWidthConstraint: NSLayoutConstraint!
//    var thresholdHeightConstraint: NSLayoutConstraint!
//    var thresholdStartPoint: CGPoint = .zero
//    var thresholdPanEdge: PanEdge = .none
//    var thresholdStartFrame: CGRect = .zero
//    
//    fileprivate var panGesture: UIPanGestureRecognizer!
//    
//    fileprivate var currentPanType: PanViewType = .none
//    
//    fileprivate var areaModel: GameScenePolicyResourceListModel!
//    fileprivate var thresholdModel: GameScenePolicyResourceListModel!
//    
//    fileprivate static let areaInitialRectModel = DefaultRectModel(left: 480, top: 0, right: 1440, bottom: 540, ratio: 40)
//    fileprivate var areaDefaultRectModel = SheepskinRaftView.areaInitialRectModel
//    fileprivate static let thresholdInitialRectModel = DefaultRectModel(left: 480, top: 0, right: 576, bottom: 270, ratio: 8)
//    fileprivate var thresholdDefaultRectModel = SheepskinRaftView.thresholdInitialRectModel
//    
//    fileprivate var downloadOriginImage: UIImage?
//    /// 转化为本地的左边
//    fileprivate var downloadImageConvertedFrame: CGRect?
//    
//    fileprivate var childResourceModel: GameScenePolicyResourceListModel?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        self.addSubview(imageContainerView)
//        imageContainerView.addSubview(backgroundImageView)
//        
//        self.addSubview(bottomView)
//        self.addSubview(tipsLabel)
//        
//        imageContainerView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        backgroundImageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        
//        bottomView.snp.makeConstraints { make in
//            make.leading.bottom.trailing.equalToSuperview()
//        }
//        
//        tipsLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureAnction(_:)))
//        backgroundImageView.addGestureRecognizer(panGesture)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    @objc func handlePanGestureAnction(_ pan: UIPanGestureRecognizer) {
//        if areaOverLayView == nil {
//            return
//        }
//        
//        let point = pan.location(in: backgroundImageView)
//
//        switch pan.state {
//        case .began:
//            if CGRectContainsPoint(thresholdOverLayView.frame, point) {
//                currentPanType = .threshold
//                thresholdStartPoint = point
//                thresholdStartFrame = thresholdOverLayView.frame
//                thresholdPanEdge = calculatePanEdge(at: point)
//                return
//            }
//            
//            if CGRectContainsPoint(areaOverLayView.frame, point) {
//                currentPanType = .area
//                areaStartPoint = point
//                areaStartFrame = areaOverLayView.frame
//                areaPanEdge = calculatePanEdge(at: point)
//                return
//            }
//        case .changed:
//            updateOverlayFrame(at: point)
//        default:
//            currentPanType = .none
//            thresholdPanEdge = .none
//            areaPanEdge = .none
//        }
//    }
//    
//    func calculatePanEdge(at point: CGPoint) -> PanEdge {
//        var frame: CGRect!
//        
//        switch currentPanType {
//        case .none:
//            return .none
//        case .threshold:
//            frame = thresholdOverLayView.frame
//        case .area:
//            frame = areaOverLayView.frame
//        default:
//            return .none
//        }
//        
//        if !CGRectContainsPoint(frame, point) {
//            return .none
//        }
//        
//        let cornerSize = CGSize(width: 50, height: 50)
//        
//        let topLeftRect = CGRect(origin: frame.origin, size: cornerSize)
//        if topLeftRect.contains(point) {
//            return .topLeft
//        }
//        
//        let topRightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.minY), size: cornerSize)
//        if topRightRect.contains(point) {
//            return .topRight
//        }
//        
//        let bottomLeftRect = CGRect(origin: CGPoint(x: frame.minX, y: frame.maxY - cornerSize.height), size: cornerSize)
//        if bottomLeftRect.contains(point) {
//            return .bottomLeft
//        }
//        
//        let bottomRightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.maxY - cornerSize.height), size: cornerSize)
//        if bottomRightRect.contains(point) {
//            return .bottomRight
//        }
//        
//        return .center
//    }
//    
//    func updateOverlayFrame(at point: CGPoint) {
//        var topConstraint: NSLayoutConstraint!
//        var leftConstraint: NSLayoutConstraint!
//        var widthConstraint: NSLayoutConstraint!
//        var heightConstraint: NSLayoutConstraint!
//        
//        var startPoint: CGPoint = .zero
//        var panEdge: PanEdge = .none
//        var startFrame: CGRect = .zero
//        
//        var currentOverlay: UIView!
//        
//        switch currentPanType {
//        case .none:
//            return
//        case .threshold:
//            topConstraint = thresholdTopConstraint
//            leftConstraint = thresholdLeftConstraint
//            widthConstraint = thresholdWidthConstraint
//            heightConstraint = thresholdHeightConstraint
//            
//            startPoint = thresholdStartPoint
//            panEdge = thresholdPanEdge
//            startFrame = thresholdStartFrame
//            
//            currentOverlay = thresholdOverLayView
//            
////            let movedWidth = point.x  - startPoint.x
////            let movedHeight = point.y - startPoint.y
////
////            switch panEdge {
////            case .topLeft:
////                leftConstraint.constant =  min(CGRectGetMaxX(startFrame) - maxWidthDefault, max(CGRectGetMinX(startFrame) + movedWidth, CGRectGetMinX(areaOverLayView.frame)))
////                widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
////
////                topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeightDefault,max(CGRectGetMinY(startFrame) + movedHeight, CGRectGetMinY(areaOverLayView.frame)))
////                heightConstraint.constant = CGRectGetMaxY(startFrame) - topConstraint.constant
////            case .topRight:
////                widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth, maxWidthDefault),CGRectGetMaxX(areaOverLayView.frame) - leftConstraint.constant)
////
////                topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeightDefault,max(CGRectGetMinY(startFrame) + movedHeight, CGRectGetMinY(areaOverLayView.frame)))
////                heightConstraint.constant =  CGRectGetMaxY(startFrame) - topConstraint.constant
////
////            case .bottomLeft:
////                leftConstraint.constant = min(CGRectGetMaxX(startFrame) - maxWidthDefault,max(CGRectGetMinX(startFrame) + movedWidth, CGRectGetMinX(areaOverLayView.frame)))
////                widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
////
////                heightConstraint.constant = min(CGRectGetMaxY(areaOverLayView.frame) - CGRectGetMinY(currentOverlay.frame),max(CGRectGetHeight(startFrame) + movedHeight,maxHeightDefault))
////
////            case .bottomRight:
////                widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth,maxWidthDefault),CGRectGetMaxX(areaOverLayView.frame) - leftConstraint.constant)
////                heightConstraint.constant = min(max(CGRectGetHeight(startFrame) + movedHeight,maxHeightDefault),CGRectGetMaxY(areaOverLayView.frame) - topConstraint.constant)
////
////            case .center:
////                leftConstraint.constant = min(max(startFrame.origin.x + movedWidth, CGRectGetMinX(areaOverLayView.frame)),CGRectGetMaxX(areaOverLayView.frame) - CGRectGetWidth(startFrame))
////                topConstraint.constant = min(max(startFrame.origin.y + movedHeight,CGRectGetMinY(areaOverLayView.frame)),CGRectGetMaxY(areaOverLayView.frame) - CGRectGetHeight(startFrame))
////            case .none:
////                print("")
////            }
//        case .area:
//            topConstraint = areaTopConstraint
//            leftConstraint = areaLeftConstraint
//            widthConstraint = areaWidthConstraint
//            heightConstraint = areaHeightConstraint
//            
//            startPoint = areaStartPoint
//            panEdge = areaPanEdge
//            startFrame = areaStartFrame
//            
//            currentOverlay = areaOverLayView
//            
////            let movedWidth = point.x  - startPoint.x
////            let movedHeight = point.y - startPoint.y
////
////            switch panEdge {
////            case .topLeft:
////                leftConstraint.constant =  max(0, min(CGRectGetMinX(startFrame) + movedWidth, CGRectGetMinX(thresholdOverLayView.frame)))
////                widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
////
////                topConstraint.constant = max(0,min(CGRectGetMinY(startFrame) + movedHeight, CGRectGetMinY(thresholdOverLayView.frame)))
////                heightConstraint.constant = CGRectGetMaxY(startFrame) - topConstraint.constant
////            case .topRight:
////                widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth, CGRectGetMaxX(thresholdOverLayView.frame) - CGRectGetMinX(startFrame)),CGRectGetWidth(backgroundImageView.frame) - leftConstraint.constant)
////
////                topConstraint.constant = min(CGRectGetMinY(thresholdOverLayView.frame),max(CGRectGetMinY(startFrame) + movedHeight,0))
////                heightConstraint.constant =  CGRectGetMaxY(startFrame) - topConstraint.constant
////
////            case .bottomLeft:
////                leftConstraint.constant =  max(0, min(CGRectGetMinX(startFrame) + movedWidth, CGRectGetMinX(thresholdOverLayView.frame)))
////                widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
////
////                heightConstraint.constant = min(CGRectGetHeight(backgroundImageView.frame) - CGRectGetMinY(currentOverlay.frame),max(CGRectGetHeight(startFrame) + movedHeight,CGRectGetMaxY(thresholdOverLayView.frame) - topConstraint.constant))
////
////            case .bottomRight:
////                widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth,CGRectGetMaxX(thresholdOverLayView.frame) - leftConstraint.constant),CGRectGetWidth(backgroundImageView.frame) - leftConstraint.constant)
////                heightConstraint.constant = min(max(CGRectGetHeight(startFrame) + movedHeight,CGRectGetMaxY(thresholdOverLayView.frame) - topConstraint.constant),CGRectGetHeight(backgroundImageView.frame) - topConstraint.constant)
////
////            case .center:
////                if movedWidth < 0 {
////                    leftConstraint.constant = min(max(max(startFrame.origin.x + movedWidth,0), CGRectGetMaxX(thresholdOverLayView.frame) - CGRectGetWidth(startFrame)),min(CGRectGetMaxX(thresholdOverLayView.frame), CGRectGetWidth(backgroundImageView.frame) - CGRectGetWidth(startFrame)))
////                } else {
////                    leftConstraint.constant = min(min(max(startFrame.origin.x + movedWidth,0), CGRectGetMinX(thresholdOverLayView.frame)),min(CGRectGetMinX(thresholdOverLayView.frame), CGRectGetWidth(backgroundImageView.frame) - CGRectGetWidth(startFrame)))
////                }
////
////                if movedHeight < 0 {
////                    topConstraint.constant = min(max(max(startFrame.origin.y + movedHeight,0), CGRectGetMaxY(thresholdOverLayView.frame) - CGRectGetHeight(startFrame)),min(CGRectGetMaxY(thresholdOverLayView.frame), CGRectGetHeight(backgroundImageView.frame) - CGRectGetHeight(startFrame)))
////                } else {
////                    topConstraint.constant = min(min(max(startFrame.origin.y + movedHeight,0), CGRectGetMinY(thresholdOverLayView.frame)),min(CGRectGetMinY(thresholdOverLayView.frame), CGRectGetHeight(backgroundImageView.frame) - CGRectGetHeight(startFrame)))
////                }
////            case .none:
////                print("")
////            }
//        default:
//            return
//        }
//        
//        if panEdge == .none { return }
//        
//        let movedWidth = point.x  - startPoint.x
//        let movedHeight = point.y - startPoint.y
//
//        switch panEdge {
//        case .topLeft:
//            leftConstraint.constant =  min(CGRectGetMaxX(startFrame) - maxWidthDefault, max(CGRectGetMinX(startFrame) + movedWidth,0))
//            widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
//
//            topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeightDefault,max(CGRectGetMinY(startFrame) + movedHeight,0))
//            heightConstraint.constant = CGRectGetMaxY(startFrame) - topConstraint.constant
//        case .topRight:
//            widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth, maxWidthDefault),CGRectGetWidth(backgroundImageView.frame) - leftConstraint.constant)
//
//            topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeightDefault,max(CGRectGetMinY(startFrame) + movedHeight,0))
//            heightConstraint.constant =  CGRectGetMaxY(startFrame) - topConstraint.constant
//
//        case .bottomLeft:
//            leftConstraint.constant = min(CGRectGetMaxX(startFrame) - maxWidthDefault,max(CGRectGetMinX(startFrame) + movedWidth,0))
//            widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
//
//            heightConstraint.constant = min(CGRectGetHeight(backgroundImageView.frame) - CGRectGetMinY(currentOverlay.frame),max(CGRectGetHeight(startFrame) + movedHeight,maxHeightDefault))
//
//        case .bottomRight:
//            widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth,maxWidthDefault),CGRectGetWidth(backgroundImageView.frame) - leftConstraint.constant)
//            heightConstraint.constant = min(max(CGRectGetHeight(startFrame) + movedHeight,maxHeightDefault),CGRectGetHeight(backgroundImageView.frame) - topConstraint.constant)
//
//        case .center:
//            leftConstraint.constant = min(max(startFrame.origin.x + movedWidth,0),CGRectGetWidth(backgroundImageView.frame) - CGRectGetWidth(startFrame))
//            topConstraint.constant = min(max(startFrame.origin.y + movedHeight,0),CGRectGetHeight(backgroundImageView.frame) - CGRectGetHeight(startFrame))
//        case .none:
//            print("")
//        }
//        
//        updateOverlayViews()
//    }
//    
//    /// 更新坐标比例等
//    func updateOverlayViews() {
//        areaOverLayView.percent = RectConvert.borderProportionCalculation(rect: areaOverLayView.frame, relativeSize: backgroundImageView.frame.size)
//        areaOverLayView.percentLabel.isHidden = true
//        
//        thresholdOverLayView.percent = RectConvert.borderProportionCalculation(rect: thresholdOverLayView.frame, relativeSize: areaOverLayView.frame.size)
//        
//        let areaAndriodRect = RectConvert.convertToOriginImageAndroidRect(areaOverLayView.frame, iosRelateRect: backgroundImageView.frame, originImageSize: downloadOriginImage?.size ?? .zero)
//        
//        areaOverLayView.topLeftRectText = "(\(areaAndriodRect[0]), \(areaAndriodRect[1]))"
//        areaOverLayView.bottomRightRectText = "(\(areaAndriodRect[2]), \(areaAndriodRect[3]))"
//        
//        /// 更新缓存数据
//        self.areaModel.value = saveDataToServer()?.maxValue
//        self.thresholdModel.value = saveDataToServer()?.minValue
//    }
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//}
//
//extension SheepskinRaftView {
//    func setupOverlayViews() {
//        self.layoutIfNeeded()
//        /// 根据最新数据更新坐标系
//        parseRectToShowRect()
//        
//        if areaOverLayView != nil {
//            areaOverLayView.removeFromSuperview()
//        }
//        if thresholdOverLayView != nil {
//            thresholdOverLayView.removeFromSuperview()
//        }
//        
//        /// 全部重新初始化，避免刷新拍照后 约束 重复造成问题
//        areaOverLayView = OverlayView()
//        areaOverLayView.overlayType = .area
//        backgroundImageView.addSubview(areaOverLayView)
//        
//        thresholdOverLayView = OverlayView()
//        thresholdOverLayView.overlayType = .threshold
//        backgroundImageView.addSubview(thresholdOverLayView)
//        
//        let originSize = backgroundImageView.bounds.size
//        
//        areaOverLayView.translatesAutoresizingMaskIntoConstraints = false
//        areaTopConstraint = areaOverLayView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: areaDefaultRectModel.borderTop(originSize.height))
//        areaTopConstraint.isActive = true
//        areaLeftConstraint = areaOverLayView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: areaDefaultRectModel.borderLeft(originSize.width))
//        areaLeftConstraint.isActive = true
//        areaWidthConstraint = areaOverLayView.widthAnchor.constraint(equalToConstant: areaDefaultRectModel.borderWidth(originSize.width))
//        areaWidthConstraint.isActive = true
//        areaHeightConstraint = areaOverLayView.heightAnchor.constraint(equalToConstant: areaDefaultRectModel.borderHeight(originSize.height))
//        areaHeightConstraint.isActive = true
//        
//        thresholdOverLayView.translatesAutoresizingMaskIntoConstraints = false
//        thresholdTopConstraint = thresholdOverLayView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: thresholdDefaultRectModel.borderTop(originSize.height))
//        thresholdTopConstraint.isActive = true
//        thresholdLeftConstraint = thresholdOverLayView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: thresholdDefaultRectModel.borderLeft(originSize.width))
//        thresholdLeftConstraint.isActive = true
//        thresholdWidthConstraint = thresholdOverLayView.widthAnchor.constraint(equalToConstant: thresholdDefaultRectModel.borderWidth(originSize.width))
//        thresholdWidthConstraint.isActive = true
//        thresholdHeightConstraint = thresholdOverLayView.heightAnchor.constraint(equalToConstant: thresholdDefaultRectModel.borderHeight(originSize.height))
//        thresholdHeightConstraint.isActive = true
//        
//        self.layoutIfNeeded()
//        
//        self.updateOverlayViews()
//        
//        setLineColor(areaHexColor: areaModel.attribute?.color ?? "",
//                     thresholdHexColor: thresholdModel.attribute?.color ?? "")
//    }
//}
//
//// MARK: - 设置数据
//extension SheepskinRaftView {
//    func setupChildModel(_ model: GameScenePolicyResourceListModel) {
//        self.childResourceModel = model
//        
//        guard let childResources = childResourceModel?.childrenResource else {
//            return
//        }
//        
//        self.areaModel = findModelFromKey(key: "detectionArea", resources: childResources)
//        self.thresholdModel = findModelFromKey(key: "moveObjectThreshold", resources: childResources)
//    }
//    
//    fileprivate func parseRectToShowRect() {
//        if let rectModel = parseRangModel(model: self.areaModel, defaultModel: SheepskinRaftView.areaInitialRectModel) {
//            areaDefaultRectModel = rectModel
//        }
//        
//        if let rectModel = parseRangModel(model: self.thresholdModel, defaultModel: SheepskinRaftView.thresholdInitialRectModel) {
//            thresholdDefaultRectModel = rectModel
//        }
//    }
//    
//    fileprivate func parseRangModel(model: GameScenePolicyResourceListModel, defaultModel: DefaultRectModel) -> DefaultRectModel? {
//        var rectModel: DefaultRectModel?
//        if let data = model.rowValue()?.data(using: .utf8) {
//            do {
//                let model = try JSONDecoder().decode(DefaultRectModel.self, from: data)
//                rectModel = model
//            } catch _ {
//                Logger.debug(.none, "解析 范围model 出错")
//                rectModel = defaultModel
//            }
//        } else {
//            rectModel = defaultModel
//        }
//        
//        return rectModel
//    }
//    
//    fileprivate func setLineColor(areaHexColor: String,
//                                  thresholdHexColor: String) {
//        areaOverLayView.lineColor = UIColor(hexColor: areaHexColor)
//        thresholdOverLayView.lineColor = UIColor(hexColor: thresholdHexColor)
//        
//        bottomView.setLineColor(areaHexColor: areaHexColor, thresholdHexColor: thresholdHexColor)
//    }
//    
//    func setBackgroundImage(_ url: URL) {
//        tipsLabel.isHidden = true
//        
//        func resetBackgroudImageLayout(_ image: UIImage) {
//            backgroundImageView.image = image
//            
//            downloadOriginImage = image
//            
//            let rect = caculateImageViewFrame(for: image, inImageViewAspectFit: self.backgroundImageView)
//            print("---\(rect)")
//            
//            downloadImageConvertedFrame = rect
//            
//            if let downloadImageFrame = downloadImageConvertedFrame {
//                backgroundImageView.snp.remakeConstraints { make in
//                    make.size.equalTo(downloadImageFrame.size)
//                    make.center.equalToSuperview()
//                }
//            }
//            
//            self.setupOverlayViews()
//        }
//        
//        let cacheKey = url.absoluteString
//        
//        ImageCache.default.retrieveImage(forKey: cacheKey, options: nil) { [weak self] image, type in
//            if let image = image {
//                Logger.debug(.none, "图片size --- \(image.size)")
//                
//                DispatchQueue.main.async {
//                    resetBackgroudImageLayout(image)
//                }
//            } else {
//                ImageDownloader.default.downloadImage(with: url, completionHandler: { [weak self] (image, error, url, data) in
//                    if let image = image {
//                        DispatchQueue.main.async {
//                            resetBackgroudImageLayout(image)
//                        }
//
//                        ImageCache.default.store(image, forKey: cacheKey)
//                    } else {
//                        getCurrentDisplayController()?.showHUDToast(R.string.localizable.imageLoadingFailed())
//                    }
//                })
//            }
//        }
//    }
//}
//
//// MARK: - 上传数据处理
//extension SheepskinRaftView {
//    func saveDataToServer() -> (maxValue: String?,
//                                minValue: String?)? {
//        guard let originImage = downloadOriginImage else { return nil }
//        
//        var areaRectModel = areaDefaultRectModel
//        areaRectModel.width = Int(originImage.size.width)
//        areaRectModel.height = Int(originImage.size.height)
//        
//        let areaAndriodRect = RectConvert.convertToOriginImageAndroidRect(areaOverLayView.frame, iosRelateRect: backgroundImageView.frame, originImageSize: originImage.size)
//        areaRectModel.left = areaAndriodRect[0]
//        areaRectModel.top = areaAndriodRect[1]
//        areaRectModel.right = areaAndriodRect[2]
//        areaRectModel.bottom = areaAndriodRect[3]
//        areaRectModel.ratio = areaOverLayView.percent
//        
//        var thresholdRectModel = areaDefaultRectModel
//        thresholdRectModel.width = Int(originImage.size.width)
//        thresholdRectModel.height = Int(originImage.size.height)
//        
//        let thresholdAndriodRect = RectConvert.convertToOriginImageAndroidRect(thresholdOverLayView.frame, iosRelateRect: backgroundImageView.frame, originImageSize: originImage.size)
//        thresholdRectModel.left = thresholdAndriodRect[0]
//        thresholdRectModel.top = thresholdAndriodRect[1]
//        thresholdRectModel.right = thresholdAndriodRect[2]
//        thresholdRectModel.bottom = thresholdAndriodRect[3]
//        thresholdRectModel.ratio = thresholdOverLayView.percent
//        
//        return (areaRectModel.convertToJSON(),  thresholdRectModel.convertToJSON())
//    }
//}
//
//// MARK: - 获取图片在imageView的坐标
//func caculateImageViewFrame(for image: UIImage, inImageViewAspectFit imageView: UIImageView) -> CGRect {
//    let imageRatio = (image.size.width / image.size.height)
//    let viewRatio = imageView.frame.size.width / imageView.frame.size.height
//    if imageRatio <= viewRatio {
//      let scale = imageView.frame.size.height / image.size.height
//      let width = scale * image.size.width
//      let topLeftX = (imageView.frame.size.width - width) * 0.5
//      return CGRect(x: topLeftX, y: 0, width: width, height: imageView.frame.size.height)
//    } else {
//      let scale = imageView.frame.size.width / image.size.width
//      let height = scale * image.size.height
//      let topLeftY = (imageView.frame.size.height - height) * 0.5
//      return CGRect(x: 0.0, y: topLeftY, width: imageView.frame.size.width, height: height)
//    }
//  }
//
//
//class RectConvert {
//    static func convertToOriginImageAndroidRect(_ iosRect: CGRect,
//                                                iosRelateRect: CGRect,
//                                                originImageSize: CGSize) -> [Int] {
//        let left = CGRectGetMinX(iosRect) / iosRelateRect.size.width * originImageSize.width
//        let top = CGRectGetMinY(iosRect) / iosRelateRect.size.height * originImageSize.height
//        let right = CGRectGetMaxX(iosRect) / iosRelateRect.size.width * originImageSize.width
//        let bottom = CGRectGetMaxY(iosRect) / iosRelateRect.size.height * originImageSize.height
//        
//        return [Int(left), Int(top), Int(right), Int(bottom)]
//    }
//    
//    static func borderProportionCalculation(rect: CGRect, relativeSize: CGSize) -> Int {
////  注意这个公式是安卓的      ratio = (right - left) * (bottom - top) / (width * height)
//        let top = CGRectGetMinY(rect)
//        let left = CGRectGetMinX(rect)
//        let bottom = CGRectGetMaxY(rect)
//        let right = CGRectGetMaxX(rect)
//        
//        let ratio: CGFloat = (right - left) * (bottom - top) / (relativeSize.width * relativeSize.height)
//        
//        return Int(round(ratio * 100))
//    }
//}
//
///// 默认区域model // 安卓的
//struct DefaultRectModel: Codable {
//    var width: Int = 1920
//    var height: Int = 1080
//    var left: Int
//    var top: Int
//    var right: Int
//    var bottom: Int
//    /// 这个比例只是用于计算后存储，初始化时的不影响后续计算
//    var ratio: Int
//    
//    func borderWidth(_ viewWidth: CGFloat) -> CGFloat {
//        return (CGFloat(right) - CGFloat(left)) / CGFloat(width) * viewWidth
//    }
//    
//    func borderHeight(_ viewHeight: CGFloat) -> CGFloat {
//        return (CGFloat(bottom) - CGFloat(top)) / CGFloat(height) * viewHeight
//    }
//    
//    func borderLeft(_ viewWidth: CGFloat) -> CGFloat {
//        return CGFloat(left) / CGFloat(width) * viewWidth
//    }
//    
//    func borderTop(_ viewHeight: CGFloat) -> CGFloat {
//        return CGFloat(top) / CGFloat(height) * viewHeight
//    }
//}
//
//class UploadScopeData: Codable {
//    var width: Int?
//    var height: Int?
//    var resions: [UploadScopeRegionModel]?
//}
//
//class UploadScopeRegionModel: Codable {
//    var type: Int?
//    var rect: [Int]?
//    var ratio: CGFloat?
//}
//
//
//// MARK: - 用数组的方式保存画框和约束实现
//
////class SheepskinRaftViewBottomView: UIView {
////    func creatLabel(_ text: String?) -> UILabel {
////        let label = UILabel()
////        label.font = UIFont.systemFont(ofSize: 12)
////        label.textColor = Color.textBlack3.value
////        label.text = text
////        label.textAlignment = .center
////        return label
////    }
////
////    func creatImageView(_ color: UIColor?) -> UIImageView {
////        let imageView = UIImageView()
////        imageView.backgroundColor = color
////        return imageView
////    }
////
////    var areaImageView: UIImageView!
////    var thresholdImageView: UIImageView!
////
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////
////        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
////        self.isUserInteractionEnabled = false
////
////        let topStackView = UIStackView()
////        topStackView.spacing = 28
////        topStackView.axis = .horizontal
////        self.addSubview(topStackView)
////
////        let areaStackView = UIStackView()
////        areaStackView.spacing = 7
////        areaStackView.axis = .horizontal
////        areaStackView.alignment = .center
////        self.addSubview(areaStackView)
////        let areaLabel = creatLabel(R.string.localizable.detectionArea())
////        areaImageView = creatImageView(Color.buttonTitleBlue.value)
////        areaStackView.addArrangedSubViews([areaLabel, areaImageView])
////        areaImageView.snp.makeConstraints { make in
////            make.width.equalTo(self).multipliedBy(0.098)
////            make.height.equalTo(2)
////        }
////
////        let thresholdStackView = UIStackView()
////        thresholdStackView.spacing = 7
////        thresholdStackView.axis = .horizontal
////        thresholdStackView.alignment = .center
////        self.addSubview(thresholdStackView)
////        let thresholdLabel = creatLabel(R.string.localizable.movingObjectThreshold())
////        thresholdImageView = creatImageView(Color.red.value)
////        thresholdStackView.addArrangedSubViews([thresholdLabel, thresholdImageView])
////        thresholdImageView.snp.makeConstraints { make in
////            make.width.equalTo(self).multipliedBy(0.098)
////            make.height.equalTo(2)
////        }
////
////        topStackView.addArrangedSubViews([areaStackView, thresholdStackView])
////
////        let tipLabel = creatLabel(R.string.localizable.detectionAreaMessage())
////        tipLabel.numberOfLines = 0
////        self.addSubview(tipLabel)
////
////        topStackView.snp.makeConstraints { make in
////            make.top.equalTo(7)
////            make.centerX.equalToSuperview()
////        }
////
////        tipLabel.snp.makeConstraints { make in
////            make.top.equalTo(topStackView.snp.bottom).offset(4)
////            make.leading.trailing.equalToSuperview().inset(15)
////            if #available(iOS 11.0, *) {
////                make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-7)
////            } else {
////                make.bottom.equalTo(self).offset(-7)
////            }
////        }
////    }
////
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////
////    func setLineColor(areaHexColor: String,
////                      thresholdHexColor: String) {
////        areaImageView.backgroundColor = UIColor(hexColor: areaHexColor)
////        thresholdImageView.backgroundColor = UIColor(hexColor: thresholdHexColor)
////    }
////}
////
////class SheepskinRaftView: UIView {
////    lazy var imageContainerView: UIView = {
////        let view = UIView()
////        view.backgroundColor = .black
////        view.layer.masksToBounds = true
////        return view
////    }()
////
////    lazy var backgroundImageView: UIImageView = {
////        let imageView = UIImageView()
////        imageView.contentMode = .scaleAspectFit
////        imageView.isUserInteractionEnabled = true
//////        imageView.layer.masksToBounds = true
////        return imageView
////    }()
////
////    lazy var bottomView: SheepskinRaftViewBottomView = {
////        let view = SheepskinRaftViewBottomView()
////        return view
////    }()
////
////    lazy var tipsLabel: UILabel = {
////        let label = UILabel()
////        label.font = UIFont.systemFont(ofSize: 16)
////        label.textColor = Color.gray9e9e9e.value
////        label.text = R.string.localizable.ifNoRecentPhotoIsTakenClickRefresh()
////        label.isHidden = true
////        return label
////    }()
////
////    fileprivate var overLayViews: [OverlayView] = []
////    fileprivate var currentOverlayView: OverlayView!
////
////    var topConstraints: [NSLayoutConstraint] = []
////    var leftConstraints: [NSLayoutConstraint] = []
////    var widthConstraints: [NSLayoutConstraint] = []
////    var heightConstraints: [NSLayoutConstraint] = []
////    var startPoint: CGPoint = .zero
////    var currentPanEdge: PanEdge = .none
////    var startFrame: CGRect = .zero
////
////    let maxWidthDefault: CGFloat = 60
////    let maxHeightDefault: CGFloat = 60
////
////    fileprivate var panGesture: UIPanGestureRecognizer!
////
////
////    fileprivate var policyModels: [GameScenePolicyResourceListModel] = []
////
////    fileprivate static let areaInitialRectModel = DefaultRectModel(left: 480, top: 0, right: 1440, bottom: 540, ratio: 40)
////    fileprivate var areaDefaultRectModel = SheepskinRaftView.areaInitialRectModel
////    fileprivate static let thresholdInitialRectModel = DefaultRectModel(left: 480, top: 0, right: 576, bottom: 270, ratio: 8)
////    fileprivate var thresholdDefaultRectModel = SheepskinRaftView.thresholdInitialRectModel
////
////    fileprivate var defaultRectModels = [DefaultRectModel]()
////
////    fileprivate var downloadOriginImage: UIImage?
////    /// 转化为本地的左边
////    fileprivate var downloadImageConvertedFrame: CGRect?
////
////    fileprivate var childResourceModel: GameScenePolicyResourceListModel?
////
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////
////        self.addSubview(imageContainerView)
////        imageContainerView.addSubview(backgroundImageView)
////
////        self.addSubview(bottomView)
////        self.addSubview(tipsLabel)
////
////        imageContainerView.snp.makeConstraints { make in
////            make.edges.equalToSuperview()
////        }
////        backgroundImageView.snp.makeConstraints { make in
////            make.edges.equalToSuperview()
////        }
////
////        bottomView.snp.makeConstraints { make in
////            make.leading.bottom.trailing.equalToSuperview()
////        }
////
////        tipsLabel.snp.makeConstraints { make in
////            make.center.equalToSuperview()
////        }
////
////        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureAnction(_:)))
////        backgroundImageView.addGestureRecognizer(panGesture)
////    }
////
////    required init?(coder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
////
////    func reset() {
////        currentOverlayView = nil
////        startFrame = .zero
////        startPoint = .zero
////        currentPanEdge = .none
////    }
////
////    @objc func handlePanGestureAnction(_ pan: UIPanGestureRecognizer) {
////        if overLayViews.isEmpty {
////            return
////        }
////
////        let point = pan.location(in: backgroundImageView)
////
////        switch pan.state {
////        case .began:
////reset()
////
////for view in overLayViews.reversed() {
////    if CGRectContainsPoint(view.frame, point) {
////        startPoint = point
////        startFrame = view.frame
////        currentOverlayView = view
////        currentPanEdge = calculatePanEdge(at: point)
////        return
////    }
////}
////        case .changed:
////            updateOverlayFrame(at: point)
////        default:
////            reset()
////        }
////    }
////
////    func calculatePanEdge(at point: CGPoint) -> PanEdge {
////        if currentOverlayView == nil {
////            return .none
////        }
////        let frame: CGRect = currentOverlayView.frame
////
////        if !CGRectContainsPoint(frame, point) {
////            return .none
////        }
////
////        let cornerSize = CGSize(width: 50, height: 50)
////
////        let topLeftRect = CGRect(origin: frame.origin, size: cornerSize)
////        if topLeftRect.contains(point) {
////            return .topLeft
////        }
////
////        let topRightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.minY), size: cornerSize)
////        if topRightRect.contains(point) {
////            return .topRight
////        }
////
////        let bottomLeftRect = CGRect(origin: CGPoint(x: frame.minX, y: frame.maxY - cornerSize.height), size: cornerSize)
////        if bottomLeftRect.contains(point) {
////            return .bottomLeft
////        }
////
////        let bottomRightRect = CGRect(origin: CGPoint(x: frame.maxX - cornerSize.width, y: frame.maxY - cornerSize.height), size: cornerSize)
////        if bottomRightRect.contains(point) {
////            return .bottomRight
////        }
////
////        return .center
////    }
////
////    func updateOverlayFrame(at point: CGPoint) {
////        if currentPanEdge == .none { return }
////
////        if currentOverlayView == nil {
////            return
////        }
////
////        guard let viewIndex = overLayViews.firstIndex(of: currentOverlayView) else {
////            return
////        }
////
////        var topConstraint: NSLayoutConstraint = topConstraints[viewIndex]
////        var leftConstraint: NSLayoutConstraint = leftConstraints[viewIndex]
////        var widthConstraint: NSLayoutConstraint = widthConstraints[viewIndex]
////        var heightConstraint: NSLayoutConstraint = heightConstraints[viewIndex]
////
////
////
//////            let movedWidth = point.x  - startPoint.x
//////            let movedHeight = point.y - startPoint.y
//////
//////            switch panEdge {
//////            case .topLeft:
//////                leftConstraint.constant =  min(CGRectGetMaxX(startFrame) - maxWidthDefault, max(CGRectGetMinX(startFrame) + movedWidth, CGRectGetMinX(areaOverLayView.frame)))
//////                widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
//////
//////                topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeightDefault,max(CGRectGetMinY(startFrame) + movedHeight, CGRectGetMinY(areaOverLayView.frame)))
//////                heightConstraint.constant = CGRectGetMaxY(startFrame) - topConstraint.constant
//////            case .topRight:
//////                widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth, maxWidthDefault),CGRectGetMaxX(areaOverLayView.frame) - leftConstraint.constant)
//////
//////                topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeightDefault,max(CGRectGetMinY(startFrame) + movedHeight, CGRectGetMinY(areaOverLayView.frame)))
//////                heightConstraint.constant =  CGRectGetMaxY(startFrame) - topConstraint.constant
//////
//////            case .bottomLeft:
//////                leftConstraint.constant = min(CGRectGetMaxX(startFrame) - maxWidthDefault,max(CGRectGetMinX(startFrame) + movedWidth, CGRectGetMinX(areaOverLayView.frame)))
//////                widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
//////
//////                heightConstraint.constant = min(CGRectGetMaxY(areaOverLayView.frame) - CGRectGetMinY(currentOverlay.frame),max(CGRectGetHeight(startFrame) + movedHeight,maxHeightDefault))
//////
//////            case .bottomRight:
//////                widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth,maxWidthDefault),CGRectGetMaxX(areaOverLayView.frame) - leftConstraint.constant)
//////                heightConstraint.constant = min(max(CGRectGetHeight(startFrame) + movedHeight,maxHeightDefault),CGRectGetMaxY(areaOverLayView.frame) - topConstraint.constant)
//////
//////            case .center:
//////                leftConstraint.constant = min(max(startFrame.origin.x + movedWidth, CGRectGetMinX(areaOverLayView.frame)),CGRectGetMaxX(areaOverLayView.frame) - CGRectGetWidth(startFrame))
//////                topConstraint.constant = min(max(startFrame.origin.y + movedHeight,CGRectGetMinY(areaOverLayView.frame)),CGRectGetMaxY(areaOverLayView.frame) - CGRectGetHeight(startFrame))
//////            case .none:
//////                print("")
//////            }
////
////
//////            let movedWidth = point.x  - startPoint.x
//////            let movedHeight = point.y - startPoint.y
//////
//////            switch panEdge {
//////            case .topLeft:
//////                leftConstraint.constant =  max(0, min(CGRectGetMinX(startFrame) + movedWidth, CGRectGetMinX(thresholdOverLayView.frame)))
//////                widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
//////
//////                topConstraint.constant = max(0,min(CGRectGetMinY(startFrame) + movedHeight, CGRectGetMinY(thresholdOverLayView.frame)))
//////                heightConstraint.constant = CGRectGetMaxY(startFrame) - topConstraint.constant
//////            case .topRight:
//////                widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth, CGRectGetMaxX(thresholdOverLayView.frame) - CGRectGetMinX(startFrame)),CGRectGetWidth(backgroundImageView.frame) - leftConstraint.constant)
//////
//////                topConstraint.constant = min(CGRectGetMinY(thresholdOverLayView.frame),max(CGRectGetMinY(startFrame) + movedHeight,0))
//////                heightConstraint.constant =  CGRectGetMaxY(startFrame) - topConstraint.constant
//////
//////            case .bottomLeft:
//////                leftConstraint.constant =  max(0, min(CGRectGetMinX(startFrame) + movedWidth, CGRectGetMinX(thresholdOverLayView.frame)))
//////                widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
//////
//////                heightConstraint.constant = min(CGRectGetHeight(backgroundImageView.frame) - CGRectGetMinY(currentOverlay.frame),max(CGRectGetHeight(startFrame) + movedHeight,CGRectGetMaxY(thresholdOverLayView.frame) - topConstraint.constant))
//////
//////            case .bottomRight:
//////                widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth,CGRectGetMaxX(thresholdOverLayView.frame) - leftConstraint.constant),CGRectGetWidth(backgroundImageView.frame) - leftConstraint.constant)
//////                heightConstraint.constant = min(max(CGRectGetHeight(startFrame) + movedHeight,CGRectGetMaxY(thresholdOverLayView.frame) - topConstraint.constant),CGRectGetHeight(backgroundImageView.frame) - topConstraint.constant)
//////
//////            case .center:
//////                if movedWidth < 0 {
//////                    leftConstraint.constant = min(max(max(startFrame.origin.x + movedWidth,0), CGRectGetMaxX(thresholdOverLayView.frame) - CGRectGetWidth(startFrame)),min(CGRectGetMaxX(thresholdOverLayView.frame), CGRectGetWidth(backgroundImageView.frame) - CGRectGetWidth(startFrame)))
//////                } else {
//////                    leftConstraint.constant = min(min(max(startFrame.origin.x + movedWidth,0), CGRectGetMinX(thresholdOverLayView.frame)),min(CGRectGetMinX(thresholdOverLayView.frame), CGRectGetWidth(backgroundImageView.frame) - CGRectGetWidth(startFrame)))
//////                }
//////
//////                if movedHeight < 0 {
//////                    topConstraint.constant = min(max(max(startFrame.origin.y + movedHeight,0), CGRectGetMaxY(thresholdOverLayView.frame) - CGRectGetHeight(startFrame)),min(CGRectGetMaxY(thresholdOverLayView.frame), CGRectGetHeight(backgroundImageView.frame) - CGRectGetHeight(startFrame)))
//////                } else {
//////                    topConstraint.constant = min(min(max(startFrame.origin.y + movedHeight,0), CGRectGetMinY(thresholdOverLayView.frame)),min(CGRectGetMinY(thresholdOverLayView.frame), CGRectGetHeight(backgroundImageView.frame) - CGRectGetHeight(startFrame)))
//////                }
//////            case .none:
//////                print("")
//////            }
////
////
////
////        let movedWidth = point.x  - startPoint.x
////        let movedHeight = point.y - startPoint.y
////
////        switch currentPanEdge {
////        case .topLeft:
////            leftConstraint.constant =  min(CGRectGetMaxX(startFrame) - maxWidthDefault, max(CGRectGetMinX(startFrame) + movedWidth,0))
////            widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
////
////            topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeightDefault,max(CGRectGetMinY(startFrame) + movedHeight,0))
////            heightConstraint.constant = CGRectGetMaxY(startFrame) - topConstraint.constant
////        case .topRight:
////            widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth, maxWidthDefault),CGRectGetWidth(backgroundImageView.frame) - leftConstraint.constant)
////
////            topConstraint.constant = min(CGRectGetMaxY(startFrame) - maxHeightDefault,max(CGRectGetMinY(startFrame) + movedHeight,0))
////            heightConstraint.constant =  CGRectGetMaxY(startFrame) - topConstraint.constant
////
////        case .bottomLeft:
////            leftConstraint.constant = min(CGRectGetMaxX(startFrame) - maxWidthDefault,max(CGRectGetMinX(startFrame) + movedWidth,0))
////            widthConstraint.constant = CGRectGetMaxX(startFrame) - leftConstraint.constant
////
////            heightConstraint.constant = min(CGRectGetHeight(backgroundImageView.frame) - CGRectGetMinY(currentOverlayView.frame),max(CGRectGetHeight(startFrame) + movedHeight,maxHeightDefault))
////
////        case .bottomRight:
////            widthConstraint.constant = min(max(CGRectGetWidth(startFrame) + movedWidth,maxWidthDefault),CGRectGetWidth(backgroundImageView.frame) - leftConstraint.constant)
////            heightConstraint.constant = min(max(CGRectGetHeight(startFrame) + movedHeight,maxHeightDefault),CGRectGetHeight(backgroundImageView.frame) - topConstraint.constant)
////
////        case .center:
////            leftConstraint.constant = min(max(startFrame.origin.x + movedWidth,0),CGRectGetWidth(backgroundImageView.frame) - CGRectGetWidth(startFrame))
////            topConstraint.constant = min(max(startFrame.origin.y + movedHeight,0),CGRectGetHeight(backgroundImageView.frame) - CGRectGetHeight(startFrame))
////        case .none:
////            print("")
////        }
////
////        updateOverlayViews()
////    }
////
////    /// 更新坐标比例等
////    func updateOverlayViews() {
//////        areaOverLayView.percent = RectConvert.borderProportionCalculation(rect: areaOverLayView.frame, relativeSize: backgroundImageView.frame.size)
//////        areaOverLayView.percentLabel.isHidden = true
//////
//////        thresholdOverLayView.percent = RectConvert.borderProportionCalculation(rect: thresholdOverLayView.frame, relativeSize: areaOverLayView.frame.size)
//////
//////        let areaAndriodRect = RectConvert.convertToOriginImageAndroidRect(areaOverLayView.frame, iosRelateRect: backgroundImageView.frame, originImageSize: downloadOriginImage?.size ?? .zero)
//////
//////        areaOverLayView.topLeftRectText = "(\(areaAndriodRect[0]), \(areaAndriodRect[1]))"
//////        areaOverLayView.bottomRightRectText = "(\(areaAndriodRect[2]), \(areaAndriodRect[3]))"
//////
//////        /// 更新缓存数据
//////        self.areaModel.value = saveDataToServer()?.maxValue
//////        self.thresholdModel.value = saveDataToServer()?.minValue
////    }
////    /*
////    // Only override draw() if you perform custom drawing.
////    // An empty implementation adversely affects performance during animation.
////    override func draw(_ rect: CGRect) {
////        // Drawing code
////    }
////    */
////
////}
////
////extension SheepskinRaftView {
////    func setupOverlayViews() {
////        self.layoutIfNeeded()
////        /// 根据最新数据更新坐标系
////        parseRectToShowRect()
////
////        overLayViews.forEach({ $0.removeFromSuperview() })
////        overLayViews.removeAll()
////        topConstraints.removeAll()
////        leftConstraints.removeAll()
////        widthConstraints.removeAll()
////        heightConstraints.removeAll()
////
////        for (index, model) in policyModels.enumerated() {
////            let rectModel = defaultRectModels[index]
////
////            let layView = OverlayView()
////            layView.tag = index
////            backgroundImageView.addSubview(layView)
////
////            let originSize = backgroundImageView.bounds.size
////
////            layView.translatesAutoresizingMaskIntoConstraints = false
////            let topConstraint = layView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: rectModel.borderTop(originSize.height))
////            topConstraint.isActive = true
////            let leftConstraint = layView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: rectModel.borderLeft(originSize.width))
////            leftConstraint.isActive = true
////            let widthConstraint = layView.widthAnchor.constraint(equalToConstant: rectModel.borderWidth(originSize.width))
////            widthConstraint.isActive = true
////            let heightConstraint = layView.heightAnchor.constraint(equalToConstant: rectModel.borderHeight(originSize.height))
////            heightConstraint.isActive = true
////
////            overLayViews.append(layView)
////            topConstraints.append(topConstraint)
////            leftConstraints.append(leftConstraint)
////            widthConstraints.append(widthConstraint)
////            heightConstraints.append(heightConstraint)
////        }
////
////        self.layoutIfNeeded()
////
////        self.updateOverlayViews()
////
////        var hexColors = [String]()
////        for model in policyModels {
////            hexColors.append(model.attribute?.color ?? "")
////        }
////        setLineColor(hexColors: hexColors)
////    }
////}
////
////// MARK: - 设置数据
////extension SheepskinRaftView {
////    func setupChildModel(_ model: GameScenePolicyResourceListModel) {
////        self.childResourceModel = model
////
////        guard let childResources = childResourceModel?.childrenResource else {
////            return
////        }
////
////        self.policyModels = childResources
////    }
////
////    fileprivate func parseRectToShowRect() {
////        defaultRectModels.removeAll()
////
////        for model in policyModels {
////            if let rectModel = parseRangModel(model: model, defaultModel: SheepskinRaftView.areaInitialRectModel) {
////                defaultRectModels.append(rectModel)
////            }
////        }
////
////        if let image = downloadOriginImage {
////
////            for var rectModel in defaultRectModels {
////                self.updateRectModelToImageSize(image.size, rectModel: &rectModel)
////            }
////        }
////    }
////
////    func updateRectModelToImageSize(_ size: CGSize, rectModel: inout DefaultRectModel) {
////        let top = CGFloat(rectModel.top ) / CGFloat(rectModel.height) * size.height
////        let bottom = CGFloat(rectModel.bottom ) / CGFloat(rectModel.height) * size.height
////        let left = CGFloat(rectModel.left ) / CGFloat(rectModel.width) * size.width
////        let right = CGFloat(rectModel.right ) / CGFloat(rectModel.width) * size.width
////
////        rectModel.height = Int(size.height)
////        rectModel.width = Int(size.width)
////        rectModel.top = (top.isNaN || top.isInfinite) ? 0 : Int(top)
////        rectModel.bottom = (bottom.isNaN || bottom.isInfinite) ? 0 : Int(bottom)
////        rectModel.left = (left.isNaN || left.isInfinite) ? 0 : Int(left)
////        rectModel.right = (right.isNaN || right.isInfinite) ? 0 : Int(right)
////    }
////
////    fileprivate func parseRangModel(model: GameScenePolicyResourceListModel, defaultModel: DefaultRectModel) -> DefaultRectModel? {
////        var rectModel: DefaultRectModel?
////        if let data = model.rowValue()?.data(using: .utf8) {
////            do {
////                let model = try JSONDecoder().decode(DefaultRectModel.self, from: data)
////                rectModel = model
////            } catch _ {
////                Logger.debug(.none, "解析 范围model 出错")
////                rectModel = defaultModel
////            }
////        } else {
////            rectModel = defaultModel
////        }
////
////        return rectModel
////    }
////
////    fileprivate func setLineColor(hexColors: [String]) {
////        for (index, view) in overLayViews.enumerated() {
////            view.lineColor = UIColor(hexColor: hexColors[index])
////        }
////
//////        bottomView.setLineColor(areaHexColor: areaHexColor, thresholdHexColor: thresholdHexColor)
////    }
////
////    func setBackgroundImage(_ url: URL) {
////        tipsLabel.isHidden = true
////
////        func resetBackgroudImageLayout(_ image: UIImage) {
////            backgroundImageView.image = image
////
////            downloadOriginImage = image
////
////            let rect = caculateImageViewFrame(for: image, toSize: CGSize(width: self.mj_w, height: self.mj_h))
////            Logger.debug(.none, "图片size --- \(image.size)")
////            Logger.debug(.none, "图片rect --- \(rect)")
////
////            downloadImageConvertedFrame = rect
////
////            if let downloadImageFrame = downloadImageConvertedFrame {
////                backgroundImageView.snp.remakeConstraints { make in
////                    make.size.equalTo(downloadImageFrame.size)
////                    make.center.equalToSuperview()
////                }
////            }
////
////            self.setupOverlayViews()
////        }
////
////        func downloadImage() {
////            ImageCache.default.retrieveImage(forKey: cacheKey, options: nil) { [weak self] image, type in
////                if let image = image {
////                    DispatchQueue.main.async {
////                        resetBackgroudImageLayout(image)
////                    }
////                } else {
////                    ImageDownloader.default.downloadImage(with: url, completionHandler: { [weak self] (image, error, url, data) in
////                        if let image = image {
////                            DispatchQueue.main.async {
////                                resetBackgroudImageLayout(image)
////                            }
////
////                            ImageCache.default.store(image, forKey: cacheKey)
////                        } else {
////                            DispatchQueue.main.async {
////                                getCurrentDisplayController()?.showHUDToast(R.string.localizable.imageLoadingFailed())
////                            }
////                        }
////                    })
////                }
////            }
////        }
////
////        let cacheKey = url.absoluteString
////        DispatchQueue.global().async {
////            downloadImage()
////        }
////    }
////}
////
////// MARK: - 上传数据处理
////extension SheepskinRaftView {
////    func saveDataToServer() -> (maxValue: String?,
////                                minValue: String?)? {
////        return nil
////
//////        guard let originImage = downloadOriginImage else { return nil }
//////
//////        var areaRectModel = areaDefaultRectModel
//////        areaRectModel.width = Int(originImage.size.width)
//////        areaRectModel.height = Int(originImage.size.height)
//////
//////        let areaAndriodRect = RectConvert.convertToOriginImageAndroidRect(areaOverLayView.frame, iosRelateRect: backgroundImageView.frame, originImageSize: originImage.size)
//////        areaRectModel.left = areaAndriodRect[0]
//////        areaRectModel.top = areaAndriodRect[1]
//////        areaRectModel.right = areaAndriodRect[2]
//////        areaRectModel.bottom = areaAndriodRect[3]
//////        areaRectModel.ratio = areaOverLayView.percent
//////
//////        var thresholdRectModel = areaDefaultRectModel
//////        thresholdRectModel.width = Int(originImage.size.width)
//////        thresholdRectModel.height = Int(originImage.size.height)
//////
//////        let thresholdAndriodRect = RectConvert.convertToOriginImageAndroidRect(thresholdOverLayView.frame, iosRelateRect: backgroundImageView.frame, originImageSize: originImage.size)
//////        thresholdRectModel.left = thresholdAndriodRect[0]
//////        thresholdRectModel.top = thresholdAndriodRect[1]
//////        thresholdRectModel.right = thresholdAndriodRect[2]
//////        thresholdRectModel.bottom = thresholdAndriodRect[3]
//////        thresholdRectModel.ratio = thresholdOverLayView.percent
//////
//////        return (areaRectModel.convertToJSON(),  thresholdRectModel.convertToJSON())
////    }
////
////    func saveDataToServer() -> [String] {
////        var result = [String]()
////        guard let originImage = downloadOriginImage else { return result }
////
////        for (index, model) in defaultRectModels.enumerated() {
////            var rectModel = model
////
////            let layView = overLayViews[index]
////
////            let andriodRect = RectConvert.convertToOriginImageAndroidRect(layView.frame, iosRelateRect: backgroundImageView.frame, originImageSize: originImage.size)
////            rectModel.left = andriodRect[0]
////            rectModel.top = andriodRect[1]
////            rectModel.right = andriodRect[2]
////            rectModel.bottom = andriodRect[3]
////            rectModel.ratio = layView.percent
////
////            result.append(rectModel.convertToJSON() ?? "")
////        }
////
////        return result
////    }
////}
////
////// MARK: - 获取图片在imageView的坐标
////func caculateImageViewFrame(for image: UIImage, toSize size: CGSize) -> CGRect {
////    let imageRatio = (image.size.width / image.size.height)
////    let viewRatio = size.width / size.height
////    if imageRatio <= viewRatio {
////      let scale = size.height / image.size.height
////      let width = scale * image.size.width
////      let topLeftX = (size.width - width) * 0.5
////      return CGRect(x: topLeftX, y: 0, width: width, height: size.height)
////    } else {
////      let scale = size.width / image.size.width
////      let height = scale * image.size.height
////      let topLeftY = (size.height - height) * 0.5
////      return CGRect(x: 0.0, y: topLeftY, width: size.width, height: height)
////    }
////  }
