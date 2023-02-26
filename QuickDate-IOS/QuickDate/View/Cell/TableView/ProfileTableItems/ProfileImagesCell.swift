
import UIKit
import Async
import QuickDateSDK

class ProfileImagesCell: UITableViewCell {
    
    @IBOutlet weak var cross6Btn: UIButton!
    @IBOutlet weak var cross5Btn: UIButton!
    @IBOutlet weak var cross4Btn: UIButton!
    @IBOutlet weak var cross3Btn: UIButton!
    @IBOutlet weak var cross2Btn: UIButton!
    @IBOutlet weak var cross1Btn: UIButton!
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    @IBOutlet var imageView4: UIImageView!
    @IBOutlet var imageView5: UIImageView!
    @IBOutlet var imageView6: UIImageView!
    
    var vc = profileVC()
    private let imagePickerController = UIImagePickerController()
    private var imageCount:Int? = 1
    // MARK: - Property Injections
    private let mediaFiles: [MediaFile]? = AppInstance.shared.userProfileSettings?.mediaFiles
    private let appManager: AppManager = .shared
    private let appInstance: AppInstance = .shared

    override func awakeFromNib() {
//        self.cross1Btn.backgroundColor = .Button_StartColor
//        self.cross2Btn.backgroundColor = .Button_StartColor
//        self.cross3Btn.backgroundColor = .Button_StartColor
//        self.cross4Btn.backgroundColor = .Button_StartColor
//        self.cross5Btn.backgroundColor = .Button_StartColor
//        self.cross6Btn.backgroundColor = .Button_StartColor
        super.awakeFromNib()
        let imageOneTapped = UITapGestureRecognizer(target: self, action:  #selector (self.ImageView1Tapped(_:)))
        self.imageView1.addGestureRecognizer(imageOneTapped)
        
        let imageTwoTapped = UITapGestureRecognizer(target: self, action:  #selector (self.ImageView2Tapped(_:)))
        self.imageView2.addGestureRecognizer(imageTwoTapped)
        
        let imageThreeTapped = UITapGestureRecognizer(target: self, action:  #selector (self.ImageView3Tapped(_:)))
        self.imageView3.addGestureRecognizer(imageThreeTapped)
        
        let imageFourTapped = UITapGestureRecognizer(target: self, action:  #selector (self.ImageView4Tapped(_:)))
        self.imageView4.addGestureRecognizer(imageFourTapped)
        
        let imageFiveTapped = UITapGestureRecognizer(target: self, action:  #selector (self.ImageView5Tapped(_:)))
        self.imageView5.addGestureRecognizer(imageFiveTapped)
        
        let imageSixTapped = UITapGestureRecognizer(target: self, action:  #selector (self.ImageView6Tapped(_:)))
        self.imageView6.addGestureRecognizer(imageSixTapped)
    }
    
    // MARK: - Open Actions
    @objc func ImageView1Tapped(_ sender:UITapGestureRecognizer){
        imageCount = 1
        Logger.verbose("Tapped ")
        let alert = UIAlertController(title: "", message: "Select Source", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    @objc func ImageView2Tapped(_ sender:UITapGestureRecognizer){
        imageCount = 2
        Logger.verbose("Tapped ")
        let alert = UIAlertController(title: "", message: "Select Source", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    @objc func ImageView3Tapped(_ sender:UITapGestureRecognizer){
        imageCount = 3
        Logger.verbose("Tapped ")
        let alert = UIAlertController(title: "", message: "Select Source", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    @objc func ImageView4Tapped(_ sender:UITapGestureRecognizer){
        imageCount = 4
        Logger.verbose("Tapped ")
        let alert = UIAlertController(title: "", message: "Select Source", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    @objc func ImageView5Tapped(_ sender:UITapGestureRecognizer){
        imageCount = 5
        Logger.verbose("Tapped ")
        let alert = UIAlertController(title: "", message: "Select Source", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }
    @objc func ImageView6Tapped(_ sender:UITapGestureRecognizer){
        imageCount = 6
        Logger.verbose("Tapped ")
        let alert = UIAlertController(title: "", message: "Select Source", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .camera
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let gallery = UIAlertAction(title: "Gallery", style: .default) { (action) in
            self.imagePickerController.delegate = self
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.sourceType = .photoLibrary
            self.vc.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        vc.present(alert, animated: true, completion: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Delete Actions
    
    @IBAction func deleteImage1PRessed(_ sender: Any) {
//        let mediaFiles = AppInstance.shared.userProfile["mediafiles"] as? [[String:Any]]
        if imageView1.image == R.image.thumbnail(){
            Logger.verbose("nothing to delete")
        }else{
//            self.deleteMedia(Id: mediaFiles?[0]["id"] as? Int ?? 0)
            self.deleteMedia(Id: mediaFiles?[0].id ?? 0)
            appInstance.userProfileSettings?.mediaFiles.remove(at: 0)
            imageView1.image = R.image.thumbnail()
        }
    }
    @IBAction func deleteImage2Pressed(_ sender: Any) {
//        let mediaFiles = AppInstance.shared.userProfile["mediafiles"] as? [[String:Any]]
        if imageView2.image == R.image.thumbnail(){
            Logger.verbose("nothing to delete")
            
        }else{
//            self.deleteMedia(Id: mediaFiles?[1]["id"] as? Int ?? 0)
            self.deleteMedia(Id: mediaFiles?[1].id ?? 0)
            appInstance.userProfileSettings?.mediaFiles.remove(at: 1)
            imageView2.image = R.image.thumbnail()
        }
    }
    @IBAction func deleteImage3Pressed(_ sender: Any) {
//        let mediaFiles = AppInstance.shared.userProfile["mediafiles"] as? [[String:Any]]
        if imageView3.image == R.image.thumbnail(){
            Logger.verbose("nothing to delete")
            
        }else{
//            self.deleteMedia(Id:  mediaFiles?[1]["id"] as? Int  ?? 0)
            self.deleteMedia(Id: mediaFiles?[2].id ?? 0)
            appInstance.userProfileSettings?.mediaFiles.remove(at: 2)
            imageView3.image = R.image.thumbnail()
        }
    }
    @IBAction func deleteImage6Pressed(_ sender: Any) {
//        let mediaFiles = AppInstance.shared.userProfile["mediafiles"] as? [[String:Any]]
        if imageView6.image == R.image.thumbnail(){
            Logger.verbose("nothing to delete")
            
        }else{
//            self.deleteMedia(Id:  mediaFiles?[1]["id"] as? Int  ?? 0)
            self.deleteMedia(Id: mediaFiles?[5].id ?? 0)
            appInstance.userProfileSettings?.mediaFiles.remove(at: 5)
            imageView6.image = R.image.thumbnail()
        }
    }
    @IBAction func deleteImage4Pressed(_ sender: Any) {
//        let mediaFiles = AppInstance.shared.userProfile["mediafiles"] as? [[String:Any]]
        if imageView4.image == R.image.thumbnail(){
            Logger.verbose("nothing to delete")

        }else{
//            self.deleteMedia(Id:  mediaFiles?[1]["id"] as? Int  ?? 0)
            self.deleteMedia(Id: mediaFiles?[3].id ?? 0)
            appInstance.userProfileSettings?.mediaFiles.remove(at: 3)
            imageView4.image = R.image.thumbnail()
        }
    }
    @IBAction func deleteImage5Pressed(_ sender: Any) {
//        let mediaFiles = AppInstance.shared.userProfile["mediafiles"] as? [[String:Any]]
        if imageView5.image == R.image.thumbnail(){
            Logger.verbose("nothing to delete")
        }else{
//            self.deleteMedia(Id:  mediaFiles?[1]["id"] as? Int ?? 0)
            self.deleteMedia(Id: mediaFiles?[4].id ?? 0)
            appInstance.userProfileSettings?.mediaFiles.remove(at: 4)
            imageView5.image = R.image.thumbnail()
        }
    }
}
extension  ProfileImagesCell:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        if self.imageCount == 1{
            self.imageView1.image = image
            
        }else if self.imageCount == 2{
             self.imageView2.image = image
        }
        else if self.imageCount == 3{
             self.imageView3.image = image
        }
        else if self.imageCount == 4{
             self.imageView4.image = image
        }
        else if self.imageCount == 5{
             self.imageView5.image = image
        }else if self.imageCount == 6{
             self.imageView6.image = image
        }
        self.vc.dismiss(animated: true, completion: nil)
        self.updateMedia(Image: image)
    }
    private func updateMedia(Image:UIImage){
        if Connectivity.isConnectedToNetwork(){
            self.vc.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            let mediaImageData = Image.jpegData(compressionQuality: 0.2)
            Async.background({
                UpdateMediaManager.instance.updateAvatar(AccesToken: accessToken, MediaData: mediaImageData, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.debug("success = \(success?.data ?? "")")
                                self.vc.view.makeToast(success?.data ?? "")
                                self.appManager.fetchUserProfile()
                                Logger.verbose("UPDATED")
                            }
                        })
                        
                    }else if sessionError != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                self.vc.view.makeToast(sessionError?.errors?.errorText ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.vc.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.vc.view.makeToast(InterNetError)
        }
        
    }
    private func deleteMedia(Id:Int){
        if Connectivity.isConnectedToNetwork(){
            self.vc.showProgressDialog(with: "Loading...")
            let accessToken = AppInstance.shared.accessToken ?? ""
            
            Async.background({
                UpdateMediaManager.instance.deleteMedia(AccessToken: accessToken, MediaId: Id, completionBlock: { (success, sessionError, error) in
                    if success != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.debug("success = \(success?.message ?? "")")
                                self.vc.view.makeToast(success?.message ?? "")
                                
                                self.appManager.fetchUserProfile()
                                Logger.verbose("UPDATED")
                            }
                        })
                    }else if sessionError != nil{
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.error("sessionError = \(sessionError?.errors?.errorText ?? "")")
                                self.vc.view.makeToast(sessionError?.errors?.errorText ?? "")
                            }
                        })
                    }else {
                        Async.main({
                            self.vc.dismissProgressDialog {
                                Logger.error("error = \(error?.localizedDescription ?? "")")
                                self.vc.view.makeToast(error?.localizedDescription ?? "")
                            }
                        })
                    }
                })
            })
        }else{
            Logger.error("internetErrro = \(InterNetError)")
            self.vc.view.makeToast(InterNetError)
        }
    }
}
