Pod::Spec.new do |spec|

  spec.name         = "GithubSearch"
  spec.version      = "0.0.1"
  spec.summary      = "Implementation of Github Search api."

  spec.homepage     = "https://github.com/SudhaChandranBC/GithubSearch"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Chandran, Sudha" => "sudhachandran1bc@gmail.com" }

  spec.ios.deployment_target = "9.0"
  spec.swift_version = "4.0"
  spec.source       = { :git => "https://github.com/SudhaChandranBC/GithubSearch.git", :tag => "#{spec.version}" }
  spec.source_files  = "GithubSearch/GithubSearch.swift"

end
