//
//  GetPhotoInfoResponse.swift
//  Virtual Tourist
//
//  Created by Sam Rich on 7/1/19.
//  Copyright © 2019 Sam Rich. All rights reserved.
//

import Foundation

// example response
//{"photo":{"id":"48162952266","secret":"5c68aa1759","server":"65535","farm":66,"dateuploaded":"1561923864","isfavorite":0,"license":"0","safety_level":"0","rotation":0,"owner":{"nsid":"163949237@N08","username":"CraDorPhoto","realname":"Craig Dorman","location":"","iconserver":"7893","iconfarm":8,"path_alias":null},"title":{"_content":"Baylands Dawn"},"description":{"_content":"Baylands, Palo Alto, California, USA"},"visibility":{"ispublic":1,"isfriend":0,"isfamily":0},"dates":{"posted":"1561923864","taken":"2018-02-04 15:07:35","takengranularity":"0","takenunknown":"0","lastupdate":"1562006326"},"views":"603","editability":{"cancomment":0,"canaddmeta":0},"publiceditability":{"cancomment":1,"canaddmeta":0},"usage":{"candownload":0,"canblog":0,"canprint":0,"canshare":1},"comments":{"_content":"12"},"notes":{"note":[]},"people":{"haspeople":0},"tags":{"tag":[{"id":"163856424-48162952266-242392615","author":"163949237@N08","authorname":"CraDorPhoto","raw":"Canon 5DSR","_content":"canon5dsr","machine_tag":0},{"id":"163856424-48162952266-1695","author":"163949237@N08","authorname":"CraDorPhoto","raw":"Landscape","_content":"landscape","machine_tag":0},{"id":"163856424-48162952266-800","author":"163949237@N08","authorname":"CraDorPhoto","raw":"Water","_content":"water","machine_tag":0},{"id":"163856424-48162952266-552","author":"163949237@N08","authorname":"CraDorPhoto","raw":"reflection","_content":"reflection","machine_tag":0},{"id":"163856424-48162952266-791","author":"163949237@N08","authorname":"CraDorPhoto","raw":"Nature","_content":"nature","machine_tag":0},{"id":"163856424-48162952266-1804","author":"163949237@N08","authorname":"CraDorPhoto","raw":"Outside","_content":"outside","machine_tag":0},{"id":"163856424-48162952266-1860","author":"163949237@N08","authorname":"CraDorPhoto","raw":"Outdoors","_content":"outdoors","machine_tag":0},{"id":"163856424-48162952266-50","author":"163949237@N08","authorname":"CraDorPhoto","raw":"California","_content":"california","machine_tag":0},{"id":"163856424-48162952266-351","author":"163949237@N08","authorname":"CraDorPhoto","raw":"USA","_content":"usa","machine_tag":0},{"id":"163856424-48162952266-282","author":"163949237@N08","authorname":"CraDorPhoto","raw":"Sky","_content":"sky","machine_tag":0},{"id":"163856424-48162952266-1223","author":"163949237@N08","authorname":"CraDorPhoto","raw":"Clouds","_content":"clouds","machine_tag":0},{"id":"163856424-48162952266-1370","author":"163949237@N08","authorname":"CraDorPhoto","raw":"Sunrise","_content":"sunrise","machine_tag":0}]},"location":{"latitude":"37.455165","longitude":"-122.109110","accuracy":"16","context":"0","neighbourhood":{"_content":"","woeid":0}},"geoperms":{"ispublic":1,"iscontact":0,"isfriend":0,"isfamily":0},"urls":{"url":[{"type":"photopage","_content":"https:\/\/www.flickr.com\/photos\/163949237@N08\/48162952266\/"}]},"media":"photo"},"stat":"ok"}

struct GetPhotoInfoResponse: Codable {
    let photo: PhotoInfo

}

struct PhotoInfo: Codable {
    let id: String
    let secret: String
}
