Pod::Spec.new do |s|
  s.name         = "SLBannerView"
  s.version      = "1.0.1"
  s.summary      = "Use SLBannerView to quickly create a rotation view."
  s.description  = <<-DESC
	The advertising rotation diagram in the App is packaged into an independent module to simplify the development process
                   DESC

  s.homepage     = "https://github.com/TravelColor/SLBannerView"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author             = { "Travelcolor" => "978388776@qq.com" }
     
  s.source       = { :git => "https://github.com/TravelColor/SLBannerView.git", :tag => "1.0.1" }

  s.source_files  = "SLBannerViewDemo/SLBannerView", "SLBannerViewDemo/SLBannerView/*.{h,m}"
  s.resource_bundles = {'SLBannerView' => ['SLBannerViewDemo/SLBannerView/*.{jpg,xib}']}
  s.platform     = :ios, '9.0'
  s.requires_arc = true

  # s.exclude_files = "Classes/Exclude"

end
