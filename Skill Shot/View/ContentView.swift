//
//  ContentView.swift
//  Skill Shot
//
//  Created by William Key on 10/26/21.
//

import SwiftUI

struct ContentView: View {
    @State var selectedTab = 1
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "TabBarBackgroundColor")
        UITabBar.appearance().barTintColor = UIColor(named: "TabBarBackgroundColor")
        UITabBar.appearance().unselectedItemTintColor = UIColor(named: "TabBarUnselectedItemColor")
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LocationMapView()
                .tabItem {
                    Label("Map",
                          systemImage: "map"
                    )
                }
                .tag(1)
            AllLocationListView()
                .tabItem {
                    Label("List",
                          systemImage: "list.bullet.rectangle"
                    )
                }
                .tag(2)
            AllGameView()
                .tabItem {
                    Label("Games",
                          systemImage: "gamecontroller")
                }
                .tag(3)
        }
        .accentColor(Color("SkillShotTintColor"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
.previewInterfaceOrientation(.landscapeLeft)
    }
}
