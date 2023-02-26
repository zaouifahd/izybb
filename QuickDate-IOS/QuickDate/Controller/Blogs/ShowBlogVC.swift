

import UIKit
import WebKit

class ShowBlogVC: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewsLabel: UILabel!
    
    var htmlString:String? = ""
    var locationURL:String? = ""
    var object:[String:Any]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        hideTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        showTabBar()
    }
    private func setupUI() {
        navigationController?.navigationBar.tintColor = Theme.primaryTextColor.colour
        let content = htmlString?.htmlAttributedString ?? ""
        let html = createHTML(with: content)
        webView.loadHTMLString(html, baseURL: nil)
        //        webView.allowsBackForwardNavigationGestures = true
        handleViews()
    }
    // !!!: Be careful about webView I added all properties in HTML style
    private func createHTML(with body: String) -> String {
        let width = self.view.frame.width - 32
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title></title>
            <style> img { width: \(width)px; object-fit: cover; } </style>
            <style> body {
                    font-size: 16px;
                    background-color: #424242;
                    color: white;
                } </style>
        </head>
        <body>
            \(body)
        </body>
        </html>
        """
    }
    
    private func handleViews() {
        guard let object = object else {
            return
        }
        let view = object["view"] as? Int
        self.viewsLabel.text = NSLocalizedString("\(view ?? 0) Views", comment: "\(view ?? 0) Views")
    }
    
    private func alertShow(URL: String) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let copyLink = UIAlertAction(title: "Copy Link".localized, style: .default) { (action) in
            UIPasteboard.general.string = URL
            self.view.makeToast("Copy to clipboard".localized)
        }
        let share = UIAlertAction(title: "Share".localized, style: .default) { (action) in
            self.share(url: URL)
        }
        let cancel = UIAlertAction(title: "Cancel".localized, style: .destructive, handler: nil)
        alert.addAction(copyLink)
        alert.addAction(share)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func share(url: String) {
        let myWebsite = NSURL(string:url)
        guard let url = myWebsite else {
            print("nothing found")
            return
        }
        let shareItems:Array = [ url]
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func moreButtonPressed(_ sender: UIButton) {
        alertShow(URL: locationURL ?? "")
    }
    
    
}
