import Foundation

enum R {
    enum Localization {
        enum Card {}
    }
}

extension R.Localization.Card {
    static var shareArticle: String {
        return NSLocalizedString(
            "button.share.article",
            bundle: Bundle.module,
            value: "Share",
            comment: "Share news article button"
        )
    }
}
