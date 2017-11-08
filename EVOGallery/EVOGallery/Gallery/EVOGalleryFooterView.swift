import UIKit

protocol EVOGalleryFooterDelegate: EVOOverlayViewDelegate {
    func editButtonPressed()
    func deleteButtonPressed()
}

class EVOGalleryFooterView: EVOOverlayView {
    public weak var footerDelegate: EVOGalleryFooterDelegate?
    
    private let buttonImageInset = UIEdgeInsetsMake(0, 0, 0, 6)
    private let buttonTitleInset = UIEdgeInsetsMake(0, 6, 0, 0)

    lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.editButtonImage, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        button.setTitle(NSLocalizedString("gallery.edit.button.title", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleEdgeInsets = self.buttonTitleInset
        button.imageEdgeInsets = self.buttonImageInset
        
        return button
    }()

    lazy var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(self.overlayStyle.deleteButtonImage, for: .normal)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.tintColor = self.overlayStyle.controlButtonsTintColor
        button.setTitle(NSLocalizedString("gallery.delete.button.title", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.titleEdgeInsets = self.buttonTitleInset
        button.imageEdgeInsets = self.buttonImageInset

        return button
    }()
    
    lazy var actionsView: UIView = {
        let view = UIView()
        view.backgroundColor = self.overlayStyle.footerBackgroundColor
        
        return view
    }()

    override func setupUI() {
        self.addSubview(self.actionsView)
        self.actionsView.addSubview(self.editButton)
        self.actionsView.addSubview(self.deleteButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.actionsView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: self.overlayStyle.footerSize.width,
                                        height: self.overlayStyle.footerSize.height)

        let editSize = self.widthForElementAtIndex(index: 0, totalElements: 2)
        self.editButton.frame = CGRect(x: editSize.x,
                                       y: self.overlayStyle.footerSize.height/2 - self.overlayStyle.controlButtonsSize.height/2,
                                       width: editSize.width,
                                       height: self.overlayStyle.controlButtonsSize.height)

        let deleteSize = self.widthForElementAtIndex(index: 1, totalElements: 2)
        self.deleteButton.frame = CGRect(x: deleteSize.x,
                                         y: self.overlayStyle.footerSize.height/2 - self.overlayStyle.controlButtonsSize.height/2,
                                         width: deleteSize.width,
                                         height: self.overlayStyle.controlButtonsSize.height)
    }

    func widthForElementAtIndex(index: Int, totalElements: Int) -> (x: CGFloat, width: CGFloat) {
        let singleFrame = self.overlayStyle.footerSize.width / CGFloat(totalElements)

        return (singleFrame * CGFloat(index), singleFrame)
    }
    
    override func buttonPressed(sender: UIButton) {
        super.buttonPressed(sender: sender)
        
        if sender == self.editButton {
            self.footerDelegate?.editButtonPressed()
        } else {
            self.footerDelegate?.deleteButtonPressed()
        }
    }
}
