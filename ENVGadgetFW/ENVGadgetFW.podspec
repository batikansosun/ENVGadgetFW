#
#  Be sure to run `pod spec lint ENVGadgetFW.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "ENVGadgetFW"
  spec.version      = "1.0"
  spec.summary      = "ENVGadgetFW is a CocoaPods library written in Swift"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
                   ENV Gadget is a framework that helps you to easily manage the service end-points, service keys and other constants.
                         DESC
  spec.homepage     = "https://github.com/batikansosun/Environment_Gadget"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.ios.deployment_target = "10.0"
  spec.swift_version = "4.0"

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }




  spec.author             = { "Batıkan Sosun" => "batikansosun@gmail.com" }
  # Or just: spec.author    = "Batıkan Sosun"
  # spec.authors            = { "Batıkan Sosun" => "batikansosun@gmail.com" }
  # spec.social_media_url   = "https://twitter.com/batikansosun"


  spec.source       = { :git => "https://github.com/batikansosun/Environment_Gadget.git", :tag => "#{spec.version}" }


  spec.source_files  = "Classes**/*.{swift}"
end
