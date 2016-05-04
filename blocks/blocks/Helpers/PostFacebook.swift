//
//  postFacebook.swift
//  blocks
//
//  Created by Ian Richardson on 8/22/14.
//  Copyright (c) 2014 3 Screen Apps. All rights reserved.
//

import Foundation
import Accounts
import Social

class PostFacebook{
    
    class func postToFacebook(message: String, appID: String){
        postOnFacebook(message, appID:appID, photo:"", url: "feed")
    }
    
    class func postToFacebookWithImage(message: String, appID: String, photo: String){
        postOnFacebook(message, appID:appID, photo:photo, url: "photos")
    }
    
    class func postOnFacebook(message: String, appID: String, photo: String, url: String){
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierFacebook)
        
        let optionsForPosting = [ACFacebookAppIdKey:appID, ACFacebookPermissionsKey: ["email"], ACFacebookAudienceKey: ACFacebookAudienceFriends]

        accountStore.requestAccessToAccountsWithType(accountType, options: optionsForPosting as [NSObject : AnyObject]) {
            granted, error in
            if granted {
                    
                let options = [ACFacebookAppIdKey:appID, ACFacebookPermissionsKey: ["publish_actions"], ACFacebookAudienceKey: ACFacebookAudienceFriends]

                accountStore.requestAccessToAccountsWithType(accountType, options: options as [NSObject : AnyObject]) {
                    granted, error in
                    if granted {
                        var accountsArray = accountStore.accountsWithAccountType(accountType)
                        
                            if accountsArray.count > 0 {
                            let facebookAccount = accountsArray[0] as! ACAccount
                            
                            var parameters = Dictionary<String, AnyObject>()
                            parameters["access_token"] = facebookAccount.credential.oauthToken
                            parameters["message"] = message
                            
                            let feedURL = NSURL(string: "https://graph.facebook.com/me/\(url)")
                            let posts = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.POST, URL: feedURL, parameters: parameters)
                                
                            if photo.characters.count > 0{
                                let appIcon = UIImage(named: photo)
                                let iconData = UIImagePNGRepresentation(appIcon!)
                                posts.addMultipartData(iconData, withName: "picture", type: "image/png", filename: "Icon")
                            }
                
                            let handler: SLRequestHandler =  { (response, urlResponse, error) in
                                print(response.description)
                                print(error)
                                print(urlResponse.statusCode)
                            }
                
                            posts.performRequestWithHandler(handler)
                        }
                    }
                    else{
                        NSNotificationCenter.defaultCenter().postNotificationName("facebookFailed", object: nil)
                        print(error.localizedDescription)
                    }
                }
            }
            else{
                NSNotificationCenter.defaultCenter().postNotificationName("facebookFailed", object: nil)
                print(error.localizedDescription, terminator: "")
            }
        }
    }
    
}