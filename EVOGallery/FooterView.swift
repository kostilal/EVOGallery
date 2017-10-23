import UIKit

protocol FooterViewDelegate: class {
    func footerView(_ footerView: FooterView, didPressEditButton button: UIButton)
    func footerView(_ footerView: FooterView, didPressDeleteButton button: UIButton)
}

class FooterView: UIView {
    weak var viewDelegate: FooterViewDelegate?
    static let ButtonSize = CGFloat(50.0)

    lazy var editButton: UIButton = {
        let image = UIImage(named: "icEdit")!
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitle("Изменить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6)
        button.addTarget(self, action: #selector(FooterView.favoriteAction(button:)), for: .touchUpInside)

        return button
    }()

    lazy var deleteButton: UIButton = {
        let image = UIImage(named: "icDel")!
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitle("Удалить", for: .normal)
        button.alpha = 0.5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 6, 0, 0)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 6)
        button.addTarget(self, action: #selector(FooterView.deleteAction(button:)), for: .touchUpInside)

        return button
    }()
    
    lazy var actionsView: UIView = {
        let windowRect = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 0, y: 0, width: windowRect.size.width, height: 50))
        view.backgroundColor = UIColor(red: 82/255, green: 70/255, blue: 156/255, alpha: 1)
        view.addSubview(self.editButton)
        view.addSubview(self.deleteButton)
        
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.actionsView)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let backSizes = self.widthForElementAtIndex(index: 0, totalElements: 2)
        self.editButton.frame = CGRect(x: backSizes.x, y: 0, width: backSizes.width, height: FooterView.ButtonSize)

        let shareSizes = self.widthForElementAtIndex(index: 1, totalElements: 2)
        self.deleteButton.frame = CGRect(x: shareSizes.x, y: 0, width: shareSizes.width, height: FooterView.ButtonSize)
    }

    func widthForElementAtIndex(index: Int, totalElements: Int) -> (x: CGFloat, width: CGFloat) {
        let bounds = UIScreen.main.bounds
        let singleFrame = bounds.width / CGFloat(totalElements)

        return (singleFrame * CGFloat(index), singleFrame)
    }

    @objc func favoriteAction(button: UIButton) {
        self.viewDelegate?.footerView(self, didPressEditButton: button)
    }

    @objc func deleteAction(button: UIButton) {
        self.viewDelegate?.footerView(self, didPressDeleteButton: button)
    }
}
