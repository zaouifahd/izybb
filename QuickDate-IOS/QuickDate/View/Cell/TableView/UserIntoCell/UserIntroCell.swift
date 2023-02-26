//
//  UserIntroCell.swift
//  QuickDate
//
//  Created by Ubaid Javaid on 12/14/20.
//  Copyright © 2020 Lê Việt Cường. All rights reserved.
//

import UIKit

class UserIntroCell: UITableViewCell {

    @IBOutlet var introLabel: UILabel!
    
    var otherUser: OtherUser? {
        didSet {
            guard let otherUser = otherUser else {
                Logger.error("getting other user"); return
            }
            
            var introText = showCountry(of: otherUser)
            introText += otherUser.userDetails.profile.description
            introText += "\n\(otherUser.userDetails.favourites.description)"
            introLabel.text = introText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func showCountry(of otherUser: OtherUser) -> String {
        guard let country = otherUser.userDetails.country else {
            return ""
        }
        return "I'm from \(country). "
    }
    
//    func bind(data:[String:Any]){
//        var relationship = ""
//        var ethnicity = ""
//        var body = ""
//        var height = ""
//        var hairColor = ""
//        var character = ""
//        var children = ""
//        var friends = ""
//        var pets = ""
//        var liveWith = ""
//        var car = ""
//        var religion = ""
//        var smoke = ""
//        var drink = ""
//        var music = ""
//        var dish = ""
//        var song = ""
//        var hobby = ""
//        var city = ""
//        var sport = ""
//        var book = ""
//        var movie = ""
//        var color = ""
//        var tvShow = ""
//
//        if let relationships = data["relationship_txt"] as? String{
//            let relation = "\("I'm") \(relationships), "
//            relationship = relation.htmlAttributedString ?? ""
//        }
//        if let ethenti = data["ethnicity_txt"] as? String{
//            let ethe = "\(ethenti) person, "
//            ethnicity = ethe.htmlAttributedString ?? ""
//        }
//        if let bodys = data["body_txt"] as? String{
//            body = "\("I'm") \(bodys) and "
//        }
//        if let heights = data["height_txt"] as? String{
//            height = "\(heights) tall, "
//        }
//        if let hairs = data["hair_color_txt"] as? String{
//            hairColor = "\("I have")\(" ")\(hairs)\(" ")\("hair,") "
//        }
//        if let charc = data["character_txt"] as? String{
//            character = "\("I'm") \(charc), person and "
//        }
//        if let friend = data["friends_txt"] as? String{
//            friends = "\("I have") \(friend), "
//        }
//        if let child = data["children_txt"] as? String{
//            children = "\("My Plan for childer : ")\(child), "
//        }
//        if let relig = data["religion_txt"] as? String{
//            religion = "\("I'm a ")\(relig), "
//        }
//        if let live = data["live_with_txt"] as? String{
//            liveWith = "\("I live with ")\(live), "
//        }
//        if let smok = data["smoke_txt"] as? String{
//            if smok == "Never"{
//                smoke = "I don't Smoke, "
//            }
//            else if (smok == ""){
//                smoke = ""
//            }
//            else{
//                smoke = "\("I smoke ")\(smok), "
//            }
//        }
//        if let drinks = data["drink_txt"] as? String{
//            if drinks == "Never"{
//                drink = "I don't Drink, "
//            }
//            else if (drinks == ""){
//                drink = ""
//            }
//            else{
//                drink = "\("I drink ")\(drinks), "
//            }
//        }
//        if let cars = data["car_txt"] as? String{
//            if cars == ""{
//                car = ""
//            }
//            else{
//            car = "\("Car : ")\(cars), "
//            }
//        }
//        if let musics = data["music"] as? String{
//            if musics == ""{
//                music = ""
//            }
//            else{
//                music = "\("Music : ")\(musics), "
//            }
//        }
//        if let dishes = data["dish"] as? String{
//            if dishes == ""{
//                dish = ""
//            }
//            else{
//                dish = "\("Dish : ")\(dishes), "
//            }
//        }
//        if let songs = data["song"] as? String{
//            if (songs == ""){
//                song = ""
//            }
//            else{
//            song = "\("Song : ")\(songs), "
//            }
//        }
//        if let hobbys = data["hobby"] as? String{
//            if (hobbys == ""){
//                hobby = ""
//            }
//            else{
//            hobby = "\("Hobby : ")\(hobbys), "
//            }
//        }
//        if let cities = data["city"] as? String{
//            if (cities == ""){
//                city = ""
//            }
//            else{
//                city = "\("City : ")\(cities), "
//            }
//        }
//        if let sports = data["sport"] as? String{
//            if (sports == ""){
//                sport = ""
//            }
//            else{
//                sport = "\("Sport : ")\(sports), "
//            }
//        }
//        if let books = data["book"] as? String{
//            if (books == ""){
//                book = ""
//            }
//            else{
//                book = "\("Book : ")\(books), "
//            }
//        }
//        if let movies = data["movie"] as? String{
//            if (movies == ""){
//                movie = ""
//            }
//            else{
//                movie = "\("Book : ")\(movies), "
//            }
//        }
//        if let colors = data["colour"] as? String{
//            if (colors == ""){
//                color = ""
//            }
//            else{
//                color = "\("Color : ")\(colors), "
//            }
//        }
//        if let tvs = data["tv"] as? String{
//            if (tvs == ""){
//                tvShow = ""
//            }
//            else{
//                tvShow = "\("Tv Show")\(tvs) . "
//            }
//        }
//        let intro_data = "\(relationship)\(ethnicity)\(body)\(height)\(hairColor)\(character)\(children)\(friends)\(pets)\(liveWith)\(car)\(religion)\(smoke)\(drink)\(music)\(dish)\(song)\(hobby)\(city)\(sport)\(book)\(movie)\(color)\(tvShow)"
//        self.introLabel.text = intro_data.htmlAttributedString
//
//    }
    
}

extension UserIntroCell: NibReusable {}
