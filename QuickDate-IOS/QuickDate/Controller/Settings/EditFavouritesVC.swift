

import UIKit
import Async
import GoogleMobileAds
import QuickDateSDK

class EditFavouritesVC: BaseViewController {
    
    @IBOutlet weak var dishTextFIeld: FloatingTextField!
    @IBOutlet weak var tvShowTextField: FloatingTextField!
    @IBOutlet weak var colorTextFIeld: FloatingTextField!
    @IBOutlet weak var movieTextField: FloatingTextField!
    @IBOutlet weak var bookTextField: FloatingTextField!
    @IBOutlet weak var sportTextField: FloatingTextField!
    @IBOutlet weak var cityTextField: FloatingTextField!
    @IBOutlet weak var hobbyTextField: FloatingTextField!
    @IBOutlet weak var songTextField: FloatingTextField!
    @IBOutlet weak var musicTextField: FloatingTextField!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var lblSave: UILabel!
    @IBOutlet weak var viewSave: UIView!
    
    var bannerView: GADBannerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideTabBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showTabBar()
    }
    
    @IBAction func savePressed(_ sender: Any) {
        updateFavourites()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    private func setupUI(){
        if ControlSettings.shouldShowAddMobBanner{
            
            bannerView = GADBannerView(adSize: GADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = ControlSettings.addUnitId
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            
        }
        self.favoriteLabel.text = NSLocalizedString("Favorite Info", comment: "Favorite Info")
        
        
        self.musicTextField.setTitle(title: NSLocalizedString("Music", comment: "Music"))
        self.dishTextFIeld.setTitle(title: NSLocalizedString("Dish", comment: "Dish"))
        self.songTextField.setTitle(title: NSLocalizedString("Song", comment: "Song"))
        self.hobbyTextField.setTitle(title: NSLocalizedString("Hobby", comment: "Hobby"))
        self.cityTextField.setTitle(title: NSLocalizedString("City", comment: "City"))
        self.sportTextField.setTitle(title: NSLocalizedString("Sport", comment: "Sport"))
        self.bookTextField.setTitle(title: NSLocalizedString("Book", comment: "Book"))
        self.movieTextField.setTitle(title: NSLocalizedString("Movie", comment: "Movie"))
        self.colorTextFIeld.setTitle(title: NSLocalizedString("Color", comment: "Color"))
        self.tvShowTextField.setTitle(title: NSLocalizedString("Tv Show", comment: "Tv Show"))
        self.lblSave.text = NSLocalizedString("SAVE", comment: "SAVE")
        
        viewSave.cornerRadiusV = viewSave.bounds.height / 2
        let appInstance: AppInstance = .shared
        let userSettings = appInstance.userProfileSettings
        self.musicTextField.text = userSettings?.favourites.music
        self.dishTextFIeld.text = userSettings?.favourites.dish
        self.songTextField.text = userSettings?.favourites.song
        self.hobbyTextField.text = userSettings?.favourites.hobby
        self.cityTextField.text = userSettings?.favourites.city
        self.sportTextField.text  = userSettings?.favourites.sport
        self.bookTextField.text = userSettings?.favourites.book
        self.movieTextField.text = userSettings?.favourites.movie
        self.colorTextFIeld.text = userSettings?.favourites.colour
        self.tvShowTextField.text = userSettings?.favourites.tvChoice
        
        
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
                bannerView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(bannerView)
                view.addConstraints(
                    [NSLayoutConstraint(item: bannerView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: bottomLayoutGuide,
                                        attribute: .top,
                                        multiplier: 1,
                                        constant: 0),
                     NSLayoutConstraint(item: bannerView,
                                        attribute: .centerX,
                                        relatedBy: .equal,
                                        toItem: view,
                                        attribute: .centerX,
                                        multiplier: 1,
                                        constant: 0)
                    ])
            }
    private func updateFavourites(){
        if Connectivity.isConnectedToNetwork(){
            self.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let music  = self.musicTextField.text ?? ""
            let dish = self.dishTextFIeld.text ?? ""
            let song = self.songTextField.text ?? ""
            let hobby = self.hobbyTextField.text ?? ""
            let city = self.cityTextField.text ?? ""
            let sport = self.sportTextField.text ?? ""
            let book = self.bookTextField.text ?? ""
            let movie = self.movieTextField.text ?? ""
            let color = self.colorTextFIeld.text ?? ""
            let tvShow = self.tvShowTextField.text ?? ""
            Async.background({
                ProfileManger.instance.editFavourite(AccessToken: accessToken, Music: music, Dish: dish, Song: song, Hobby: hobby, City: city, Sport: sport, Book: book, Movie: movie, Color: color, Tvshow: tvShow, completionBlock: { (success, sessionError, error) in
                     if success != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                Logger.debug("userList = \(success?.data ?? "")")
                                self.view.makeToast(success?.data ?? "")
                                
                                let appManager: AppManager = .shared
                                appManager.fetchUserProfile()
                                Logger.debug("FetchUserProfile Fetched)")
                                
                                
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.dismissProgressDialog {
                                
                                self.view.makeToast(sessionError?.message ?? "")
                                Logger.error("sessionError = \(sessionError?.message ?? "")")
                            }
                        })
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                self.view.makeToast(error?.localizedDescription ?? "")
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                            }
                        })
                    }
                })
              
            })
            
        }else{
            Logger.error("internetError = \(InterNetError)")
            self.view.makeToast(InterNetError)
        }
        
    }
}
