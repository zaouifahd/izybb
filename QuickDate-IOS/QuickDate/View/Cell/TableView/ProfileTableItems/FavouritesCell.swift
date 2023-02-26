

import UIKit

class FavouritesCell: UITableViewCell {
    @IBOutlet weak var favorIteLabel: UILabel!
    
    @IBOutlet weak var tvShowTitleLabel: UILabel!
    @IBOutlet weak var colorTitleLabel: UILabel!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var sportsTitleLabel: UILabel!
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var hobbyTitleLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var dishTitleLabel: UILabel!
    @IBOutlet weak var musicGenreTitleLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var musicGenreLabel: UILabel!
    @IBOutlet var dishLabel: UILabel!
    @IBOutlet var songLabel: UILabel!
    @IBOutlet var hobbyLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var sportLabel: UILabel!
    @IBOutlet var bookLabel: UILabel!
    @IBOutlet var movieLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var tvShowLabel: UILabel!
    
    var vc = profileVC()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favorIteLabel.text = NSLocalizedString("Favourites", comment: "Favourites")
        self.musicGenreTitleLabel.text = NSLocalizedString("Music Genre", comment: "Music Genre")
        self.dishTitleLabel.text = NSLocalizedString("Dish", comment: "Dish")
         self.songTitleLabel.text = NSLocalizedString("Song", comment: "Song")
         self.hobbyTitleLabel.text = NSLocalizedString("Hobby", comment: "Hobby")
        self.cityTitleLabel.text = NSLocalizedString("City", comment: "City")
        self.sportsTitleLabel.text = NSLocalizedString("Sport", comment: "Sport")
         self.bookTitleLabel.text = NSLocalizedString("Book", comment: "Book")
          self.movieTitleLabel.text = NSLocalizedString("Movie", comment: "Movie")
          self.colorTitleLabel.text = NSLocalizedString("Color", comment: "Color")
        self.tvShowTitleLabel.text = NSLocalizedString("TV Show", comment: "TV Show")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editButtonAction(_ sender: Any) {
        let nextVC = R.storyboard.settings.editFavouritesVC()
        self.vc.navigationController?.pushViewController(nextVC!, animated: true)
        
    }
}
