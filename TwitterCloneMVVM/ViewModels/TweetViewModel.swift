//
//  TweetViewModel.swift
//  TwitterCloneMVVM
//
//  Created by Wallace Santos on 06/01/23.
//

import UIKit

struct TweetViewModel {
    let tweet:Tweet
    let user:User
//MARK: - Life Cycle
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
//MARK: - Properties
    var profileImageURL : URL?{
        return tweet.user.profileImageUrl
    }
    
    var userFullName:String{
        return user.fullname
    }
    
    var userName:String{
        return "@\(user.username)"
    }
    
    var timestamp:String{
        let formmater = DateComponentsFormatter()
        formmater.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formmater.maximumUnitCount = 1
        formmater.unitsStyle = .brief
        let now = Date()
        return formmater.string(from: tweet.timestamp, to: now) ?? ""
    }
    
    var tweetDate:String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a · dd/MM/yyyy"
        return formatter.string(from: tweet.timestamp)
    }

    var userInfoText:NSAttributedString{
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let name = NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        let date = NSAttributedString(string: " · \(timestamp)", attributes: [.font:UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        
        title.append(name)
        title.append(date)
        
        return title
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage : UIImage{
        let imageName = tweet.didLike ? Constants.TweetCellImages.likeFill : Constants.TweetCellImages.like
        return UIImage(imageLiteralResourceName: imageName)
    }
    
    
    var retweetsAttributedString:NSAttributedString{
        return NSAttributedString().attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likesAttributedString:NSAttributedString{
        return NSAttributedString().attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var replyingToTextShouldHide:Bool{
        return !tweet.replyingExist
    }
    
    var replyingToText:String?{
        guard let replyingTo = tweet.replyingTo else {return nil}
        return "→ replying to @\(replyingTo)"
    }
    
//MARK: - Helpers
/* Aqui implementamos uma funcao para nos auxiliar a descobrir o tamanho ideal da celula para cada texto que a acompanha, sendo assim, instanciamos uma label e aplicamos o texto do tweet, atraves da linha 73 pegamos o CGSize desta label que acomodou nosso texto e retornamos a altura dela*/
    func size(forWidth width:CGFloat) -> CGFloat{
        let mesurementLabel = UILabel()
        mesurementLabel.text = tweet.caption
        mesurementLabel.numberOfLines = 0
        mesurementLabel.lineBreakMode = .byWordWrapping
        mesurementLabel.translatesAutoresizingMaskIntoConstraints = false
        mesurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        let size = mesurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size.height
        
    }
}
