
import UIKit
import RealmSwift

protocol GiftDelegate: AnyObject {
    func selectGift(with giftId: Int)
}

protocol StickerDelegate: AnyObject {
    func selectSticker(with stickerId: Int)
}

class StickersViewController: UIViewController {
    
    // MARK: - Views
    // CollectionView
    internal let flowLayout = UICollectionViewFlowLayout()
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: StickerAndGiftCollectionCell.self)
            flowLayout.minimumInteritemSpacing = 16
            flowLayout.minimumLineSpacing = 16
            collectionView.collectionViewLayout = flowLayout
        }
    }
    
    // MARK: - Properties
    private let realm = try? Realm()
    
    private var giftsAndStickers: GiftsAndStickers?
     
    weak var giftDelegate: GiftDelegate?
    weak var stickerDelegate: StickerDelegate?

    private var stickerList: [Sticker] = []
    private var giftList: [Gift] = []
    
    var checkStatus: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGiftsAndStickersFromRealm()
        
    }
    
    // MARK: - Services
    private func fetchGiftsAndStickersFromRealm() {
        guard let giftsAndStickers = realm?.object(ofType: GiftsAndStickers.self, forPrimaryKey: 1),
              let giftsData = giftsAndStickers.giftsData,
              let stickersData = giftsAndStickers.stickersData else {
                  Logger.error("getting giftsAndStickers"); return
              }
        do {
            if checkStatus {
                let giftModel = try JSONDecoder().decode(GiftModel.self, from: giftsData)
                self.giftList = giftModel.data.reversed()
            } else {
                let stickerModel = try JSONDecoder().decode(StickerModel.self, from: stickersData)
                self.stickerList = stickerModel.data.reversed()
            }
            collectionView.reloadData()
        } catch {
            Logger.error(error)
        }
        
    }
}

// MARK: - DataSource
extension StickersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return checkStatus ? giftList.count : stickerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as StickerAndGiftCollectionCell
        cell.stickerLink = checkStatus
        ? self.giftList[indexPath.row].file
        : self.stickerList[indexPath.row].file
        return cell
    }
}

// MARK: - Delegate
extension StickersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objectId = checkStatus
        ? self.giftList[indexPath.row].id : self.stickerList[indexPath.row].id
        self.dismiss(animated: true) {
            if self.checkStatus {
                self.giftDelegate?.selectGift(with: objectId)
            } else {
                self.stickerDelegate?.selectSticker(with: objectId)
            }
        }
    }
}

// MARK: - FlowLayout

extension StickersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 32) / 2
        return CGSize(width: width, height: width)
    }
    
}
