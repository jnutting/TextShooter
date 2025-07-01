//
//  ProductSpecFetcher.swift
//  TextShooter
//
//  Created by JN on 2017-4-19.
//  Copyright © 2017 Apress. All rights reserved.
//

import Foundation

@objc protocol ProductSpecFetcherDelegate {
    func productSpecFetcher(_ fetcher: ProductSpecFetcher, fetchedSpecsToUrl: URL)
    func productSpecFetcher(_ fetcher: ProductSpecFetcher, failedWithError: Error)
}

class ProductSpecFetcher: NSObject {
    weak var delegate: ProductSpecFetcherDelegate?
    let filename: String
    let remoteURL: URL
    
    @objc init(delegate: ProductSpecFetcherDelegate?, filename: String, remoteURL: URL) {
        self.filename = filename
        self.remoteURL = remoteURL
        super.init()
        self.delegate = delegate
        startFetching()
    }

    func filePathForLocalProductSpecs() -> URL {
        let searchPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentPath = searchPaths[0]
        var documentUrl = URL(fileURLWithPath: documentPath)
        documentUrl.appendPathComponent("\(filename).json")
        return documentUrl
    }

    @objc func productClusters() -> [TBTProductCluster]? {
        guard let urls = productSpecUrls() else { return nil }
        return productClustersFromFirstValidOfUrls(urls)
    }

    func productClustersFromFirstValidOfUrls(_ urls: [URL]) -> [TBTProductCluster]? {
        for url in urls {
            do {
                let data = try Data.init(contentsOf: url)
                let productSpecs = try productSpecsFromData(data)
                if let productClusters = TBTProductCluster.productClusters(fromSpecs: productSpecs) as? [TBTProductCluster] {
                    return productClusters
                }
            } catch {
                continue
            }
        }
        return nil
    }

     func productSpecUrls() -> [URL]? {
        let bundledUrl = Bundle.main.url(forResource: filename, withExtension: "json")!

        let downloadedUrl = filePathForLocalProductSpecs()

        let fm = FileManager.default
        if !fm.isReadableFile(atPath: downloadedUrl.path) {
            return [bundledUrl]
        }

        let downloadedAttrs: [FileAttributeKey : Any]
        do {
            downloadedAttrs = try fm.attributesOfItem(atPath: downloadedUrl.path)
        } catch {
            return [bundledUrl]
        }

        let bundledAttrs: [FileAttributeKey : Any]
        do {
            bundledAttrs = try fm.attributesOfItem(atPath: bundledUrl.path)
        } catch {
            return nil
        }

        if (bundledAttrs[FileAttributeKey.modificationDate] as! Date) < (downloadedAttrs[FileAttributeKey.modificationDate] as! Date) {
            return [downloadedUrl, bundledUrl]
        } else {
            return [bundledUrl, downloadedUrl]
        }
    }

}

enum ProductSpecError: Error {
    case dataIsNotDictionary
    case dictionaryContainsNoProductSpecs
}

func productSpecsFromData(_ data: Data) throws -> [NSDictionary] {
    do {
        guard let dict = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else { throw ProductSpecError.dataIsNotDictionary }
        guard let specs = dict["productSpecs"] as? [NSDictionary] else { throw ProductSpecError.dictionaryContainsNoProductSpecs }
        return specs
    } catch {
        print("failed to find correct data: \(error)")
        throw error
    }
}

fileprivate extension ProductSpecFetcher {
    func startFetching() {
        let request = URLRequest(url: remoteURL)
        NSURLConnection.sendAsynchronousRequest(request, queue: OperationQueue.main) { [weak self] (response, data, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("fetch failed, error \(error)")
                strongSelf.delegate?.productSpecFetcher(strongSelf, failedWithError: error)
                return
            } else if let data = data {
                let savedUrl = strongSelf.filePathForLocalProductSpecs()

                do {
                    // sanity check to make sure we got back something useful
                    let _ = try productSpecsFromData(data)

                    try data.write(to: savedUrl)
                } catch {
                    print("Error dealing with remote JSON: \(error)")

                    strongSelf.delegate?.productSpecFetcher(strongSelf, failedWithError: error)
                    return
                }
                strongSelf.delegate?.productSpecFetcher(strongSelf, fetchedSpecsToUrl: savedUrl)
            }
        }
    }
}
