//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!

    // Properties
    let API_KEY = fetchAPIKey(name: "API_KEY")
    let API_SECRET_KEY = fetchAPIKey(name: "API_SECRET_KEY")
    var swifter: Swifter {
        guard let apiKey = API_KEY else {
            fatalError("Error fetching API Key. Make sure you have the correct key name")
        }
        guard let apiSecretKey = API_SECRET_KEY else {
            fatalError("Error fetching API Key. Make sure you have the correct key name")
        }

        return Swifter(consumerKey: apiKey, consumerSecret: apiSecretKey)
    }
    let sentimentClassifier = TweetSentimentClassifier()
    let tweetCount = 100
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        
        fetchTweets()
        
    }
    
    func fetchTweets() {
        
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, _) in
                var tweets = [TweetSentimentClassifierInput]()
                
                for num in 0..<100 {
                    if let tweet = results[num]["full_text"].string {
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        
                        tweets.append(tweetForClassification)
                        print("\(num) \(tweet)")
                    }
                }
                
                self.makePrediction(with: tweets)
            }) { (error) in
                print("There was an error with the Twitter API Request, \(error)")
            }
        }
        
    }
    
    func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore = 0
            
            for prediction in predictions {
                let sentiment = prediction.label
                
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            
            updateUI(with: sentimentScore)
            
        } catch {
            print("There was an error with making a prediciton, \(error)")
        }
        
    }
    
    func updateUI(with sentimentScore: Int) {
        
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😃"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤮"
        }
        
        print("sentimentScore: \(sentimentScore)")
        
    }
    
}
