//
//  LoadingView.swift
//  ChatApp
//
//  Created by mac on 7/19/25.
//

import UIKit

class LoadingView: UIView {

    @IBOutlet var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    /*
     这是当你用 LoadingView(frame: CGRect) 这种方式创建视图时，会调用的初始化器。
         •    它首先调用 super.init(frame:) 初始化父类 UIView 的部分；
         •    然后调用 initSubviews() 来加载 XIB 并添加子视图。
     
     */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    /*
     
     这个初始化器是在使用 Storyboard 或 XIB 生成该视图时自动调用的，属于遵守 NSCoding 协议所必须实现的方法。
         •    它通过解码方式构建视图；
         •    同样也调用 initSubviews()。
     */
    
    func initSubviews() {
        let nib = UINib(nibName: String(describing: type(of: self)),
                        bundle : Bundle(for: type(of: self)))
        nib.instantiate(withOwner: self)
        
        containerView.frame           = bounds
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        addSubview(containerView)
    }
    
    /*
     
     这是加载 .xib 的关键：
         •    UINib 是 UIKit 提供的类，用于加载 .xib 文件。
         •    nibName: String(describing: type(of: self))：
         •    type(of: self) 取当前实例的实际类型；
         •    String(describing:) 把类型转为字符串；
         •    例如：如果是 LoadingView，这句等价于 "LoadingView"。
         •    bundle: Bundle(for: type(of: self))：
         •    查找当前类所在的 Bundle；
         •    一般用于支持多模块或动态框架；
         •    若写成 nil，则默认是主 Bundle，也可用。
     */
    
}
