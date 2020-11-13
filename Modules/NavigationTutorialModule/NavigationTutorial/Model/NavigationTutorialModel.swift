//
//  NavigationTutorialModel.swift
//  NavigationTutorialModule
//
//  Created by Vlad Z. on 2/19/20.
//  Copyright © 2020 Vlad Z. All rights reserved.
//

struct NavigationTutorialModel {
    var pages: [NavigationTutorialPage] {
        [
            NavigationTutorialPage(title: "Choose a player to start on-course navigation.",
                                   type: .player),
            NavigationTutorialPage(title: "Listen to the Frames for turn-by-turn directions to your destination.",
                                   type: .frames),
            NavigationTutorialPage(title: "At any point, you can tap the frames to get your bearings.",
                                   type: .direction([
                                       "At any point, you can tap the frames to get your bearings.",
                                       "Turn to your left.",
                                       "Tap the frames to get your bearings.",
                                       "Turn to your right.",
                                       "Tap the frames to get your bearings."
            ])),
            NavigationTutorialPage(title: "Touch your chin to your shoulder and say “Repeat” to hear the directions again.",
                                   type: .voice(0)),
            NavigationTutorialPage(title: "Touch your chin to your shoulder and say “Cancel” to stop navigation.",
                                   type: .voice(1))
        ]
    }
}
