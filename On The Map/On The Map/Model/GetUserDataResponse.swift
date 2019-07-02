//
//  GetUserDataResponse.swift
//  On The Map
//
//  Created by Sam Rich on 7/2/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//
// example json
//

//{"last_name":"Schowalter","social_accounts":[],"mailing_address":null,"_cohort_keys":[],"signature":null,"_stripe_customer_id":null,"guard":{},"_facebook_id":null,"timezone":null,"site_preferences":null,"occupation":null,"_image":null,"first_name":"Heber","jabber_id":null,"languages":null,"_badges":[],"location":null,"external_service_password":null,"_principals":[],"_enrollments":[],"email":{"address":"heber.schowalter@onthemap.udacity.com","_verified":true,"_verification_code_sent":true},"website_url":null,"external_accounts":[],"bio":null,"coaching_data":null,"tags":[],"_affiliate_profiles":[],"_has_password":true,"email_preferences":null,"_resume":null,"key":"665092666","nickname":"Heber Schowalter","employer_sharing":false,"_memberships":[],"zendesk_id":null,"_registered":false,"linkedin_url":null,"_google_id":null,"_image_url":"https://robohash.org/udacity-665092666"}
import Foundation
struct GetUserDataResponse: Codable {
    let lastName: String
    let socialAccount: String
    let mailing_address: String
    let cohortKeys: String
    let signature: String
    let stripe_customer_id: String
    let guardValue: String
    let facebookID: String
    let timezone: String
    let sitePreferences: String
    let occupation: String
    let image: String
    let firstName: String
    let jabber_id: String
    let languages: String
    let badges: String
    let location: String
    let externalServicePassword: String
    let principals: String
    let enrollments: String
    let email: String
    let websiteURL: String
    let externalAccounts: String
    let bio: String
    let coachingData: String
    let tags: String
    let affiliateProfiles: String
    
}
