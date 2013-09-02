#extension.pp

define thunderbird::extension (	$src = undef,
				$dst = "/usr/lib/thunderbird/extensions",	
				){
	exec { "download extension $name":
		command => "/usr/bin/wget ${src} -O ${dst}/${name}.xpi",
		creates => "${dst}/${name}.xpi",
		notify => Exec["extract extension $name"],
	}
	
	if ! defined(Package['xmlstarlet']) { package { "xmlstarlet": ensure => installed } }
	if ! defined(Package['unzip']) { package {"unzip": ensure => installed } }

	exec { "extract extension $name":
		refreshonly => true,
		cwd => $dst,
		command => "unzip ${name}.xpi -d `unzip -qc ${name}.xpi install.rdf | xmlstarlet sel -N rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns# -N em=http://www.mozilla.org/2004/em-rdf# -t -v \"//rdf:Description[@about='urn:mozilla:install-manifest']/em:id\"`",
		require => Package[ ["unzip","xmlstarlet"] ],
	}
}
