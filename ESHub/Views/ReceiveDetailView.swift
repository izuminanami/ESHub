//
//  ReceiveDetailView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import SwiftUI

struct ReceiveDetailView: View {
    @StateObject private var store = Store()
    let entry: LiveEntry
    var body: some View {
        GeometryReader { geometry in
            let titleWidth = geometry.size.width / 5
            let requestWidth = geometry.size.width / 3.5
            
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    Spacer()
                        .frame(height: 20)
                    
                    Group {
                        Text("バンド名")
                            .padding(.vertical, 5)
                        Text(entry.bandName)
                            .font(.title3)
                            .foregroundColor(Color("primaryButtonColor"))
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Group {
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            Text("曲名")
                                .frame(width: titleWidth, alignment: .leading)
                            Text("時間")
                                .frame(width: 50, alignment: .leading)
                            Text("音響要望")
                                .frame(width: requestWidth, alignment: .leading)
                            Text("照明要望")
                                .frame(width: requestWidth, alignment: .leading)
                        }
                        .padding(.vertical, 5)
                        
                        ForEach(entry.songs.filter(\.hasTitle)) { song in
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                Text(song.title)
                                    .frame(width: titleWidth, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text(song.formattedDuration != "0:00" ? song.formattedDuration : "")
                                    .frame(width: 50, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text(song.sound)
                                    .frame(width: requestWidth, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text(song.lighting)
                                    .frame(width: requestWidth, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    
                    if entry.totalDurationSeconds > 0 {
                        HStack {
                            Spacer()
                                .frame(width: geometry.size.width / 15)
                            
                            Text("合計時間：" + entry.totalDurationText)
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                        .frame(height: 30)
                    
                    Group {
                        Text("バンドメンバー")
                            .font(.title3)
                            .padding(.vertical, 5)
                        
                        VStack(alignment: .leading) {
                            ForEach(entry.members.filter(\.hasName)) { member in
                                HStack {
                                    HStack {
                                        Text(member.role)
                                            .frame(width: 50)
                                        Text(":")
                                    }
                                    Text(member.name)
                                        .foregroundColor((member.name.first == "⭐︎" || member.name.first == "★") ? Color("primaryButtonColor") : .primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Text("SE")
                            .font(.title3)
                        Spacer()
                            .frame(height: 10)
                        Text(entry.seEnabled ? "あり" : "なし")
                        
                        Spacer()
                            .frame(height: 30)
                        
                        if !entry.otherRequest.isEmpty {
                            Text("その他")
                                .font(.title3)
                            Spacer()
                                .frame(height: 10)
                            Text(entry.otherRequest)
                                .padding(.horizontal)
                                .lineLimit(5)
                                .truncationMode(.tail)
                        }
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Text("提出日時：" + entry.createdAtText)
                            .padding(.vertical, 5)
                    }
                    Spacer()
                        .frame(height: 70)
                }
                if !store.isPurchased {
                    AdBannerContainerView()
                }
            }
            .navigationTitle("バンド詳細(横画面推奨)")
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
