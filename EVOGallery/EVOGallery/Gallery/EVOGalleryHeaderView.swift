import UIKit

protocol EVOGalleryHeaderDelegate: EVOOverlayViewDelegate {
    func shareButtonPressed()
}

class EVOGalleryHeaderView: EVOOverlayView {
    public weak var headerDelegate: EVOGalleryHeaderDelegate?
    
    private let titleSize = CGSize(width: 150, height: 30)
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.closeButtonImage, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()

    lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.shareButtonImage, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        
        return button
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var navigationView: UIView = {
        let navView = UIView()
        navView.backgroundColor = self.overlayStyle.headerBackgroundColor
    
        return navView
    }()

    override func setupUI() {
        self.addSubview(self.navigationView)
        self.navigationView.addSubview(self.backButton)
        self.navigationView.addSubview(self.shareButton)
        self.navigationView.addSubview(self.titleLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backButton.frame = CGRect(x: 0,
                                       y: self.overlayStyle.headerSize.height - self.overlayStyle.buttonMargin - self.overlayStyle.controlButtonsSize.height,
                                       width: self.overlayStyle.controlButtonsSize.width,
                                       height: self.overlayStyle.controlButtonsSize.height)

        self.shareButton.frame = CGRect(x: self.overlayStyle.headerSize.width - self.overlayStyle.buttonMargin - self.overlayStyle.controlButtonsSize.width,
                                        y: self.overlayStyle.headerSize.height - self.overlayStyle.buttonMargin - self.overlayStyle.controlButtonsSize.height,
                                        width: self.overlayStyle.controlButtonsSize.width,
                                        height: self.overlayStyle.controlButtonsSize.height)
        
        self.titleLabel.frame = CGRect(x: self.overlayStyle.headerSize.width / 2 - self.titleSize.width / 2,
                                       y: (self.overlayStyle.headerSize.height / 2 - self.titleSize.height / 2) + 10,
                                       width: self.titleSize.width,
                                       height: self.titleSize.height)
        
        self.navigationView.frame = CGRect(x: 0,
                                           y: 0,
                                           width: self.overlayStyle.headerSize.width,
                                           height: self.overlayStyle.headerSize.height)
    }
    
    override func buttonPressed(sender: UIButton) {
        super.buttonPressed(sender: sender)
        
        if sender == self.backButton {
            self.headerDelegate?.closeButtonPressed()
        } else {
            self.headerDelegate?.shareButtonPressed()
        }
    }
}
