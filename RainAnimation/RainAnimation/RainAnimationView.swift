//
//  RainAnimationView.swift
//  Sheng
//
//  Created by Cheng Rong on 2018/2/7.
//  Copyright © 2018年 First Cloud. All rights reserved.
//

import UIKit
//屏幕宽高
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
class RainAnimationView: UIView {

    var image:UIImage = UIImage.init() {
        didSet{
            cell.contents = image.compressBkyToScaleSize(toWidth: 50).cgImage
        }
    }
    
    private var rainLayer: CAEmitterLayer!
    private var cell: CAEmitterCell!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.rainAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
//    func rainAnimation() {
//        rainLayer = CAEmitterLayer()
//        rainLayer.emitterShape = kCAEmitterLayerLine // Default emit orientation is up
//        rainLayer.emitterMode = kCAEmitterLayerOutline
//        rainLayer.renderMode = kCAEmitterLayerUnordered
//        rainLayer.emitterPosition = CGPoint(x: UIViewController.BKYgetCurrentViewCtrl().view.bounds.midX, y: 0)
//        rainLayer.emitterSize = CGSize(width: UIViewController.BKYgetCurrentViewCtrl().view.bounds.width, height: 0)
//        rainLayer.birthRate = 0 // Stop animation by default
//
//        cell = CAEmitterCell()
//        cell.contents = UIImage.init(named: "rose0928")?.cgImage
//        cell.scale = 1
//        cell.lifetime = 5
//        cell.birthRate = 60
//        cell.velocity = 100
//        cell.emissionLongitude = CGFloat.pi
//
//        rainLayer.emitterCells = [cell]
//        self.layer.addSublayer(rainLayer)
//    }
    
    func rainAnimation() {
        let rect = CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        rainLayer = CAEmitterLayer()
        rainLayer.frame = rect
        self.layer.addSublayer(rainLayer)
        rainLayer.emitterShape = CAEmitterLayerEmitterShape.rectangle

        //kCAEmitterLayerPoint
        //kCAEmitterLayerLine
        //kCAEmitterLayerRectangle

        rainLayer.emitterPosition = CGPoint(x: rect.width/2, y: rect.height/2)
        rainLayer.emitterSize = rect.size
        rainLayer.birthRate = 0

        cell = CAEmitterCell()
//        cell.contents = UIImage(named: "rose0928")!.compressBkyToScaleSize(toWidth: 50).cgImage
        cell.birthRate = 80  //每秒产生粒子
        cell.lifetime = 5  //存活1秒
        cell.lifetimeRange = 5.0

        rainLayer.emitterCells = [cell]  //这里可以设置多种粒子 我们以一种为粒子
        cell.yAcceleration = 200.0  //给Y方向一个加速度
        cell.xAcceleration = 80.0 //x方向一个加速度
        cell.velocity = 160.0 //初始速度
        cell.emissionLongitude = CGFloat(-M_PI) //向左
        cell.velocityRange = 200.0   //随机速度 -200+20 --- 200+20
        cell.emissionRange = CGFloat(M_PI_2) //随机方向 -pi/2 --- pi/2
        //emitterCell.color = UIColor(red: 0.9, green: 1.0, blue: 1.0,
        //   alpha: 1.0).CGColor //指定颜色
//        cell.redRange = 0.3
//        cell.greenRange = 0.3
//        cell.blueRange = 0.3  //三个随机颜色

        cell.scale = 1
        cell.scaleRange = 0.8  //0 - 1.6
//        cell.scaleSpeed = 0  //逐渐变小

//        cell.alphaRange = 0.75   //随机透明度
//        cell.alphaSpeed = -0.15  //逐渐消失
    }
    
    var stopAnimation:(()->())?
    func startAnimation() {
//        let birthRateAnimation = CABasicAnimation(keyPath: "birthRate")
//        birthRateAnimation.duration = 4
//        birthRateAnimation.fromValue = 0
//        birthRateAnimation.toValue = 1
//        rainLayer.birthRate = 0
        rainLayer.beginTime = CACurrentMediaTime()
        rainLayer.birthRate = 1
        
//        rainLayer.add(birthRateAnimation, forKey: "birthRate")birthRateAnimation.duration
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard self != nil else { return }
//            birthRateAnimation.fromValue = 1
//            birthRateAnimation.toValue = 0
            self?.rainLayer.birthRate = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                if let block = self?.stopAnimation {
                    block()
                }
            }
        }
    }
}


extension UIImage{
    /// 压缩图片到指定宽度
    ///
    /// - Parameter toWidth: 压缩后的宽度
    /// - Returns: 压缩后的图片
    func compressBkyToScaleSize(toWidth:CGFloat) -> UIImage {
        var toSize = self.size
        if self.size.width > toWidth {
            toSize.height = toSize.height * toWidth/toSize.width
            toSize.width = toWidth
        }
        UIGraphicsBeginImageContext(toSize)
        self.draw(in: CGRect.init(origin: .zero, size: toSize))
        let newImage  = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
