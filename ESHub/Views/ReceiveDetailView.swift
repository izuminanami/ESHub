//
//  ReceiveDetailView.swift
//  ESHub
//
//  Created by 泉七海 on 2025/04/24.
//

import SwiftUI

struct ReceiveDetailView: View {
    let row: [String]
    var body: some View {
        GeometryReader { geometry in
            let titleWidth = geometry.size.width / 5
            let requestWidth = geometry.size.width / 3.5
            let titles = row[11].components(separatedBy: ", ")
            let times = row[12].components(separatedBy: ", ")
            let sounds = row[13].components(separatedBy: ", ")
            let lightings = row[14].components(separatedBy: ", ")
            
            ZStack {
                Color("backgroundColor")
                    .edgesIgnoringSafeArea(.all)
                ScrollView {
                    Spacer()
                        .frame(height: 20)
                    
                    Group {
                        Text("バンド名")
                            .padding(.vertical, 5)
                        Text(row[2])
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
                        
                        ForEach(titles.indices.filter { titles[$0] != "" }, id: \.self) { index in
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                Text(titles[index])
                                    .frame(width: titleWidth, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text(times[index] != "0:00" ? times[index] : "")
                                    .frame(width: 50, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text(index < sounds.count ? sounds[index] : "")
                                    .frame(width: requestWidth, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                Text(index < lightings.count ? lightings[index] : "")
                                    .frame(width: requestWidth, alignment: .leading)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    
                    if !row[15].isEmpty {
                        HStack {
                            Spacer()
                                .frame(width: geometry.size.width / 15)
                            
                            Text("合計時間：" + row[15])
                            
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
                            if !row[3].isEmpty {
                                HStack {
                                    HStack {
                                        Text("Vo.")
                                            .frame(width: 50)
                                        Text(":")
                                    }
                                    Text(row[3])
                                        .foregroundColor((row[3].first == "⭐︎" || row[3].first == "★") ? Color("primaryButtonColor") : .primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .padding(.horizontal)
                            }
                            if !row[4].isEmpty {
                                HStack {
                                    HStack {
                                        Text("Gt1.")
                                            .frame(width: 50)
                                        Text(":")
                                    }
                                    Text(row[4])
                                        .foregroundColor((row[4].first == "⭐︎" || row[4].first == "★") ? Color("primaryButtonColor") : .primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .padding(.horizontal)
                            }
                            if !row[5].isEmpty {
                                HStack {
                                    HStack {
                                        Text("Gt2.")
                                            .frame(width: 50)
                                        Text(":")
                                    }
                                    Text(row[5])
                                        .foregroundColor((row[5].first == "⭐︎" || row[5].first == "★") ? Color("primaryButtonColor") : .primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .padding(.horizontal)
                            }
                            if !row[6].isEmpty {
                                HStack {
                                    HStack {
                                        Text("Ba.")
                                            .frame(width: 50)
                                        Text(":")
                                    }
                                    Text(row[6])
                                        .foregroundColor((row[6].first == "⭐︎" || row[6].first == "★") ? Color("primaryButtonColor") : .primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .padding(.horizontal)
                            }
                            if !row[7].isEmpty {
                                HStack {
                                    HStack {
                                        Text("Dr.")
                                            .frame(width: 50)
                                        Text(":")
                                    }
                                    Text(row[7])
                                        .foregroundColor((row[7].first == "⭐︎" || row[7].first == "★") ? Color("primaryButtonColor") : .primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .padding(.horizontal)
                            }
                            if !row[8].isEmpty {
                                HStack {
                                    HStack {
                                        Text("Key.")
                                            .frame(width: 50)
                                        Text(":")
                                    }
                                    Text(row[8])
                                        .foregroundColor((row[8].first == "⭐︎" || row[8].first == "★") ? Color("primaryButtonColor") : .primary)
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
                        Text(row[9])
                        
                        Spacer()
                            .frame(height: 30)
                        
                        if !row[10].isEmpty {
                            Text("その他")
                                .font(.title3)
                            Spacer()
                                .frame(height: 10)
                            Text(row[10])
                                .padding(.horizontal)
                                .lineLimit(5)
                                .truncationMode(.tail)
                        }
                        
                        Spacer()
                            .frame(height: 30)
                        
                        Text("提出日時：" + row[0])
                            .padding(.vertical, 5)
                    }
                    Spacer()
                        .frame(height: 70)
                }
                VStack {
                    Spacer()
                    AdMobBannerView()
                        .frame(width: 320, height: 50)
                }
            }
            .navigationTitle("バンド詳細(横画面推奨)")
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
