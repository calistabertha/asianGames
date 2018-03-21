//
//  Constants.swift
//  ProjectStructure
//
//  Created by Digital Khrisna on 6/16/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import Foundation

enum BuildType {
    case development
    case stagging
    case production
}

struct Config {
    static let appKey = "a5120ae232de05c4b3b54a1a8a8bfd17"
    
    /*
     *  Define URL of REST API
     */
    static let developmentBaseAPI = "http://api.asian-games.dev.codigo.id/"
    static let staggingBaseAPI = "http://api.asian-games.stg.codigo.id/"
    static let productionBaseAPI = "http://api.asian-games.stg.codigo.id/"
    
    /*
     *  Define base URL of picture
     */
    static let basePictureAPI = "https://image.tmdb.org/t/p/w500"
}

struct REST {
    struct Movie {
        static let popular = "movie/popular"
        static let topRated = "movie/top_rated"
    }
}

struct API {
    struct Auth {
        static let generateToken = "auth/token?api_key=YTM89P7d8J&api_secret=upMK8HgHUp41WrTRtIwE"
        static let login = "auth/login"
    }
    
    struct Announcement {
        static let home = "announcements"
        static let pinned = "announcements/pinned"
        static let recent = "announcements/recent"
        static let history = "announcements/history"
    }
    
    struct Agenda {
        static let home = "agendas"
        static let history = "agendas/history"
    }
    
    struct People {
        static let people = "people"
        static let group = "people/group"
        static let friends = "people/friends"
        static let search = "people/search?keyword="
        static let profile = "users"
    }
    
    struct Settings {
        static let profile = "users"
    }
}

struct StoryboardReferences {
    static let main = "Main"
    static let authentication = "Authentication"
    
}

struct ViewControllerID {
    
    struct Authentication {
        static let login = "SignInViewController"
        static let register = "RegisterViewController"
        static let newPass = "NewPasswordViewController"
        static let forgot = "ForgotPasswordViewController"
    }
    
    struct Announcement {
        static let list = "ListAnnouncementViewController"
        static let create = "CreateAnnouncementViewController"
        static let comment = "CommentViewController"
        static let detail = "DetailAnnouncemenViewController"
    }
    
    struct Agenda {
        static let history = "HistoryAgendaViewController"
        static let detail = "DetailAgendaViewController"
        static let create = "CreateAgendaViewController"
    }
    
    struct People {
        static let group = "GroupViewController"
        static let friends = "FriendsViewController"
        static let detail = "DetailGroupViewController"
        static let listFriends = "ListFriendsViewController"
        static let announcement = "PeopleAnnouncementViewController"
        static let detailFriends = "DetailFriendsViewController"
        static let profile = "ProfileFriendsViewController"
        static let agenda = "AgendaFriendsViewController"
    }
    
    struct Settings {
        static let profile = "ProfileViewController"
        static let help = "HelpViewController"
        static let FAQ = "FAQViewController"
        static let support = "SupportViewController"
        static let change = "ChangePasswordViewController"
    }
}
