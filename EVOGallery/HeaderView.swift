import UIKit

protocol HeaderViewDelegate: class {
    func headerViewDidPressBackButton(_ headerView: HeaderView?)
    func headerViewDidPressShareButton(_ headerView: HeaderView?)
}

class HeaderView: UIView {
    weak var viewDelegate: HeaderViewDelegate?
    static let ButtonSize = CGFloat(50.0)
    static let TitileSize = CGSize(width: 150, height: 30)
    static let TopMargin = CGFloat(15.0)

    lazy var backButton: UIButton = {
        let image = UIImage(named: "icArrowNext")!
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        button.tintColor = .white
        
        return button
    }()

    lazy var shareButton: UIButton = {
        let image = UIImage(named: "icExit")!
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        button.tintColor = .white

        return button
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "YOBA"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var navigationView: UIView = {
        let windowRect = UIScreen.main.bounds
        let navView = UIView()
        navView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        navView.addSubview(self.backButton)
        navView.addSubview(self.shareButton)
        navView.addSubview(self.titleLabel)
    
        return navView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.navigationView)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backButton.frame = CGRect(x: 0, y: HeaderView.TopMargin, width: HeaderView.ButtonSize, height: HeaderView.ButtonSize)

        let x = UIScreen.main.bounds.size.width - HeaderView.ButtonSize
        self.shareButton.frame = CGRect(x: x, y: HeaderView.TopMargin, width: HeaderView.ButtonSize, height: HeaderView.ButtonSize)
        
        self.titleLabel.frame = CGRect(x: self.frame.size.width / 2 - HeaderView.TitileSize.width / 2, y: (self.frame.size.height / 2 - HeaderView.TitileSize.height / 2) + 10 , width: HeaderView.TitileSize.width, height: HeaderView.TitileSize.height)
        
        self.navigationView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }

    @objc func backButtonPressed() {
        self.viewDelegate?.headerViewDidPressBackButton(self)
    }

    @objc func shareButtonPressed() {
        self.viewDelegate?.headerViewDidPressShareButton(self)
    }
}
