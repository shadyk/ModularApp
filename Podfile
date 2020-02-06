# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'


####COMMON PODS
def common_pods
  pod 'Alamofire'
  pod 'SwiftyBeaver'
end

####APP
target 'App' do
  use_frameworks!
  common_pods
  target 'AppTests' do
    inherit! :search_paths
  end

end

####AUTH
target 'Auth' do
  use_frameworks!
  common_pods
  target 'AuthTests' do
  end

####API
  target 'API' do
    use_frameworks!
    common_pods
    target 'APITests' do
      inherit! :search_paths
    end
  end

####CRYPTO
  target 'Crypto' do
    use_frameworks!
    pod 'SwiftyRSA'
    pod 'CryptoSwift', '0.7.1'
    pod 'SwiftyBeaver'
    target 'CryptoTests' do
      inherit! :search_paths
    end
  end
end
