//
//  CMTime + Extension.swift
//  iTunesMusicApp
//
//  Created by Артём Устинов on 30.12.2020.
//  Copyright © 2020 Artem Ustinov. All rights reserved.
//

import AVKit

extension CMTime {
     
    func toDisplayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return "" }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let timeFormatString = String(format: "%02d:%02d", minutes, seconds)
        return timeFormatString
    }
}
