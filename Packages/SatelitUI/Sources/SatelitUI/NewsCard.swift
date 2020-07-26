import UIKit
import SwiftUI

public final class NewsCard: UIView {
    
    private lazy var infoView: NewsCardInfoView = {
        let view = NewsCardInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .tertiarySystemBackground
        return view
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var toolbarView: NewsCardToolbarView = {
        let view = NewsCardToolbarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let allowsContent: Bool
    
    public init(allowsContent: Bool, frame: CGRect = .zero) {
        self.allowsContent = allowsContent
        super.init(frame: frame)
        
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        // TODO
    }
}

// MARK: - Private types

private final class NewsCardInfoView: UIView {
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh - 1, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh - 1, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .systemGray5
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.font = sourceLabel.font
        label.textColor = sourceLabel.textColor
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(sourceLabel)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            sourceLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sourceLabel.topAnchor.constraint(equalTo: topAnchor),
            sourceLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: Metrics.Common.innerInterItemOffset),
            sourceLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            dateLabel.topAnchor.constraint(equalTo: topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

private final class NewsCardToolbarView: UIView {
    lazy var shareButton: RoundedCardButton = {
        let button = RoundedCardButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.icon = UIImage(systemName: "square.and.arrow.up")
        button.text = R.Localization.Card.shareArticle
        button.setTintColor(.systemGray, for: .normal)
        button.setBackgroundColor(.systemGray5, for: .highlighted)
        return button
    }()
    
    lazy var likeButton: RoundedCardButton = {
        let button = RoundedCardButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.icon = UIImage(systemName: "heart")
        button.text = "0"
        button.setTintColor(.systemGray, for: .normal)
        button.setTintColor(.systemRed, for: .selected)
        button.setBackgroundColor(.systemGray5, for: .highlighted)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubview(shareButton)
        addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: topAnchor),
            likeButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: -Metrics.Common.innerInterItemOffset),
            likeButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            shareButton.topAnchor.constraint(equalTo: topAnchor),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
