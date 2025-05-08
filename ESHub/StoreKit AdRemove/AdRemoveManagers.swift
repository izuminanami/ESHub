//
//  AdRemoveManagers.swift
//  ESHub
//
//  Created by 泉七海 on 2025/05/07.
//

import SwiftUI
import StoreKit

@MainActor
class Store: ObservableObject {
    @Published var removeAdsProduct: Product?
    @Published var isPurchased: Bool = false
    private let removeAdsProductID = "com.NanamiIzumi.ESHub.removeAds"
    
    init() {
        self.isPurchased = UserDefaults.standard.bool(forKey: removeAdsProductID)
    }
    
    func loadProducts() async {
        self.removeAdsProduct = try? await Product.products(for: [removeAdsProductID]).first
        await checkPurchaseStatus()
        do {
            let products = try await Product.products(for: [removeAdsProductID])
            self.removeAdsProduct = products.first
        } catch {
            print("商品読み込みエラー: \(error)")
        }
    }
    
    func checkPurchaseStatus() async {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.productID == removeAdsProductID {
                    await MainActor.run {
                        self.isPurchased = true
                    }
                    return
                }
            default:
                continue
            }
        }
        
        // 未購入の場合
        await MainActor.run {
            self.isPurchased = false
        }
    }
    
    func purchase(product: Product) async {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                switch verification {
                case .verified:
                    print("購入成功")
                    // フラグを保存
                    UserDefaults.standard.set(true, forKey: removeAdsProductID)
                    await MainActor.run {
                        self.isPurchased = true
                    }
                case .unverified:
                    print("検証失敗")
                }
            case .userCancelled:
                print("キャンセル")
            case .pending:
                print("保留中")
            @unknown default:
                print("未知の状態")
            }
        } catch {
            print("購入エラー: \(error)")
        }
    }
    
    func checkPurchased() async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == removeAdsProductID {
                return true
            }
        }
        return false
    }
}
