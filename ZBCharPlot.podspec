Pod::Spec.new do |s|

	s.name             = "ZBPlotChart"
	s.version          = "1.0.1"
	s.summary          = "Graph for BoostCom Media projects"

	s.description      = <<-DESC
	Logic behind offers for internal projects.
	DESC

	s.homepage         = "https://bitbucket.org/dzmitryjbiesau/zbchartplot"
	s.license          = 'MIT'
	s.author           = { "Zmicier Biesau" => "dzmitry.biesau@bluepeole.no" }
	s.source           = { :git => "https://bitbucket.org/dzmitryjbiesau/zbchartplot.git", :tag => s.version.to_s }

	s.platform     = :ios, '8.0'
	s.requires_arc = true

	s.source_files = 'Pod/Classes/**/*'
end
