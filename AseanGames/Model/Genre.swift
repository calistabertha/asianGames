//
//
//  ProjectStructure
//
//  Created by Digital Khrisna on 6/19/17.
//  Copyright © 2017 codigo. All rights reserved.
//

import SwiftyJSON

class Genre {
    var genreId: Int
    
    init(genreId: Int) {
        self.genreId = genreId
    }
    
    convenience init(json: JSON){
        let genreId = json["genre_ids"].intValue
        
        self.init(genreId: genreId)
    }
}
